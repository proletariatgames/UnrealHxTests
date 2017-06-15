// Using .Target.hx files is optional, and you can just as likely use .Target.cs directly
// However, using it will help deal with versioning issues wrt .Target.cs

class HaxeUnitTestsEditor extends BaseTargetRules {
  override function init() {
    this.Type = TargetType.Editor;
  }

  override function setupBinaries(moduleNames:Array<String>) {
    moduleNames.push('HaxeUnitTests');
  }
}
