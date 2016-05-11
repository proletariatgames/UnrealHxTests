package entry;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;
using haxe.macro.ExprTools;
#else
import unreal.editor.UFactory;
import buddy.*;
import unreal.*;

@:uclass
class ATestEntryPoint extends unreal.AActor {
  private var didTick = false;
  public function new(wrapped) {
    super(wrapped);
    this.PrimaryActorTick.bCanEverTick = true;
    var f:UFactory = null;
  }

  override public function Tick(deltaTime:Float32) {
    if (!didTick) didTick = true; else return;
    var reporter = new buddy.reporting.TraceReporter();


    var runner = new buddy.SuitesRunner(ImportAll.getDefs(
      cases.TestUObjectExterns,
      cases.TestStructs,
      cases.TestTemplates,
      cases.TestTArray,
      cases.TestDelegates,
      cases.TestUObjectOverrides
    ));

    runner.run().then(function(_) {
      cpp.vm.Gc.run(true);
      cpp.vm.Gc.run(true);
      trace('Ending stub implementation');
      if (Sys.getEnv("CI_RUNNING") == "1") {
        var success = !runner.failed();
        Sys.exit(success ? 0 : 2);
      }
    });
    // do some tests
  }

  // override function BeginDestroy() {
  //   super.BeginDestroy();
  //   // test hot reload when begin destroy is overridden
  //
  //   trace('Begin destroy!');
  // }
}
#end

class ImportAll {
  macro public static function getDefs(order:Array<haxe.macro.Expr>):haxe.macro.Expr {
    var cps = Context.getClassPath();
    var defs = [ for (e in order) e.toString() ];
    for (cp in cps) {
      if (sys.FileSystem.exists('$cp/cases')) {
        for (file in sys.FileSystem.readDirectory('$cp/cases')) {
          if (file.endsWith('.hx')) {
            var name = 'cases.' + file.substr(0,-3);
            if (defs.indexOf(name) < 0)
              defs.push(name);
          }
        }
      }
    }

    return { expr:EArrayDecl([ for (def in defs) Context.parse('new $def()', Context.currentPos())]), pos:Context.currentPos() };
  }
}
