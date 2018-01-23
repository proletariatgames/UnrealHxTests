package cases;
import unreal.*;
import unreal.Timer;
import NonUObject;
import haxeunittests.*;

using buddy.Should;

class TestMisc extends buddy.BuddySuite {
  public function new() {
    var __status:buddy.SpecAssertion = null;
    describe('Unreal.hx - misc tests', {
      timeoutMs = 10000;
      it('should have a working timer', function(done) {
        var nDelayed = 0;
        var delays = [];
        function delay(secs:Float) {
          nDelayed++;
          var cur = FPlatformTime.Seconds();
          delays.push(cur + secs);
          delays.sort(Reflect.compare);
          Timer.delay(secs, function() {
            var lastDelay = delays.shift();
            lastDelay.should.beCloseTo(cur + secs);
            if (--nDelayed == 0) {
              done();
            }
          });
        }
        delay(0.5);
        delay(0.3);
        delay(0.4);
        delay(0.2);
        delay(0.1);
        delay(0.6);
        delay(0.7);
        function createTimer(secs:Float) {
          nDelayed++;
          var i = 0;
          var doneTimer = null;
          var cur = FPlatformTime.Seconds();
          delays.push(cur + secs);
          delays.sort(Reflect.compare);

          doneTimer = Timer.createTimer(secs, function() {
            i++;
            var lastDelay = delays.shift();
            lastDelay.should.beCloseTo(cur + secs);
            cur = FPlatformTime.Seconds();
            if (i == 10) {
              doneTimer();
              if (--nDelayed == 0) {
                done();
              }
            } else {
              delays.push(cur + secs);
              delays.sort(Reflect.compare);
            }
            i.should.beLessThan(11);
          });
        }

        createTimer(.12);
        createTimer(.4);
        createTimer(.05);
      });
      it('should not modify const math vectors', {
        var vec = FVector.ZeroVector;
        vec.X.should.be(0);
        vec.X = 100;
        var vec2 = FVector.ZeroVector;
        vec2.X.should.be(0);
      });
    });
  }
}
