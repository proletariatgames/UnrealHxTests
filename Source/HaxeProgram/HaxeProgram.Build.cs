using UnrealBuildTool;

public class HaxeProgram : HaxeModuleRules {
#if (UE_OLDER_416)
  public HaxeProgram(TargetInfo target) : base(target) {
  }
#else
  public HaxeProgram(ReadOnlyTargetRules target) : base(target) {
  }
#endif
}
