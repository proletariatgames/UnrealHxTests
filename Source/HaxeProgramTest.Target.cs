using UnrealBuildTool;
using System.Collections.Generic;

public class HaxeProgramTestTarget : TargetRules
{
  public HaxeProgramTestTarget(TargetInfo target) : base(target) {
    Type = TargetType.Program;
    LaunchModuleName = "HaxeProgramTest";
    LinkType = TargetLinkType.Monolithic;
    ExtraModuleNames.Add("HaxeProgramTest");
  }

  public override void SetupGlobalEnvironment(
		TargetInfo Target,
		ref LinkEnvironmentConfiguration OutLinkEnvironmentConfiguration,
		ref CPPEnvironmentConfiguration OutCPPEnvironmentConfiguration
		)
	{
		// Lean and mean
		bCompileLeanAndMeanUE = true;

		// Never use malloc profiling in Unreal Header Tool.
		bUseMallocProfiler = false;

		// No editor needed
		bBuildEditor = false;
		// Editor-only data is not needed as well
		bBuildWithEditorOnlyData = false;

		// Currently this app is not linking against the engine, so we'll compile out references from Core to the rest of the engine
		bCompileAgainstEngine = false;
		bCompileAgainstCoreUObject = false;

		// Our test project is a console application, not a Windows app (sets entry point to main(), instead of WinMain())
		OutLinkEnvironmentConfiguration.bIsBuildingConsoleApplication = true;
    bUseLoggingInShipping = true;

		bIncludeADO = false;

		// Do not include ICU for Linux (this is a temporary workaround, separate headless CrashReportClient target should be created, see UECORE-14 for details).
		if (Target.Platform == UnrealTargetPlatform.Linux)
		{
			bCompileICU = false;
		}

		// CrashReportClient.exe has no exports, so no need to verify that a .lib and .exp file was emitted by
		// the linker.
		OutLinkEnvironmentConfiguration.bHasExports = false;

		bUseChecksInShipping = true;

		// Epic Games Launcher needs to run on OS X 10.9, so CrashReportClient needs this as well
		OutCPPEnvironmentConfiguration.bEnableOSX109Support = true;

		OutCPPEnvironmentConfiguration.Definitions.Add("NOINITCRASHREPORTER=1");
	}
}