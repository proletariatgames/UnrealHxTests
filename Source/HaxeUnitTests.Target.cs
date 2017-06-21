using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeUnitTestsTarget : BaseTargetRules
{
  public HaxeUnitTestsTarget(TargetInfo Target) : base(Target)
  {
    Type = TargetType.Game;
  }

  override protected void setupBinaries(List<string> moduleNames) {
    moduleNames.Add("HaxeUnitTests");
  }
}
