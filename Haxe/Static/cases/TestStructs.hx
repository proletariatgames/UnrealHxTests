package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestStructs extends buddy.BuddySuite {
  public function new() {
    var nDestructors = FSimpleStruct.nDestructorCalled,
        nConstructors = FSimpleStruct.nConstructorCalled;
    inline function setSomeValues(struct:FSimpleStruct, multiplier:Int) {
      struct.f1 = 10.2 * multiplier;
      struct.d1 = 20.2 * multiplier;
      struct.i32 = 33 * multiplier;
      struct.ui32 = 44 * multiplier;
    }

    // seems like not using inline here fails. Need to check if that's a buddy, hxcpp or ue4haxe issue
    inline function checkValues(struct:FSimpleStruct, multiplier:Int, usedDefaultConstructor:Bool) {
      struct.f1.should.beCloseTo(10.2 * multiplier);
      struct.d1.should.beCloseTo(20.2 * multiplier);
      struct.i32.should.be(33 * multiplier);
      struct.ui32.should.be(44 * multiplier);
      struct.usedDefaultConstructor.should.be(usedDefaultConstructor);
      FSimpleStruct.isI32Equal(struct, 33 * multiplier).should.be(true);
      FSimpleStruct.isI32Equal(struct, -1).should.be(false);
      FSimpleStruct.isI32EqualByVal(struct, 33 * multiplier).should.be(true);
      FSimpleStruct.isI32EqualByVal(struct, -1).should.be(false);
      nDestructors += 2; // for the by val object

      struct.toString().should.be('Simple Struct (${usedDefaultConstructor ? 1 : 0}) { ${Std.int(struct.f1)}, ${Std.int(struct.d1)}, ${struct.i32}, ${struct.ui32} }');
    }

    before({
      nConstructors = FSimpleStruct.nConstructorCalled;
      nDestructors = FSimpleStruct.nDestructorCalled;
    });

    describe('Haxe - Structs', {
      it('should be able to use simple non-uobject classes', {
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
          s2.toString().should.be('Simple Struct (1) { 1, 2, 10, 20 }');
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
        // separate function again
        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.create();
          TestHelper.getType(simple).should.be( TestHelper.getType( (null : unreal.PHaxeCreated<FSimpleStruct>) ));
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
        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.create();
          nObjects++;
          simple.dispose();
          simple.disposed.should.be(true);
#if UE4_CHECK_POINTER
          // when UE4_CHECK_POINTER is on, it will throw if the object is disposed
          // otherwise, it will just crash.
          // note that this would print an error message on the log regardless;
          // what we do is compile with -D UE4_POINTER_TESTING so no rogue error message shows up
          function fail() {
            return checkValues(simple,1,false);
          }
          fail.should.throwType(String);
#end
          FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });

      it('should be able to be referenced by value', {
        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.createStruct();
          nDestructors++; // one destructor call for the temporary object
          nObjects++;
          setSomeValues(simple, 6);
          checkValues(simple, 6, true);
          simple.dispose();
          simple.disposed.should.be(true);

          FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);

          simple = FSimpleStruct.createWithArgsStruct(1.5,2.5,0xDEADBEE5,0xFFFFFFFF);
          nDestructors++; // one destructor call for the temporary object
          nObjects++;
          simple.f1.should.beCloseTo(1.5);
          simple.d1.should.be(2.5);
          simple.i32.should.be(0xDEADBEE5);
          simple.ui32.should.be(0xFFFFFFFF);
          setSomeValues(simple, 4);
          checkValues(simple, 4, false);
        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        // destructors are called for the temporary created objects too
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });

      it('should be able to use smart pointers', {
        var nObjects = 0;
        function run() {
          var simple = FSimpleStruct.create();
          nObjects++;
          simple.i32 = 10;
          var shared = simple.toSharedPtr();
          FSimpleStruct.isI32EqualShared(shared, 10).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          shared.i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualShared(shared, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          setSomeValues(shared, 5);
          checkValues(shared, 5, true);
          checkValues(shared.toSharedRef(), 5, true);
          checkValues(simple, 5, true);

          var ref = shared.toSharedRef();
          Sys.println('shared ref');
          ref.i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualSharedRef(ref, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualSharedRef(ref, -1).should.be(false);
          ref.f1 = 1.1;
          setSomeValues(ref, 6);
          checkValues(ref, 6, true);
          checkValues(ref.toSharedPtr(), 6, true);
          checkValues(simple, 6, true);

        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        // destructors are called for the temporary created objects too
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });
      it('should be able to use pointers to structure');
      it('should be able to use pointers to basic types');
    });
  }

}
