// Copyright 1998-2016 Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeProgramTarget : TargetRules
{
	public HaxeProgramTarget(TargetInfo Target)
	{
		Type = TargetType.Program;
		UndecoratedConfiguration = UnrealTargetConfiguration.Shipping;
	}

	//
	// TargetRules interface.
	//
	public override bool GetSupportedPlatforms(ref List<UnrealTargetPlatform> OutPlatforms)
	{
		OutPlatforms.Add(UnrealTargetPlatform.Win32);
		OutPlatforms.Add(UnrealTargetPlatform.Win64);
		OutPlatforms.Add(UnrealTargetPlatform.Mac);
		OutPlatforms.Add(UnrealTargetPlatform.Linux);
		return true;
	}

	public override bool GetSupportedConfigurations(ref List<UnrealTargetConfiguration> OutConfigurations, bool bIncludeTestAndShippingConfigs)
	{
		if( base.GetSupportedConfigurations( ref OutConfigurations, bIncludeTestAndShippingConfigs ) )
		{
			OutConfigurations.Add( UnrealTargetConfiguration.Shipping );
			OutConfigurations.Add( UnrealTargetConfiguration.Debug );
			return true;
		}
		else
		{
			return false;
		}
	}

	public override void SetupBinaries(
		TargetInfo Target,
		ref List<UEBuildBinaryConfiguration> OutBuildBinaryConfigurations,
		ref List<string> OutExtraModuleNames
		)
	{
		OutBuildBinaryConfigurations.Add(
			new UEBuildBinaryConfiguration(	InType: UEBuildBinaryType.Executable,
											InModuleNames: new List<string>() { "HaxeProgram" })
			);
	}

	public override bool ShouldCompileMonolithic(UnrealTargetPlatform InPlatform, UnrealTargetConfiguration InConfiguration)
	{
		return true;
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

		// HaxeProgram doesn't ever compile with the engine linked in
		UEBuildConfiguration.bCompileAgainstEngine = false;
		UEBuildConfiguration.bCompileAgainstCoreUObject = true;
		UEBuildConfiguration.bUseLoggingInShipping = true;

		UEBuildConfiguration.bIncludeADO = false;
		UEBuildConfiguration.bBuildWithEditorOnlyData = true;
		BuildConfiguration.bUseMallocProfiler = false;
		
		// Do not include ICU for Linux (this is a temporary workaround, separate headless HaxeProgram target should be created, see UECORE-14 for details).
		if (Target.Platform == UnrealTargetPlatform.Linux)
		{
			UEBuildConfiguration.bCompileICU = false;
		}

		// HaxeProgram.exe has no exports, so no need to verify that a .lib and .exp file was emitted by
		// the linker.
		OutLinkEnvironmentConfiguration.bHasExports = false;

		OutCPPEnvironmentConfiguration.Definitions.Add( "USE_CHECKS_IN_SHIPPING=1" );

		// Epic Games Launcher needs to run on OS X 10.9, so HaxeProgram needs this as well
		// OutCPPEnvironmentConfiguration.bEnableOSX109Support = true;
		OutLinkEnvironmentConfiguration.bIsBuildingConsoleApplication = true;
	}
}
