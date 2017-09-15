
using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeUnitTestsEditorTarget : TargetRules
{
  public HaxeUnitTestsEditorTarget(TargetInfo target) : base(target) {
    Type = TargetType.Editor;
    ExtraModuleNames.Add("HaxeUnitTests");
  }
}