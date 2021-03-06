package entry;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;
using haxe.macro.ExprTools;
#else
#if WITH_EDITOR
import unreal.editor.UFactory;
#end
import buddy.*;
import unreal.*;

using unreal.CoreAPI;

@:uclass
class ATestEntryPoint extends unreal.AActor {
  private var didTick = false;
  public function new(wrapped) {
    super(wrapped);
    buddy.BuddySuite.useDefaultTrace = true;
    this.PrimaryActorTick.bCanEverTick = true;
  }

  // we define this as live so we can load a new cppia version on the third pass
  @:live override public function Tick(deltaTime:Float32) {
    if (!didTick) didTick = true; else return;

    var runner = new buddy.SuitesRunner(ImportAll.getDefs(
      cases.TestUObjectExterns,
      cases.TestStructs,
      cases.TestTemplates
      // cases.TestTArray,
      // cases.TestUObjectOverrides,
      // cases.TestDelegates
      // cases.TestReflect
    ));
    // var runner = new buddy.SuitesRunner([new cases.TestUnrealInteraction()]);

    var curPass:Null<Int> = Std.parseInt(haxe.macro.Compiler.getDefine("pass"));

    var nextPass:Null<Int> = null;
#if WITH_EDITOR
    if (curPass == 2) {
      nextPass = curPass + 1;
    }
#end

    trace('running pass $curPass');
    #if cppia
    uhx.internal.HaxeHelpers.setReflectionDebugMode(#if (pass >= 3) false #else true #end);
    #end

    runner.run().then(function(_) {
      cpp.vm.Gc.run(true);
      cpp.vm.Gc.run(true);
      var success = !runner.failed();
      trace('tests success=$success');

      var ciRunning = Sys.getEnv('CI_RUNNING') == '1' || Sys.args().indexOf('-DEBUGGING') >= 0;
      if (ciRunning) {
#if WITH_EDITOR
        if (GetWorld().IsPlayInEditor()) {
          if (!success) {
            trace('Fatal', 'Test failed. Exiting');
            // the only way to make sure that UE exits with a non-0 code is to actually exit ourselves
            Sys.exit(curPass == null ? 10 : curPass);
          }

          if (curPass == 4) {
            unreal.FPlatformMisc.RequestExitWithStatus(true, 0);
          } else {
            var pc = UGameplayStatics.GetPlayerController(GetWorld(), 0);
            if (pc != null) {
              pc.ConsoleCommand("Exit", true);
            }
          }

          return;
        }
#end
        if (nextPass != null) {
          if (!success) {
            Sys.exit(nextPass);
          }

#if WITH_EDITOR
          CoreAPI.onCppiaReload(function() {
            didTick = false;
          });
#end

          var name = Sys.systemName() == 'Windows' ? 'RunCi.exe' : 'RunCi';
          var cmd = Sys.command(FPaths.ConvertRelativePathToFull(FPaths.GameDir()) + '/CI/bin/$name', ['pass$nextPass']);
          if (cmd != 0) {
            trace('Fatal', 'Error while compiling pass $nextPass');
            Sys.exit(cmd);
          }
        } else {
          if (success) {
            unreal.FPlatformMisc.RequestExitWithStatus(true, 0);
          } else {
            trace('Fatal', 'Tests failed');
            Sys.exit(2);
          }
        }
      }
    });
    // do some tests
  }
}
#end

class ImportAll {
  macro public static function getDefs(order:Array<haxe.macro.Expr>):haxe.macro.Expr {
    var cps = Context.getClassPath();
    var defs = [ for (e in order) e.toString() + '()' ];
    for (cp in cps) {
      if (sys.FileSystem.exists('$cp/cases')) {
        for (file in sys.FileSystem.readDirectory('$cp/cases')) {
          if (file.endsWith('.hx')) {
            var name = 'cases.' + file.substr(0,-3);
            if (name == 'cases.TestUnrealInteraction') {
              name += '(this)';
            } else {
              name += '()';
            }
            if (defs.indexOf(name) < 0)
              defs.push(name);
          }
        }
      }
    }

    return { expr:EArrayDecl([ for (def in defs) Context.parse('new $def', Context.currentPos())]), pos:Context.currentPos() };
  }
}
