class UhxConfig {
  public static function getConfig(data:UhxBuildData, config:UhxBuildConfig) {
    trace('running custom config');
    if (data.targetType != Editor) {
      config.dce = DceFull;
    }
    return config;
  }
}