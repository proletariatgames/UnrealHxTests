using UnrealBuildTool;

public class HaxeUnitTests : HaxeModuleRules {
#if (UE_OLDER_416)
  public HaxeUnitTests(TargetInfo target) : base(target) {
  }
#else
  public HaxeUnitTests(ReadOnlyTargetRules target) : base(target) {
  }
#endif

  override protected void init() {
    this.PrivateDependencyModuleNames.Add("SlateCore");
    this.PrivateDependencyModuleNames.Add("NetworkReplayStreaming");
    this.PrivateDependencyModuleNames.Add("Kismet");
    this.PrivateDependencyModuleNames.Add("InputCore");
    this.PrivateDependencyModuleNames.Add("OnlineSubsystem");
    this.PrivateDependencyModuleNames.Add("ClothingSystemRuntimeInterface");
    this.PrivateDependencyModuleNames.Add("BlueprintGraph");
    this.PrivateDependencyModuleNames.Add("UnrealEd");
  }
}
