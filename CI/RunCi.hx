import sys.FileSystem;

using StringTools;
using Lambda;

class RunCi {
  static var ue4:String = Sys.getEnv('UE4');
  static var haxeServer:Null<Int> = Std.parseInt(Sys.getEnv('HAXESERVER'));
  static var systemName = Sys.systemName();
  static var workspace:String;
  static var debug = Sys.getEnv("DEBUG") == "1";
  static var verbose = Sys.getEnv("VERBOSE") == "1";
  static var config = Sys.getEnv('BUILD_CONFIG') == null ? 'Development' : Sys.getEnv('BUILD_CONFIG');
  static var platform:String = Sys.getEnv('BUILD_PLATFORM');
  static var headless:Bool = Sys.getEnv('HEADLESS') == "1";
  static var service:Bool = Sys.getEnv('SERVICE') == "1";
  static var interactive:Bool = Sys.getEnv("INTERACTIVE") == "1";
  static var normalMalloc:Bool = Sys.getEnv("NORMAL_MALLOC") == "1";
  static var setServer = false;

  public static function main() {
    try {
      runMain();
    }
    catch(e:String) {
      Sys.stderr().writeString('Error: $e\n');
      Sys.exit(1);
    }
  }

  static function runMain() {
    if (ue4 == null) {
      throw 'Cannot find UE4 location. Please set the UE4 env var';
    }
    workspace = FileSystem.fullPath(haxe.io.Path.directory(Sys.programPath()) + '/../..');
    if (!debug) {
      Sys.putEnv('CI', '1');
      Sys.putEnv('CI_RUNNING', '1');
    }
    if (platform == null) {
      switch(systemName) {
      case 'Linux':
        platform = 'Linux';
      case 'Mac':
        platform = 'Mac';
      case 'Windows':
        platform = 'Win64';
      }
    }

    for (test in detectionTests) {
      if (test.files != null) {
        for (file in test.files.keys()) {
          if (FileSystem.exists(file)) {
            FileSystem.deleteFile(file);
          }
        }
      }
    }

    function doTargets(targets:Array<String>) {
      var envs = [
        { name:'UE4', desc:'The path to the UE4 install dir' },
        { name:'HAXESERVER', desc:'The port of an already open haxe compilation server' },
        { name:'DEBUG', desc:'Call the target with a debugger attached' },
        { name:'BUILD_CONFIG', desc:'Build configuration. Defaults to Development' },
        { name:'BUILD_PLATFORM', desc:'Build platform. Defaults to current platform' },
        { name:'VERBOSE', desc:'Build with verbose flag' },
        { name:'SERVICE', desc:'This is called under a service and an intermediate caller must be made for GUI applications' },
        { name:'INTERACTIVE', desc:'This is set if compile-detection should run in interactive mode' },
        { name:'NORMAL_MALLOC', desc:'Use the system default malloc system (otherwise, -binnedmalloc2 is used)' },
        { name:'EXTRA_UE4_ARGS', desc:'Extra UE4 arguments' },
      ];
      var avTargets = [
        { name:'all', desc:'A shorthand for `build-initial build main pass3 run-hotreload run-cserver`', fn:doTargets.bind(['build-initial','build','main','pass3','run-hotreload','run-cserver'])},
        { name:'fast', desc:'A shorthand for `build pass0 pass1 run pass2 run pass3`', fn:doTargets.bind(['build', 'pass0', 'pass1', 'run', 'pass2', 'run', 'pass3'])},
        { name:'main', desc:'The main build check - shorthand for `build pass0 cmd run pass1 run pass2 run', fn:doTargets.bind(['build','pass0','cmd','run','pass1','run','pass2','run'])},
        { name:'compile-detection[-n]', desc:'Performs some static compilation tests', fn:null },
        { name:'build-initial', desc:'Performs a full editor (initial) build', fn:doInitialBuild },
        { name:'build', desc:'Performs a full editor build', fn:doBuild },
        { name:'cmd', desc:'Runs a test commandlet', fn:doCmd },
        { name:'run', desc:'Runs the main unit tests', fn:doRun },
        { name:'pass2-9', desc:'Builds the incremental cppia passes', fn:null },
        { name:'run-hotreload', desc:'Runs the hot reload tests', fn:doHotReload },
        { name:'run-cserver', desc:'Runs the client-server tests', fn:doCServer },
        { name:'cooked-test', desc:'A shorthand for `build-cooked run-cooked', fn:doTargets.bind(['build-cooked','run-cooked']) },
        { name:'build-cooked', desc:'Builds a cooked game', fn:doBuildCooked },
        { name:'build-cooked-server', desc:'Builds a cooked game', fn:doBuildCookedServer },
        { name:'run-cooked', desc:'Runs a cooked game', fn:doRunCooked },
        { name:'build-program', desc:'Builds a program (only works with dev engines)', fn:doBuildProgram },
        { name:'run-program', desc:'Runs the program', fn:doRunProgram },
      ];
      if (targets == null || targets.length == 0) {
        // help
        var buf = new StringBuf();
        buf.add('Available targets:\n');
        for (target in avTargets) {
          buf.add('  ${target.name} : ${target.desc}\n');
        }
        buf.add('Environment variables:\n');
        for (env in envs) {
          buf.add('  ${env.name} : ${env.desc}\n');
        }
        Sys.println(buf.toString());
        return;
      }

      for (target in targets) {
        var spec = avTargets.find(function(t) return t.name == target);
        var fn = null;
        if (spec == null || spec.fn == null) {
          if (target.startsWith('pass')) {
            var pass = Std.parseInt(target.substr('pass'.length));
            fn = doPass.bind(pass, target.endsWith('-noBuild'));
          } else if (target.startsWith('compile-detection')) {
            var start = Std.parseInt(target.substr('compile-detection'.length + 1));
            if (start == null) {
              start = 0;
            }
            fn = doCompileDetection.bind(start);
          } else {
            throw 'Cannot find target $target';
          }
        } else {
          fn = spec.fn;
        }

        Sys.println('\n\n\n\n#########################################################');
        Sys.println('###### Running $target');
        Sys.println('#########################################################\n');
        fn();
      }
    }
    doTargets(Sys.args());
  }

  static function doCompileDetection(start:Int) {
    if (!FileSystem.exists('$workspace/Haxe/Scripts/generated')) {
      FileSystem.createDirectory('$workspace/Haxe/Scripts/generated');
    }
    Sys.putEnv('UHXBUILD_ASSERT_CPPIA_CHANGE', '');
    Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', '');
    // simple build first
    for (test in detectionTests) {
      if (test.files != null) {
        for (file in test.files.keys()) {
          if (FileSystem.exists(file)) {
            FileSystem.deleteFile(file);
          }
        }
      }
    }
    doBuild();

    var isInteractive = interactive;
    var i = 0;
    for (test in detectionTests) {
      if (i < start) {
        i++;
        continue;
      }
      if (isInteractive) {
        Sys.println('\n#############################################');
        Sys.println('###### Interactive compile detection #$i: needsCppia ${test.needsCppia} needsStatic ${test.needsStatic}');
        Sys.println('#############################################\n');
        Sys.println('\nfiles:\n\n' + test.files);
        Sys.println('\n\nShould run?(y/n)');
        var ln = null;
        while (( ln = Sys.stdin().readLine().trim().toLowerCase() ) != 'y' && ln != 'n' ) {
          // keep looping
          Sys.println('(y/n)');
        }
        if (ln == 'n') {
          continue;
        } else {
          isInteractive = false;
        }
      }
      if (test.files != null) {
        for (file in test.files.keys()) {
          sys.io.File.saveContent(workspace + '/' + file, test.files[file]);
        }
      }

      if (i != start || i == 0) {
        Sys.putEnv('UHXBUILD_ASSERT_CPPIA_CHANGE', test.needsCppia ? '1':'0');
        if (test.needsStatic == null) {
          Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', '');
        } else {
          Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', test.needsStatic ? '1':'0');
        }
      }

      Sys.println('\n#############################################');
      Sys.println('###### Running compile detection #$i: needsCppia ${test.needsCppia} needsStatic ${test.needsStatic}');
      Sys.println('#############################################\n');

      try {
        if (test.needsCppia && test.needsStatic && Sys.getEnv("CPPIA_COMPILE_TEST") == "1") {
          var passed = false;
          try {
            runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml']);
          }
          catch(e:Dynamic) {
            passed = true;
          }
          if (!passed) {
            throw 'Cppia-only build should have failed, but has not';
          }
        }
        doBuild();
      }
      catch(e:Dynamic) {
        if (test.files != null) test.files.toString();
        trace('failed at $i');
        trace('previous: ${detectionTests[i-1]}');
        trace('needsCppia ${test.needsCppia} needsStatic ${test.needsStatic}');
        trace('Error: ${test.files}');
        throw e;
      }
      i++;
    }

    Sys.putEnv('UHXBUILD_ASSERT_CPPIA_CHANGE', '');
    Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', '');
  }

  static function doInitialBuild() {
    for (file in files.keys()) {
      trace('saving $file');
      sys.io.File.saveContent(workspace + '/' + file, files[file]);
    }

    runUBT([platform, config, 'HaxeUnitTestsEditor', '-project=$workspace/HaxeUnitTests.uproject']);
  }

  static function doBuild() {
    for (file in files.keys()) {
      var file = workspace + '/' + file;
      if (FileSystem.exists(file)) {
        FileSystem.deleteFile(file);
      }
    }

    runUBT([platform, config, 'HaxeUnitTestsEditor', '-project=$workspace/HaxeUnitTests.uproject']);
  }

  static function doCmd() {
    var stamp = Date.now().toString();
    Sys.putEnv('CUSTOM_STAMP', stamp);
    runUE(['$workspace/HaxeUnitTests.uproject', '-run=HaxeUnitTests.UpdateAsset', stamp, '-AllowStdOutLogVerbosity'], true, false);
  }

  static function doRun() {
    runUE(['$workspace/HaxeUnitTests.uproject', '-server', '/Game/Maps/HaxeTestEntryPoint', '-stdout', '-AllowStdOutLogVerbosity'], true, true);
  }

  static function doPass(n:Int, ensureNoBuild:Bool) {
    if (ensureNoBuild) {
      Sys.putEnv('UHXBUILD_ASSERT_CPPIA_CHANGE', '0');
      Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', '0');
    }

    if (n == 0) {
      runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml', '-D', 'ignoreStaticErrors']);
    } else if (haxeServer == null) {
      if (n == 1) {
        Sys.putEnv("UHX_INTERNAL_ARGS", "-D pass=1");
        doBuild();
        Sys.putEnv("UHX_INTERNAL_ARGS", '');
      } else {
        runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml', '-D', 'ignoreStaticErrors', '-D', 'pass=$n']);
      }
    } else {
      PassExpand.run('$workspace/Haxe/Scripts', n);
      if (n == 1) {
        doBuild();
      } else {
        runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml', '-D', 'ignoreStaticErrors']);
      }
    }

    if (ensureNoBuild) {
      Sys.putEnv('UHXBUILD_ASSERT_CPPIA_CHANGE', '');
      Sys.putEnv('UHXBUILD_ASSERT_STATIC_CHANGE', '');
    }
  }

  static function doHotReload() {
    runUE(['$workspace/HaxeUnitTests.uproject', '-ExecCmds=Automation RunTests HotReloadAutomation; Quit', '-stdout', '-AllowStdOutLogVerbosity']);
  }

  static function doCServer() {
    runUE(['$workspace/HaxeUnitTests.uproject', '-ExecCmds=Automation RunTests ClientServerAutomation', '-stdout', '-AllowStdOutLogVerbosity']);
  }

  static function doBuildCooked() {
    runUBT([platform, config, 'HaxeUnitTests', '-project=$workspace/HaxeUnitTests.uproject']);
    runUAT(['BuildCookRun', '-platform=$platform', '-project=$workspace/HaxeUnitTests.uproject', '-cook', '-nocompile', '-serverplatform=$platform', '-clientconfig=$config', '-serverconfig=$config', '-allmaps', '-stage', '-pak', '-archive', '-prereqs', '-archivedirectory=$workspace/bin', '-distribution']);
  }

  static function doBuildCookedServer() {
    runUBT([platform, config, 'HaxeUnitTestsServer', '-project=$workspace/HaxeUnitTests.uproject']);
    runUAT(['BuildCookRun', '-platform=$platform', '-project=$workspace/HaxeUnitTests.uproject', '-server', '-cook', '-nocompile', '-serverplatform=$platform', '-clientconfig=$config', '-serverconfig=$config', '-allmaps', '-stage', '-pak', '-archive', '-prereqs', '-archivedirectory=$workspace/bin', '-distribution']);
  }

  static function doRunCooked() {
    var name = switch(systemName) {
      case 'Windows':
        'WindowsNoEditor/HaxeUnitTests/Binaries/Win64/HaxeUnitTests.exe';
      case 'Mac':
        'MacNoEditor/HaxeUnitTests/Binaries/Mac/HaxeUnitTests';
      case 'Linux':
        'LinuxNoEditor/HaxeUnitTests/Binaries/Linux/HaxeUnitTests';
      case _: throw 'Invalid Platform';
    }
    // var old = Sys.getCwd();
    // Sys.setCwd('$workspace/bin');
    var args = ['-server', '/Game/Maps/HaxeTestEntryPoint', '-stdout', '-AllowStdOutLogVerbosity'];
    if (headless) {
      args.push('-nullrhi');
      args.push('-unattended');
    }
    callOrDebug('$workspace/bin/$name', args);
  }

  static function doBuildProgram() {
    runUBT([platform, 'Shipping', 'HaxeProgramTest', '-project=$workspace/HaxeUnitTests.uproject']);
  }

  static function doRunProgram() {
  }

  static function runUE(args:Array<String>, throwOnError=true, gui=true) {
    if (headless) {
      args.push('-nullrhi');
      args.push('-unattended');
    }
    if (config.toLowerCase() == 'debuggame') {
      args.push('RunConfig=Debug');
    }
    if (!normalMalloc)
    {
      args.push('-binnedmalloc2');
    }
    var extra = Sys.getEnv('EXTRA_UE4_ARGS');
    if (extra != null)
    {
      args.push(extra);
    }
    var old = Sys.getCwd();
    Sys.setCwd(ue4);
    var ret = switch(systemName) {
      case 'Mac':
        callOrDebug('./Engine/Binaries/Mac/UE4Editor.app/Contents/MacOS/UE4Editor', args, throwOnError, gui);
      case 'Linux':
        callOrDebug('./Engine/Binaries/Linux/UE4Editor', args, throwOnError, gui);
      case _:
        callOrDebug('./Engine/Binaries/Win64/UE4Editor.exe', args, throwOnError, gui);
    };
    Sys.setCwd(old);
    return ret;
  }


  static function runUAT(args:Array<String>, throwOnError=true) {
    var old = Sys.getCwd();
    Sys.setCwd(ue4);
    var ret = switch(systemName) {
      case 'Mac':
        call('./Engine/Build/BatchFiles/RunUAT.sh', args, throwOnError);
      case 'Linux':
        call('./Engine/Build/BatchFiles/RunUAT.sh', args, throwOnError);
      case _:
        call('./Engine/Build/BatchFiles/RunUAT.bat', args, throwOnError);
    };
    Sys.setCwd(old);
    return ret;
  }

  static function runHaxe(args:Array<String>, throwOnError=true) {
    return call('haxe', args, throwOnError);
  }

  static function runUBT(args:Array<String>, throwOnError=true) {
    if (!setServer) {
      setServer = true;
      // var data = '{}';
      if (haxeServer != null) {
        sys.io.File.saveContent('$workspace/uhxconfig-local.json', '{ "compilationServer": $haxeServer }');
      } else if (FileSystem.exists('$workspace/uhxconfig-local.json')) {
        FileSystem.deleteFile('$workspace/uhxconfig-local.json');
      }
    }
    if (verbose) {
      args.push('-verbose');
    }

    var old = Sys.getCwd();
    Sys.setCwd(ue4);
    var ret = switch(systemName) {
      case 'Mac':
        call('./Engine/Build/BatchFiles/Mac/Build.sh', args, throwOnError);
      case 'Linux':
        call('./Engine/Build/BatchFiles/Linux/Build.sh', args, throwOnError);
      case _:
        call('./Engine/Build/BatchFiles/Build.bat', args, throwOnError);
    };
    Sys.setCwd(old);
    return ret;
  }

  static var tools:String;

  static function callOrDebug(cmd:String, args:Array<String>, throwOnError=true, gui=true) {
    if (debug) {
      args.push('-DEBUGGING');
      switch(systemName) {
      case 'Linux':
        args.unshift(cmd);
        args.unshift('--args');
        return call('gdb', args, throwOnError, gui);
      case 'Windows':
        if (tools == null) {
          var pfiles = Sys.getEnv('ProgramFiles(x86)');
          if (pfiles != null && FileSystem.exists('$pfiles/Microsoft Visual Studio/Installer/vswhere.exe')) {
            var cmd = new sys.io.Process('$pfiles/Microsoft Visual Studio/Installer/vswhere.exe', ['-latest','-products','*','-requires','Microsoft.VisualStudio.Component.VC.Tools.x86.x64', '-property','installationPath']);
            tools = cmd.stdout.readAll().toString().trim().split('\n')[0] + '/Common7/IDE';
            cmd.exitCode();
          }
        }
        if (tools == null) {
          tools = Sys.getEnv('VS140COMNTOOLS');
          if (tools == null) {
            tools = Sys.getEnv('VS130COMNTOOLS');
          }
          if (tools == null) {
            tools = Sys.getEnv('VS120COMNTOOLS');
          }
          if (tools == null) {
            throw 'Cannot find VSCOMNTOOLS to debug';
          }
        }
        args.unshift(cmd);
        args.unshift('/DebugExe');
        return call('$tools/../IDE/devenv.exe', args, throwOnError, gui);
      }
    }
    return call(cmd, args, throwOnError, gui);
  }

  static function call(cmd:String, args:Array<String>, throwOnError=true, gui:Bool=false) {
    Sys.println('calling "$cmd" "${args.join('" "')}"');
    if (gui && service) {
      Sys.println('Service calling through Caller.exe');
      args.unshift(cmd);
      cmd = '$workspace/CI/caller/bin/bin/Caller.exe';
    }
    var ret = Sys.command(cmd, args);
    if (throwOnError && ret != 0) {
      throw 'Command failed with code $ret';
    }
    Sys.println(' -> $cmd returned with code $ret');
    return ret;
  }


  static var files = [
    "Source/HaxeUnitTests/Public/GeneratedFile.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedFile.generated.h"

UCLASS()
class HAXEUNITTESTS_API UGeneratedClassOne : public UObject {
  GENERATED_BODY()
};
',
    "Haxe/GeneratedExterns/haxeunittests/UGeneratedClassOne.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedFile.h")
@:uextern extern class UGeneratedClassOne extends unreal.UObject {
}
',
    "Haxe/Scripts/helpers/TestGeneratedFile.hx" =>
'
package helpers;

@:uclass class UGeneratedClassTwo extends haxeunittests.UGeneratedClassOne {
  @:uexpose public static function doSomething():Void {
  }
}
',
  ];

  static var detectionTests = [
    {
      needsCppia: true,
      needsStatic: (false : Null<Bool>),
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'
package generated;

class UGTest {
}
'
      ],
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends unreal.UObject {
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  public function doAnythingReally():unreal.FString {
    return "hey";
  }
}
'
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return 42;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }
}
'
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }

  @:ufunction(NetMulticast) public function getMeTheEnum2():Void;

  function getMeTheEnum2_Implementation():Void {
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

typedef FGTestStruct = unreal.UnrealStruct<FGTestStruct, [{
  @:uproperty var test:unreal.FString;
}]>;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
  Fourth;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

typedef FGTestStruct = unreal.UnrealStruct<FGTestStruct, [{
  @:uproperty var test:unreal.FString;
  @:uproperty var test2:Int;
}]>;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
  Fourth;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

typedef FGTestStruct = unreal.UnrealStruct<FGTestStruct, [{
  @:uproperty var test:unreal.FString;
}]>;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
  Fourth;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uenum enum EGTestEnum {
  First;
  Second;
  Third;
  Fourth;
}

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }

  @:ufunction public function getMeTheEnum():EGTestEnum {
    return First;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: null,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return super.getSomeInt() + 42;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }

  override public function getSomeInt() : unreal.Int32 {
    return 42;
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose public function doAnythingReally():unreal.FString {
    return "hey";
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
}
'
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uexpose @:uproperty var test:Int;
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;
}
'
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassTwo = null;
    x.propOne = "hey";
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern.generated.h"

UCLASS()
class HAXEUNITTESTS_API UGeneratedClassTwo : public UObject {
  GENERATED_BODY()
  public:

  FString propOne;
};
',
      "Haxe/GeneratedExterns/haxeunittests/UGeneratedClassTwo.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern.h")
@:uclass @:uextern extern class UGeneratedClassTwo extends unreal.UObject {
}
',
      "Haxe/Externs/haxeunittests/UGeneratedClassTwo_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class UGeneratedClassTwo_Extra {
  public var propOne:unreal.FString;
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassTwo = null;
    x.propOne = "hey";
    x.propOne = "test";
  }
}
',
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassTwo = null;
    x.propOne = "hey";
    x.propTwo = 10;
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern.generated.h"

UCLASS()
class HAXEUNITTESTS_API UGeneratedClassTwo : public UObject {
  GENERATED_BODY()
  public:

  FString propOne;
  int propTwo;
};
',
      "Haxe/GeneratedExterns/haxeunittests/UGeneratedClassTwo.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern.h")
@:uclass @:uextern extern class UGeneratedClassTwo extends unreal.UObject {
}
',
      "Haxe/Externs/haxeunittests/UGeneratedClassTwo_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class UGeneratedClassTwo_Extra {
  public var propOne:unreal.FString;
  public var propTwo:Int;
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: null,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: false, // special case for reflective-only externs
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassThree = null;
    x.propOne = "hey";
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern2.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern2.generated.h"

UCLASS()
class HAXEUNITTESTS_API UGeneratedClassThree : public UObject {
  GENERATED_BODY()
  public:

  UPROPERTY()
  FString propOne;
};
',
      "Haxe/GeneratedExterns/haxeunittests/UGeneratedClassThree.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern2.h")
@:uclass @:uextern extern class UGeneratedClassThree extends unreal.UObject {
  @:uproperty public var propOne:unreal.FString;
}
',
      "Haxe/Externs/haxeunittests/UGeneratedClassThree_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class UGeneratedClassThree_Extra {
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassThree = null;
    x.propOne = "hey";
    x.propOne = "test";
  }
}
',
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest.hx" =>
'package generated;

@:uclass class UGTest extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.UGeneratedClassThree = null;
    x.propOne = "hey";
    x.propTwo = 10;
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern2.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern2.generated.h"

UCLASS()
class HAXEUNITTESTS_API UGeneratedClassThree : public UObject {
  GENERATED_BODY()
  public:

  UPROPERTY()
  FString propOne;
  int propTwo;
};
',
      "Haxe/GeneratedExterns/haxeunittests/UGeneratedClassThree.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern2.h")
@:uclass @:uextern extern class UGeneratedClassThree extends unreal.UObject {
  @:uproperty public var propOne:unreal.FString;
}
',
      "Haxe/Externs/haxeunittests/UGeneratedClassThree_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class UGeneratedClassThree_Extra {
  public var propTwo:Int;
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: null,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
  }
}
'
      ]
    },
    {
      needsCppia: true,
      needsStatic: false, // special case for reflective-only externs
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = null;
    x.propOne = "hey";
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern4.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern4.generated.h"

UCLASS()
class HAXEUNITTESTS_API AGeneratedClassFour : public AActor {
  GENERATED_BODY()
  public:

  UPROPERTY()
  FString propOne;
};
',
      "Haxe/GeneratedExterns/haxeunittests/AGeneratedClassFour.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern4.h")
@:uclass @:uextern extern class AGeneratedClassFour extends unreal.AActor {
  @:uproperty public var propOne:unreal.FString;
}
',
      "Haxe/Externs/haxeunittests/AGeneratedClassFour_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class AGeneratedClassFour_Extra {
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = null;
    x.propOne = "hey";
    x.propOne = "test";
  }
}
',
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: null,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = null;
    x.propOne = "hey";
    x.someFunc();
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern4.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern4.generated.h"

UCLASS()
class HAXEUNITTESTS_API AGeneratedClassFour : public AActor {
  GENERATED_BODY()
  public:

  UPROPERTY()
  FString propOne;

  UFUNCTION()
  void someFunc() {
  }
};
',
      "Haxe/GeneratedExterns/haxeunittests/AGeneratedClassFour.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern4.h")
@:uclass @:uextern extern class AGeneratedClassFour extends unreal.AActor {
  @:uproperty public var propOne:unreal.FString;
  @:ufunction public function someFunc():Void;
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = null;
    x.propOne = "hey";
    x.someFunc();
    x.nonUFunc();
  }
}
',
        "Source/HaxeUnitTests/GeneratedExtern4.h" =>
'#pragma once
#include "Engine.h"
#include "GeneratedExtern4.generated.h"

UCLASS()
class HAXEUNITTESTS_API AGeneratedClassFour : public AActor {
  GENERATED_BODY()
  public:

  UPROPERTY()
  FString propOne;

  UFUNCTION()
  void someFunc() {
  }

  void nonUFunc() {
  }
};
',
      "Haxe/GeneratedExterns/haxeunittests/AGeneratedClassFour.hx" =>
'package haxeunittests;

@:glueCppIncludes("GeneratedExtern4.h")
@:uclass @:uextern extern class AGeneratedClassFour extends unreal.AActor {
  @:uproperty public var propOne:unreal.FString;
  @:ufunction public function someFunc():Void;
}
',
      "Haxe/Externs/haxeunittests/AGeneratedClassFour_Extra.hx" =>
'package haxeunittests;
import unreal.*;

extern class AGeneratedClassFour_Extra {
  function nonUFunc():Void;
}
',
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: false,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;
import unreal.*;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = UObject.NewObject(UObject.GetTransientPackage(), haxeunittests.AGeneratedClassFour.StaticClass());
    x.propOne = "hey";
    x.someFunc();
    x.nonUFunc();
  }
}
',
      ]
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;
import unreal.*;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    var x:haxeunittests.AGeneratedClassFour = UObject.NewObjectTemplate(new TypeParam<haxeunittests.AGeneratedClassFour>());
    x.propOne = "hey";
    x.someFunc();
    x.nonUFunc();
  }
}
',
      ]
    },
    {
      needsCppia: false,
      needsStatic: false,
      files: null
    },
    {
      needsCppia: true,
      needsStatic: true,
      files: [
        "Haxe/Scripts/generated/UGTest2.hx" =>
'package generated;
import unreal.*;

@:uclass class UGTest2 extends haxeunittests.UBasicTypesSub3 {
  @:uproperty var test:Int;

  public function func() {
    TActorIterator.iterate(new TypeParam<haxeunittests.AGeneratedClassFour>(), this.GetWorld(), function(x:haxeunittests.AGeneratedClassFour) {
      x.propOne = "hey";
      return true;
    });
    var x:haxeunittests.AGeneratedClassFour = UObject.NewObjectTemplate(new TypeParam<haxeunittests.AGeneratedClassFour>());
    x.propOne = "hey";
    x.someFunc();
    x.nonUFunc();
  }
}
',
      ]
    },
  ];
}