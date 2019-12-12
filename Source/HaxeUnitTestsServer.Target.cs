
using UnrealBuildTool;
using System.Collections.Generic;

[SupportedPlatforms(UnrealPlatformClass.Server)]
public class HaxeUnitTestsServerTarget : TargetRules
{
  public HaxeUnitTestsServerTarget(TargetInfo target) : base(target) {
    Type = TargetType.Server;
    ExtraModuleNames.Add("HaxeUnitTests");
  }
}
