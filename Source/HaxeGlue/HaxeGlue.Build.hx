import unrealbuildtool.*;

class HaxeGlue extends GlueModuleRules
{
  public function new(target)
  {
    super(target);

    if (Sys.getEnv("DO_UNITY_BUILD") == null)
      BuildConfiguration.bUseUnityBuild = false;
  }
}
