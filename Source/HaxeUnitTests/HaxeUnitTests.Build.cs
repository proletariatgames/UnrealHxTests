using UnrealBuildTool;

public class HaxeUnitTests : HaxeModuleRules {
#if (UE_OLDER_416)
  public HaxeUnitTests(TargetInfo target) : base(target) {
  }
#else
  public HaxeUnitTests(ReadOnlyTargetRules target) : base(target) {
  }
#endif

  protected override void init() {
    if (Target.Type == TargetType.Editor) {
      this.PrivateDependencyModuleNames.Add("SessionFrontend");
    }
  }
}
