package entry;
#if WITH_EDITOR
import unreal.editor.ULevelEditorPlaySettings;
import unreal.automation.EAutomationFlags;
import unreal.automation.EngineLatentCommands;
import unreal.*;

class HotReloadAutomation extends unreal.automation.AutomationTest {
  static var pass:Null<Int> = Std.parseInt(haxe.macro.Compiler.getDefine("pass"));
  override private function RunTest(Parameters:unreal.FString):Bool {
    this.addHaxeCommand(loadPIE("/Game/Maps/HaxeTestEntryPoint"));
    this.addHaxeCommand(EngineLatentCommands.waitForMapToLoadCommand());
    this.addHaxeCommand(waitUntilTestFinishes());
    if (pass == 3) {
      this.addHaxeCommand(buildNextPass());
    }
    return true;
  }

  static function loadPIE(name:String) {
    var fn = null;
    return function() {
      if (fn == null) {
        var config:ULevelEditorPlaySettings = cast ULevelEditorPlaySettings.StaticClass().GetDefaultObject(true);
        config.SetPlayNetDedicated(false);
        config.SetPlayNumberOfClients(1);
        fn = EngineLatentCommands.loadMapPIE(name);
      }
      return fn();
    }
  }

  static function buildNextPass() {
    var didCall = false,
        cppiaReloaded = false;
    return function() {
      if (!didCall) {
        var nextPass = 4;

        unreal.CoreAPI.onCppiaReload(function() {
          trace('cppia reloaded');
          cppiaReloaded = true;
        });
        var cmd = Sys.command('haxe', ['--cwd',FPaths.ConvertRelativePathToFull(FPaths.GameDir()) + '/Haxe', 'gen-build-script.hxml', '-D', 'pass=$nextPass']);
        if (cmd != 0) {
          trace('Error', 'Error while compiling pass $nextPass');
          Sys.exit(cmd);
        }
        pass = nextPass;
      }
      return cppiaReloaded;
    }
  }

  static function waitUntilTestFinishes() {
    var seenPIE = false;
    return function() {
      var ctxs = UEngine.GEngine.GetWorldContexts();
      for (i in 0...ctxs.Num()) {
        var ctx = ctxs.get_Item(i);
        if (ctx.WorldType.match(PIE)) {
          seenPIE = true;
          return false;
        }
      }
      return seenPIE;
    }
  }

  override private function GetTestFlags():EAutomationFlags {
    return EAutomationFlags.EditorContext | CommandletContext | EngineFilter;
  }
}
#end
