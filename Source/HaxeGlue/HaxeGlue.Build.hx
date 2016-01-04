import unrealbuildtool.*;

class HaxeGlue extends HaxeModuleRules
{
  public function new(target)
  {
    super(target);

    if (Sys.getEnv("DO_UNITY_BUILD") == null)
      BuildConfiguration.bUseUnityBuild = false;
  }

  override private function getConfig():HaxeModuleConfig {
    var ret = super.getConfig();
    ret.targetModule = 'HaxeUnitTests';
    return ret;
  }
}
