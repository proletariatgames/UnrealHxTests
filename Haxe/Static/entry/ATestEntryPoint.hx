package entry;
import buddy.*;
import cases.*;

@:uclass
class ATestEntryPoint extends unreal.AActor {
  override public function PostLoad() {
    super.PostLoad();

    var reporter = new buddy.reporting.TraceReporter();

    var runner = new buddy.SuitesRunner([
      new TestBasicExterns()
    ], reporter);

    runner.run().then(function(success) {
      if (Sys.getEnv("CI_RUNNING") == "1") {
        trace('Ending stub implementation');
        Sys.exit(success ? 0 : 2);
      }
    });
    // do some tests
  }
}
