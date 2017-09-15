using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeUnitTestsTarget : TargetRules
{
  public HaxeUnitTestsTarget(TargetInfo target) : base(target) {
    Type = TargetType.Game;
    ExtraModuleNames.Add("HaxeUnitTests");
  }
}