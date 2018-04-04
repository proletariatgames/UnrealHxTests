package repl;
import repl.ReplTypes;
import NonUObject;
import haxeunittests.*;
import unreal.*;

using unreal.CoreAPI;
using helpers.TestHelper;
using buddy.Should;

class TestReplication extends buddy.BuddySuite {
  public function new(repl:AReplicationTest) {
    describe("Replication tests", {
      timeoutMs = 30000;
      it('should have a replication actor in scene', {
        repl.should.not.be(null);
      });
#if (pass < 8)
      it('should propagate initialOnly properties', function(done) {
        var nChecks = 0;
        if (repl.initialOnRep != 0xD0D0D0D0) {
          repl.OnRep_initialOnRep = function () {
            if (repl.initialOnRep != 0xD0D0D0D0) {
              trace('Fatal', 'initialOnRep ${repl.initialOnRep} != ${0xD0D0D0D0}');
            }
            if (++nChecks == 2) {
              done();
            }
          };
        } else {
          repl.initialOnRep.should.be(0xD0D0D0D0);
          nChecks++;
        }
        if (repl.ftextInitialOnly.toString() != 'FText Initial Property') {
          repl.onRep_ftextInitialOnly = function () {
            if (repl.ftextInitialOnly.toString() != 'FText Initial Property') {
              trace('Fatal', 'ftextInitialOnly ${repl.ftextInitialOnly} != FText Initial Property');
            }
            if (++nChecks == 2) {
              done();
            }
          };
        } else {
          repl.ftextInitialOnly.toString().should.be('FText Initial Property');
          nChecks++;
        }

        if (nChecks == 2) {
          done();
        }
      });
#end

      function syncFirst(done) {
        repl.fn_startTest = function() {
          done();
        };
        if (repl.Role == ROLE_Authority) {
          var gameMode = repl.GetWorld().GetAuthGameMode().as(AReplGameMode);
          if (gameMode == null) {
            trace('Fatal', 'gameMode should not be null');
          }
          var nPlayers = gameMode.numReadyPlayers;
          var allPlayers = 2;
#if WITH_EDITOR
          allPlayers = entry.ClientServerAutomation.NUM_PLAYERS;
#end
          if (nPlayers >= allPlayers) {
            gameMode.numReadyPlayers = 0;
            repl.startTest();
          } else {
            gameMode.onPlayerReady = function(_) {
              if (gameMode.numReadyPlayers == allPlayers) {
                gameMode.numReadyPlayers = 0;
                gameMode.onPlayerReady = null;
                repl.startTest();
              }
            }
          }
        } else {
          var pc:AReplPlayerController = cast UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld());
          if (pc == null) {
            trace('Fatal', 'pc should not be null');
          }
          if (pc == null) {
            trace('Fatal', 'Could not find a suitable player controller: ${UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld())}');
          }
          pc.clientReady();
        }
      }

      var syncs = new List(),
          first = true;
      function sync(fn, onEnd) {
        function done() {
          fn(function() {
            onEnd();
            var next = syncs.pop();
            if (next != null) {
              syncFirst(next);
            }
          });
        }

        if (first) {
          first = false;
          syncFirst(done);
        } else {
          syncs.add(done);
        }
      }
      it('should not synchronize InitialOnly properties', {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.initialOnRep = 42;
            repl.ftextInitialOnly = "Server only";
          }
          done();
        }, function() {});
      });
      it('should call onRep functions when replicating', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.fn_i32 = function() {
              throw 'should not be called';
            };
            repl.i32 = 0xF00B45;
            done();
          } else {
            repl.fn_i32 = function() {
              if (repl.i32 != 0xF00B45) {
                trace('Fatal', 'i32 ${repl.i32} != ${0xF00B45}');
              }
              done();
            };
          }
        }, done);
      });

      it('should call onRep functions when replicating (2)', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.fn_fstring = function(str:FString) {
              throw 'should not be called';
            };
            repl.fstring = 'foo bar';
            done();
          } else {
            repl.fn_fstring = function(str:FString) {
              if (repl.fstring.toString() != 'foo bar') {
                trace('Fatal', 'str ${repl.fstring} != foo bar');
              }
              done();
            };
          }
        }, done);
      });

      it('should call onRep functions when replicating (3)', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.fn_fstring = function(str:FString) {
              throw 'should not be called';
            };
            repl.fstring = 'test';
            done();
          } else {
            repl.fn_fstring = function(str:FString) {
              repl.fstring.toString().should.be('test');
              str.toString().should.be('foo bar');
              done();
            };
          }
        }, done);
      });

#if (pass >= 5)
      it('should call onRep functions when replicating (4 - hot reload)', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.hotReload1 = Int64Helpers.make(0xF00B45,0xF00);
#if (pass >= 6)
            repl.fn_hotReload1ShouldRep = function() {
              return repl.hotReload1 != 2;
            }
#end
            done();
          } else {
            repl.fn_hotReload1 = function() {
              repl.hotReload1.should.be(Int64Helpers.make(0xF00B45,0xF00));
              done();
            };
          }
        }, done);
      });
#end

#if (pass >= 7)
      it('should call onRep functions when replicating (5 - hot reload)', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.hotReloadOnRep = 0xf0f0f0;
            done();
          } else {
            repl.onRep_hotReloadOnRep = function() {
              repl.hotReloadOnRep.should.be(0xf0f0f0);
              done();
            };
          }
        }, done);
      });
#end

      it('should call a custom replication function', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.fn_i32ShouldRep = function() {
              return false;
            };
            repl.fn_i32ShouldRep2 = function() return repl.i32RepFunc2 != 2;
            repl.i32RepFunc = 100;
            repl.i32RepFunc2 = 200;
            done();
          } else {
            repl.onRep_i32RepFunc = function() trace('Fatal', 'i32RepFunc should not replicate');
            repl.onRep_i32RepFunc2 = done;
          }
        }, done);
      });
      it('should not replicate if the replication function returns false', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.i32RepFunc2 = 2;
          } else {
            repl.onRep_i32RepFunc2 = function() trace('Fatal', 'i32RepFunc2 should not replicate');
          }
          done();
        }, done);
      });

#if (pass >= 6)
      it('should not replicate if the replication function returns false (hotreload)', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            repl.hotReload1 = 2;
          } else {
            repl.fn_hotReload1 = function() trace('Fatal', 'hotReload1 should not replicate');
          }
          done();
        }, done);
      });
#end

      it('should be able to call client RPCs', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            Timer.delay(.1, function() {
              for (controller in repl.GetWorld().GetControllerIterator()) {
                var pc:AReplPlayerController = cast controller;
                pc.Client_Reliable( pc.PlayerState.GetPlayerName(), "someName" );
              }
              done();
            });
          } else {
            var pc:AReplPlayerController = cast UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld());
            pc.should.not.be(null);
            if (pc == null) {
              trace('Fatal', 'Could not find a suitable player controller: ${UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld())}');
            }
            pc.fn_onClientCalled = function(str:String, name:String) {
              if (str != pc.PlayerState.GetPlayerName().toString()) {
                trace('Fatal', 'str ${str} != ${pc.PlayerState.GetPlayerName()}');
              }
              if (name != 'someName') {
                trace('Fatal', 'str ${str} != someName');
              }
              done();
            };
          }
        }, done);
      });

      it('should be able to call server RPCs', function(done) {
        sync(function(done) {
          if (repl.Role == ROLE_Authority) {
            var i = 0;
            for (controller in repl.GetWorld().GetControllerIterator()) {
              i++;
              var pc:AReplPlayerController = cast controller;
              pc.validateCalled.should.be(false);
              pc.canCallServerFn = true;
              pc.fn_onServerCall = function(arr) {
                i--;
                pc.validateCalled.should.be(true);
                if (arr[1].i32 != 0xba5) {
                  trace('Fatal', '${arr[1].i32} != 0xba5');
                }
                if (i == 0) {
                  done();
                }
              };
            }
          } else {
            Timer.delay(.1, function() {
              if (!repl.isValid()) {
                return;
              }
              var pc:AReplPlayerController = cast UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld());
              if (pc == null) {
                trace('Fatal', 'Could not find a suitable player controller: ${UEngine.GEngine.GetFirstLocalPlayerController(repl.GetWorld())}');
              }
              var arr:TArray<FPODStruct> = TArray.create();
              arr.push(new FPODStruct());
              arr.push(new FPODStruct());
              arr.push(new FPODStruct());
              arr[1].i32 = 0xba5;
              pc.Server_Reliable_WithValidation(arr);
              done();
            });
          }
        }, done);
      });

      it('sync', function(done) {
        sync(function(done) done(), done);
      });
    });
  }
}
