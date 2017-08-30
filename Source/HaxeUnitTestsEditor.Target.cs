// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeUnitTestsEditorTarget : BaseTargetRules
{
  public HaxeUnitTestsEditorTarget(TargetInfo Target) : base(Target)
  {
    Type = TargetType.Editor;
    this.bUseUnityBuild = this.bForceUnityBuild = false;
  }

  override protected void setupBinaries(List<string> moduleNames) {
    moduleNames.Add("HaxeUnitTests");
  }
}
