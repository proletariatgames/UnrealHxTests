import unrealbuildtool.*;
import cs.system.io.Path;

using Helpers;

class HaxeUnitTests extends HaxeModuleRules
{
  public function new(target)
  {
    super(target);

    if (Sys.getEnv("DO_UNITY_BUILD") == null)
      this.bFasterWithoutUnity = true;
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

  override private function getConfig():HaxeModuleConfig {
    var ret = super.getConfig();
    if (sys.FileSystem.exists('$gameDir/Source/HaxeGlue')) {
      ret.glueTargetModule = 'HaxeGlue';
    }
    if (Sys.getEnv("NO_STATIC_BUILD") != null) {
      ret.noStatic = true;
    }
    return ret;
  }
}
