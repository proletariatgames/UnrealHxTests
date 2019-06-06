package cases;
import unreal.*;
import unreal.Timer;
import NonUObject;
import haxeunittests.*;

using buddy.Should;

class SomethingBase
{
  public function new() {}
  public function getVal() {
    return 42;
  }
}

class Something extends SomethingBase
{
  public var data:{ i:Int };
  public function new(data) {
    super();
    this.data = data;
  }
  override public function getVal() {
    return data.i;
  }
}


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
      it('should return the uname of a type', {
        CoreAPI.getTypeUName(TestStructs.FHaxeStruct2).should.be("FHaxeStruct2Name");
        CoreAPI.getTypeUName(TestStructs.FHaxeStruct).should.be("FHaxeStruct");
        CoreAPI.getTypeUName(TestUEnum.ETestHxEnumClass).should.be("ETestHxEnumClass");
        CoreAPI.getTypeUName(TestUEnum.ETestHxEnumClassWithName).should.be("ETestHxEnumClassWithName2");
      });
    });
    describe('Haxe - Threads', {
      var fields = [];
      it('should not crash when allocating from external threads', {
        var deque = new cpp.vm.Deque();
        for (i in 0...100)
        {
          var arr = [];
          if (i % 2 == 0)
          {
            fields.push(arr);
          }
          var init = new FSimpleDelegate();
          init.BindLambda(function() arr.push(new SomethingBase()));
          var loop = new FSimpleDelegate();
          loop.BindLambda(function() {
            arr.push(Std.random(2) == 0 ? new SomethingBase() : new Something({ i:i }));
            if (Std.random(50) == 1) {
              cpp.vm.Gc.run(true);
            }
          });
          var end = new FSimpleDelegate();
          end.BindLambda(function() {
            deque.push(null);
          });

          haxeunittests.FThreadRunner.start(init, loop, end, 10000);
        }

        for (i in 0...100)
        {
          deque.pop(true);
        }
        for (i in 0...50)
        {
          for (val in fields[i])
          {
            if (Std.is(val, SomethingBase))
            {
              val.getVal().should.be(42);
            } else {
              val.getVal().should.be(i * 2);
            }
          }
        }
      });
    });
  }
}
