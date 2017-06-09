package entry;
#if WITH_EDITOR
import unreal.editor.ULevelEditorPlaySettings;
import unreal.automation.EAutomationFlags;
import unreal.automation.EngineLatentCommands;
import unreal.*;

class ClientServerAutomation extends unreal.automation.AutomationTest {
  inline public static var NUM_PLAYERS = 2;
  static var pass:Null<Int> = Std.parseInt(haxe.macro.Compiler.getDefine("pass"));
  override private function RunTest(Parameters:unreal.FString):Bool {
    this.addHaxeCommand(loadPIE("/Game/Maps/ClientServerEntryPoint"));
    this.addHaxeCommand(EngineLatentCommands.waitForMapToLoadCommand());
    this.addHaxeCommand(function() { trace('here'); return true; });
    this.addHaxeCommand(waitUntilTestFinishes());
    this.addHaxeCommand(EngineLatentCommands.exitGame());
    if (pass < 6) {
      this.addHaxeCommand(buildNextPass());
    }
    return true;
  }

  static function loadPIE(name:String) {
    var fn = null;
    return function() {
      if (fn == null) {
        var config:ULevelEditorPlaySettings = cast ULevelEditorPlaySettings.StaticClass().GetDefaultObject(true);
        config.SetPlayNetDedicated(true);
        config.SetPlayNumberOfClients(NUM_PLAYERS);
        fn = EngineLatentCommands.loadMapPIE(name);
      }
      return fn();
    }
  }

  override private function GetTestFlags():EAutomationFlags {
    return EAutomationFlags.EditorContext | CommandletContext | EngineFilter;
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

  static function buildNextPass() {
    var didCall = false,
        cppiaReloaded = false;
    return function() {
      if (!didCall) {
        if (pass == null || pass < 5) {
          pass = 5;
        }
        var nextPass = pass + 1;

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

}
#end

