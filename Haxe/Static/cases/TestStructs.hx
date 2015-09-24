package cases;
using buddy.Should;
import NonUObject;

class TestStructs extends buddy.BuddySuite {
  public function new() {
    inline function setSomeValues(struct:FSimpleStruct, multiplier:Int) {
      struct.f1 = 11.1 * multiplier;
      struct.d1 = 22.2 * multiplier;
      struct.i32 = 33 * multiplier;
      struct.ui32 = 44 * multiplier;
    }

    // seems like not using inline here fails. Need to check if that's a buddy, hxcpp or ue4haxe issue
    inline function checkValues(struct:FSimpleStruct, multiplier:Int, usedDefaultConstructor:Bool) {
      struct.f1.should.beCloseTo(11.1 * multiplier);
      struct.d1.should.beCloseTo(22.2 * multiplier);
      struct.i32.should.be(33 * multiplier);
      struct.ui32.should.be(44 * multiplier);
      struct.usedDefaultConstructor.should.be(usedDefaultConstructor);

      inline function get2Dec(f:Float) {
        var i = Std.int(f * 100);
        var ret = Std.string(i);
        return ret.substr(0,-2) + '.' + ret.substr(-2);
      }

      struct.toString().should.be('Simple Struct (${usedDefaultConstructor ? 1 : 0}) { ${get2Dec(struct.f1)}, ${get2Dec(struct.d1)}, ${struct.i32}, ${struct.ui32} }');
    }

    describe('Haxe - Structs', {
      it('should be able to use simple non-uobject classes', {
        var nConstructors = FSimpleStruct.nConstructorCalled;
        var nDestructors = FSimpleStruct.nDestructorCalled;
        // run in a separate function to make sure no hidden references are kept in the stack
        function run() {
          var simple = FSimpleStruct.getRef();
          simple.f1 = 1.11;
          simple.d1 = 2.22;
          simple.i32 = 10;
          simple.ui32 = 20;
          var s2 = FSimpleStruct.getRef();
          s2.f1.should.beCloseTo(1.11);
          s2.d1.should.be(2.22);
          s2.i32.should.be(10);
          s2.ui32.should.be(20);
          s2.usedDefaultConstructor.should.be(true);
          s2.toString().should.be('Simple Struct (1) { 1.11, 2.22, 10, 20 }');
          simple = null;
          s2 = null;
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        FSimpleStruct.nConstructorCalled.should.be(nConstructors);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors);
      });

      it('should be able to instantiate simple non-uobject classes', {
        var nConstructors = FSimpleStruct.nConstructorCalled;
        var nDestructors = FSimpleStruct.nDestructorCalled;
        // separate function again
        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.create();
          nObjects++;
          setSomeValues(simple, 2);
          checkValues(simple, 2, true);

          function useAsClosure() {
            simple.i32 = 0xDEADF00D;
          }
          useAsClosure();
          simple.i32.should.be(0xDEADF00D);

          var simple2 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
          nObjects++;
          simple2.f1.should.beCloseTo(100.1);
          simple2.d1.should.beCloseTo(200.2);
          simple2.i32.should.be(5);
          simple2.ui32.should.be(10);
          simple2.usedDefaultConstructor.should.be(false);
          setSomeValues(simple2,10);
          checkValues(simple2,10,false);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });

      it('should be able to be disposed when `dispose` is called', {
        var nConstructors = FSimpleStruct.nConstructorCalled;
        var nDestructors = FSimpleStruct.nDestructorCalled;

        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.create();
          nObjects++;
          simple.dispose();
          simple.disposed.should.be(true);
#if UE4_CHECK_POINTER
          function fail() {
            return checkValues(simple,1,false);
          }
          fail.should.throwType(String);
#end
          FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });

      it('should be able to use smart pointers');

      it('should be able to use structs');
    });
  }

}
