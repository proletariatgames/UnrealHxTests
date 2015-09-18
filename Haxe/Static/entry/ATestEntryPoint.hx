package entry;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;
using haxe.macro.ExprTools;
#else
import buddy.*;

@:uclass
class ATestEntryPoint extends unreal.AActor {
  override public function PostLoad() {
    super.PostLoad();

    var reporter = new buddy.reporting.TraceReporter();

    var runner = new buddy.SuitesRunner(ImportAll.getDefs(
      cases.TestUObjectExterns,
      cases.TestUObjectOverrides
    ));

    runner.run().then(function(_) {
      if (Sys.getEnv("CI_RUNNING") == "1") {
        trace('Ending stub implementation');
        var success = !runner.failed();
        Sys.exit(success ? 0 : 2);
      }
    });
    // do some tests
  }
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
