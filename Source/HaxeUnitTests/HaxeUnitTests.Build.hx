import unrealbuildtool.*;

class HaxeUnitTests extends HaxeModuleRules
{
  public function new(target)
  {
    super(target);

    // UEBuildConfiguration.bEnableFastIteration = true;
    BuildConfiguration.bUseUnityBuild = false;
    // this.MinFilesUsingPrecompiledHeaderOverride = -1;
    // Uncomment if you are using Slate UI
    // PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });

    // Uncomment if you are using online features
    // PrivateDependencyModuleNames.Add("OnlineSubsystem");
    // if ((Target.Platform == UnrealTargetPlatform.Win32) || (Target.Platform == UnrealTargetPlatform.Win64))
    // {
    //		if (UEBuildConfiguration.bCompileSteamOSS == true)
    //		{
    //			DynamicallyLoadedModuleNames.Add("OnlineSubsystemSteam");
    //		}
    // }
  }
}
