import unrealbuildtool.*;
import cs.system.collections.generic.*;
using Helpers;

class HaxeProgram extends HaxeProgramRules {
  public function new(target)
  {
    super(target);

    // var engineDir = UnrealBuildTool.EngineSourceDirectory;
    var engineDir:String = untyped __cs__("UnrealBuildTool.UnrealBuildTool.EngineSourceDirectory.FullName");
    PublicIncludePaths.Add('$engineDir/Runtime/Launch/Public');
    PrivateIncludePaths.Add('$engineDir/Runtime/Launch/Private');		// For LaunchEngineLoop.cpp include

    PrivateDependencyModuleNames.addRange(
        [
          "Core",
          "CoreUObject",
          "Projects",
          "DesktopPlatform",
        ]);

    PrivateIncludePaths.addRange(
        [
          // For LaunchEngineLoop.cpp include
          "Runtime/Launch/Private",
          "Runtime/Launch/Public",
          "Programs/UnrealHeaderTool/Private",
        ]);
  }

  override function getConfig() {
    var ret = super.getConfig();
    ret.disableUObject = true;
    ret.noDebug = false;
    return ret;
  }
}
