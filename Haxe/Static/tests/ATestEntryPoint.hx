package tests;

@:uclass
class ATestEntryPoint extends unreal.AActor
{
  override public function PostLoad() {
    super.PostLoad();
    // do some tests
    if (Sys.getEnv("CI_RUNNING") == "1") {
      trace('Ending stub implementation');
      Sys.exit(0);
    }
  }
}
