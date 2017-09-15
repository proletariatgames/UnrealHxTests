class UhxConfig {
  public static function getConfig(data:UhxBuildData, config:UhxBuildConfig) {
    trace('running custom config');
    if (data.targetType != Editor) {
      var dce = Sys.getEnv('DCE');
      if (dce != null) {
        config.dce = dce;
      }
    }
    return config;
  }
}