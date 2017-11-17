using UnrealBuildTool;

public class HaxeProgramTest : HaxeModuleRules {
#if (UE_OLDER_416)
  public HaxeProgramTest(TargetInfo target) : base(target) {
  }
#else
  public HaxeProgramTest(ReadOnlyTargetRules target) : base(target) {
  }
#endif
}
