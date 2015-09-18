package entry;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using StringTools;
#else
import buddy.*;

@:uclass
class ATestEntryPoint extends unreal.AActor {
  override public function PostLoad() {
    super.PostLoad();

    var reporter = new buddy.reporting.TraceReporter();

    var runner = new buddy.SuitesRunner(ImportAll.getDefs());

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
  macro public static function getDefs():haxe.macro.Expr {
    var cps = Context.getClassPath();
    var defs = [];
    for (cp in cps) {
      if (sys.FileSystem.exists('$cp/cases')) {
        for (file in sys.FileSystem.readDirectory('$cp/cases')) {
          if (file.endsWith('.hx')) {
            defs.push(Context.parse('new cases.' + file.substr(0,-3) + '()', Context.currentPos()));
          }
        }
      }
    }

    return { expr:EArrayDecl(defs), pos:Context.currentPos() };
  }
}
