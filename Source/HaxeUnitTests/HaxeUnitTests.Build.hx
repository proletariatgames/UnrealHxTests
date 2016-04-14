import unrealbuildtool.*;
import cs.system.io.Path;

using Helpers;

class HaxeUnitTests extends HaxeModuleRules
{
  public function new(target)
  {
    super(target);

    if (Sys.getEnv("NO_UNITY_BUILD") != null)
      this.bFasterWithoutUnity = true;
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
