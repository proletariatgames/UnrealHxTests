package repl;
import repl.ReplTypes;

using unreal.CoreAPI;
using helpers.TestHelper;
using buddy.Should;

class TestReplication extends buddy.BuddySuite {
  public function new(repl:AReplicationTest) {
    describe("Replication tests", {
      it('should have a replication actor in scene', {
        repl.should.not.be(null);
      });
      it('should propagate initialOnly properties', function(done) {
        trace(repl.initialOnRep);
        trace(repl.ftextInitialOnly);
        var nChecks = 0;
        if (repl.initialOnRep != 0xD0D0D0D0) {
          repl.onRep_initialOnRep = function () {
            trace('onRep_initialOnRep');
            trace(repl.initialOnRep);
            repl.initialOnRep.should.be(0xD0D0D0D0);
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
            trace('onRep_ftextInitialOnly');
            trace(repl.ftextInitialOnly);
            repl.ftextInitialOnly.toString().should.be('FText Initial Property');
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
    });
  }
}
