package entry;
#if WITH_EDITOR
import unreal.editor.ULevelEditorPlaySettings;
import unreal.automation.EAutomationFlags;
import unreal.automation.EngineLatentCommands;
import unreal.*;

class ClientServerAutomation extends unreal.automation.AutomationTest {
  static var pass:Null<Int> = Std.parseInt(haxe.macro.Compiler.getDefine("pass"));
  override private function RunTest(Parameters:unreal.FString):Bool {
    this.addHaxeCommand(loadPIE("/Game/Maps/ClientServerEntryPoint"));
    this.addHaxeCommand(function() { trace('loaded!'); return true; });
    this.addHaxeCommand(EngineLatentCommands.waitSeconds(110));
    this.addHaxeCommand(EngineLatentCommands.exitGame());
    return true;
  }

  static function loadPIE(name:String) {
    var fn = null;
    return function() {
      if (fn == null) {
        var config:ULevelEditorPlaySettings = cast ULevelEditorPlaySettings.StaticClass().GetDefaultObject(true);
        config.SetPlayNetDedicated(true);
        config.SetPlayNumberOfClients(2);
        fn = EngineLatentCommands.loadMapPIE(name);
      }
      return fn();
    }
  }

  override private function GetTestFlags():EAutomationFlags {
    return EAutomationFlags.EditorContext | CommandletContext | EngineFilter;
  }
}
#end

