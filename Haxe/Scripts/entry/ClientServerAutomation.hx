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
    var times = pass < 7 ? 4 : 1;
    for (i in 0...times) {
      this.addHaxeCommand(loadPIE("/Game/Maps/ClientServerEntryPoint"));
      this.addHaxeCommand(EngineLatentCommands.waitForMapToLoadCommand());
      this.addHaxeCommand(waitUntilTestFinishes());
      this.addHaxeCommand(EngineLatentCommands.exitGame());
      if (i <= 2 && pass < 7) {
        this.addHaxeCommand(buildNextPass());
      }
    }
    if (Sys.getEnv("CI_RUNNING") == "1") {
      this.addHaxeCommand(function() {
        unreal.FPlatformMisc.RequestExit(true);
        return true;
      });
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
        if (pass == null || pass < 4) {
          pass = 4;
        }
        var nextPass = pass + 1;

        unreal.CoreAPI.onCppiaReload(function() {
          cppiaReloaded = true;
        });
        trace('Building haxe pass $nextPass');
        var cmd = Sys.command('haxe', ['--cwd',FPaths.ConvertRelativePathToFull(FPaths.GameDir()) + '/Haxe', 'gen-build-script.hxml', '-D', 'pass=$nextPass']);
        didCall = true;
        pass = nextPass;
        if (pass >= 7) {
          unreal.Timer.delay(2.5, function() {
            cppiaReloaded = true;
          });
        }
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

