import sys.FileSystem;

using StringTools;
using Lambda;

class RunCi {
  static var ue4:String = Sys.getEnv('UE4');
  static var haxeServer:Null<Int> = Std.parseInt(Sys.getEnv('HAXESERVER'));
  static var systemName = Sys.systemName();
  static var workspace:String;
  static var debug = Sys.getEnv("DEBUG") == "1";
  static var config = Sys.getEnv('BUILD_CONFIG') == null ? 'Development' : Sys.getEnv('BUILD_CONFIG');
  static var platform:String = Sys.getEnv('BUILD_PLATFORM');
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

    function doTargets(targets:Array<String>) {
      var envs = [
        { name:'UE4', desc:'The path to the UE4 install dir' },
        { name:'HAXESERVER', desc:'The port of an already open haxe compilation server' },
        { name:'DEBUG', desc:'Call the target with a debugger attached' },
        { name:'BUILD_CONFIG', desc:'Build configuration. Defaults to Development' },
        { name:'BUILD_PLATFORM', desc:'Build platform. Defaults to current platform' },
      ];
      var avTargets = [
        { name:'all', desc:'A shorthand for `build cmd run pass2 run pass3 run-hotreload run-cserver`', fn:doTargets.bind(['build','cmd','run','pass2','run','pass3','run-hotreload','run-cserver','restore'])},
        { name:'build', desc:'Performs a full editor build', fn:doBuild },
        { name:'cmd', desc:'Runs a test commandlet', fn:doCmd },
        { name:'run', desc:'Runs the main unit tests', fn:doRun },
        { name:'pass2-9', desc:'Builds the incremental cppia passes', fn:null },
        { name:'run-hotreload', desc:'Runs the hot reload tests', fn:doHotReload },
        { name:'run-cserver', desc:'Runs the client-server tests', fn:doCServer },
        { name:'cooked-test', desc:'A shorthand for `build-cooked run-cooked', fn:doTargets.bind(['build-cooked','run-cooked']) },
        { name:'build-cooked', desc:'Builds a cooked game', fn:doBuildCooked },
        { name:'run-cooked', desc:'Runs a cooked game', fn:doRunCooked },
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
        if (spec == null) {
          if (target.startsWith('pass')) {
            var pass = Std.parseInt(target.substr('pass'.length));
            fn = doPass.bind(pass);
          } else {
            throw 'Cannot find target $target';
          }
        } else {
          fn = spec.fn;
        }

        Sys.println('Running $target');
        fn();
      }
    }
    doTargets(Sys.args());
  }

  static function doBuild() {
    runUBT([platform, config, 'HaxeUnitTestsEditor', '-project=$workspace/HaxeUnitTests.uproject']);
  }

  static function doCmd() {
    var stamp = Date.now().toString();
    Sys.putEnv('CUSTOM_STAMP', stamp);
    runUE(['$workspace/HaxeUnitTests.uproject', '-run=HaxeUnitTests.UpdateAsset', stamp, '-AllowStdOutLogVerbosity']);
  }

  static function doRun() {
    runUE(['$workspace/HaxeUnitTests.uproject', '-server', '/Game/Maps/HaxeTestEntryPoint', '-stdout', '-AllowStdOutLogVerbosity']);
  }

  static function doPass(n:Int) {
    if (haxeServer == null) {
      runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml', '-D', 'pass=$n']);
    } else {
      PassExpand.run('$workspace/Haxe/Scripts', n);
      runHaxe(['--cwd', '$workspace/Haxe', 'gen-build-script.hxml']);
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
    runUAT(['BuildCookRun', '-platform=$platform', '-project=$workspace/HaxeUnitTests.uproject', '-cook', '-clientconfig=$config', '-serverconfig=$config', '-allmaps', '-stage', '-pak', '-archive', '-prereqs', '-archivedirectory=$workspace/bin', '-distribution']);
  }

  static function doRunCooked() {
    throw 'TODO';
  }

  static function runUE(args:Array<String>, throwOnError=true) {
    var old = Sys.getCwd();
    Sys.setCwd(ue4);
    var ret = switch(systemName) {
      case 'Mac':
        callOrDebug('./Engine/Binaries/Mac/UE4Editor.app/Contents/MacOS/UE4Editor', args, throwOnError);
      case 'Linux':
        callOrDebug('./Engine/Binaries/Linux/UE4Editor', args, throwOnError);
      case _:
        callOrDebug('./Engine/Binaries/Win64/UE4Editor.exe', args, throwOnError);
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
    if (haxeServer != null) {
      args.push('--connect');
      args.push('$haxeServer');
    }
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

  static function callOrDebug(cmd:String, args:Array<String>, throwOnError=true) {
    if (debug) {
      switch(systemName) {
      case 'Linux':
        args.unshift(cmd);
        args.unshift('--args');
        return call('gdb', args, throwOnError);
      case 'Windows':
        var tools = Sys.getEnv('VS140COMNTOOLS');
        if (tools == null) {
          tools = Sys.getEnv('VS130COMNTOOLS');
        }
        if (tools == null) {
          tools = Sys.getEnv('VS120COMNTOOLS');
        }
        if (tools == null) {
          throw 'Cannot find VSCOMNTOOLS to debug';
        }
        args.unshift(cmd);
        args.unshift('/DebugExe');
        return call('$tools/../IDE/devenv.exe', args, throwOnError);
      }
    }
    return call(cmd, args, throwOnError);
  }

  static function call(cmd:String, args:Array<String>, throwOnError=true) {
    Sys.println('calling "$cmd" "${args.join('" "')}"');
    var ret = Sys.command(cmd, args);
    if (throwOnError && ret != 0) {
      throw 'Command failed';
    }
    Sys.println(' -> $cmd returned with code $ret');
    return ret;
  }
}