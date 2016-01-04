import unrealbuildtool.*;
import cs.system.io.Path;

using Helpers;

class HaxeUnitTests extends ModuleRules
{
  public function new(target)
  {
    super();

    // UEBuildConfiguration.bEnableFastIteration = true;
    this.PublicDependencyModuleNames.addRange(['Core','CoreUObject','Engine','InputCore','SlateCore']);
    this.PublicDependencyModuleNames.Add("HaxeGlue");
    var modulePath = RulesCompiler.GetModuleFilename('HaxeUnitTests');
    var base = Path.GetFullPath('$modulePath/..');
    if (UEBuildConfiguration.bBuildEditor)
      this.PublicDependencyModuleNames.addRange(['UnrealEd']);
    this.PrivateIncludePaths.Add(base + '/Generated/Private');
    this.PublicIncludePaths.Add(base + '/Public');
    this.PublicIncludePaths.Add(base + '/Generated');
    this.PublicIncludePaths.Add(base + '/Generated/Public');

    if (Sys.getEnv("DO_UNITY_BUILD") == null)
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
