// Copyright 1998-2016 Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeProgramTarget : TargetRules
{
	public HaxeProgramTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Program;
		UndecoratedConfiguration = UnrealTargetConfiguration.Shipping;
		LinkType = TargetLinkType.Monolithic;
		ExtraModuleNames.Add("HaxeProgram");
		LaunchModuleName = "HaxeProgram";
	}

	public override void SetupGlobalEnvironment(
		TargetInfo Target,
		ref LinkEnvironmentConfiguration OutLinkEnvironmentConfiguration,
		ref CPPEnvironmentConfiguration OutCPPEnvironmentConfiguration
		)
	{
		UEBuildConfiguration.bCompileLeanAndMeanUE = true;

		// Don't need editor
		UEBuildConfiguration.bBuildEditor = false;
		UEBuildConfiguration.bCompileICU = false;

		// HaxeProgram doesn't ever compile with the engine linked in
		UEBuildConfiguration.bCompileAgainstEngine = false;
		UEBuildConfiguration.bCompileAgainstCoreUObject = true;
		UEBuildConfiguration.bUseLoggingInShipping = true;

		UEBuildConfiguration.bIncludeADO = false;
		UEBuildConfiguration.bBuildWithEditorOnlyData = false;
		BuildConfiguration.bUseMallocProfiler = false;
		
		// HaxeProgram.exe has no exports, so no need to verify that a .lib and .exp file was emitted by
		// the linker.
		OutLinkEnvironmentConfiguration.bHasExports = false;

		OutCPPEnvironmentConfiguration.Definitions.Add( "USE_CHECKS_IN_SHIPPING=1" );

		// Epic Games Launcher needs to run on OS X 10.9, so HaxeProgram needs this as well
		// OutCPPEnvironmentConfiguration.bEnableOSX109Support = true;
		OutLinkEnvironmentConfiguration.bIsBuildingConsoleApplication = true;
	}
}
