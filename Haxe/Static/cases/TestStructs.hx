package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;
import unreal.*;

using unreal.CoreAPI;

class FHaxeStruct extends unreal.UnrealStruct
{
  @:uproperty
  public var name:FString;
  @:uproperty
  public var fname:FName;
}

class FHaxeStruct2 extends unreal.UnrealStruct
{
  @:uproperty
  public var embedded:FHaxeStruct;
}

class FDerivedStruct extends FPODStruct
{
  @:uproperty
  public var addedProperty:FHaxeStruct;
}

@:uclass class UStructTest extends UObject {
  @:uproperty
  public var s:FHaxeStruct2;
}

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

      struct.ToString().toString().should.be('Simple Struct (${usedDefaultConstructor ? 1 : 0}) { ${Std.int(struct.f1)}, ${Std.int(struct.d1)}, ${struct.i32}, ${struct.ui32} }');
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
          s2.ToString().toString().should.be('Simple Struct (1) { 1, 2, 10, 20 }');
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
          ref.i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualSharedRef(ref, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualSharedRef(ref, -1).should.be(false);
          setSomeValues(ref, 6);
          checkValues(ref, 6, true);
          checkValues(ref.toSharedPtr(), 6, true);
          checkValues(simple, 6, true);

          ref.i32 = 0x7FFFFFFF;
          var weak = shared.toWeakPtr();
          FSimpleStruct.isI32EqualWeak(weak, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualWeak(weak, 0).should.be(false);
          setSomeValues(weak.Pin(), 7);
          checkValues(weak.Pin(), 7, true);
          checkValues(weak.toSharedPtr(), 7, true);
          checkValues(simple, 7, true);

          var shared = FSimpleStruct.mkShared();
          shared.i32 = 100;
          nObjects++;
          FSimpleStruct.isI32EqualShared(shared, 100).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          shared.i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualShared(shared, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          setSomeValues(shared, 5);
          checkValues(shared, 5, true);
          checkValues(shared.toSharedRef(), 5, true);
        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });
      it('should be able to use structs as member variables of other structs / uclasses', {
        var nStruct1 = 0,
            nConstructorsStruct1 = FHasStructMember1.nConstructorCalled,
            nDestructorsStruct1 = FHasStructMember1.nDestructorCalled,
            nStruct2 = 0,
            nConstructorsStruct2 = FHasStructMember2.nConstructorCalled,
            nDestructorsStruct2 = FHasStructMember2.nDestructorCalled,
            nObjects = 0;
        function run() {
          var hasStruct1 = FHasStructMember1.create();
          nObjects++;
          nStruct1++;
          hasStruct1.fname = "Hello, World!";
          hasStruct1.fname.toString().should.be("Hello, World!");

          var simple2 = FSimpleStruct.create();
          setSomeValues(simple2, 1);

          var simple = hasStruct1.simple;
          simple.i32 = 10;
          hasStruct1.simple.i32.should.be(10);
          hasStruct1.isI32Equal(10).should.be(true);
          setSomeValues(hasStruct1.simple, 8);
          checkValues(hasStruct1.simple, 8, true);
          checkValues(simple, 8, true);
          hasStruct1.simple = simple2;
          checkValues(hasStruct1.simple, 1, true);
          checkValues(simple, 1, true);

          var hasStruct2 = FHasStructMember2.create();
          nObjects++;
          nStruct2++;
          (hasStruct2.shared == null).should.be(true);
          hasStruct2.shared = simple2.toSharedPtr();
          checkValues(hasStruct2.shared, 1, true);
          checkValues(simple2, 1, true);
          var shared = hasStruct2.shared;
          shared.i32 = 10;
          hasStruct2.shared.i32.should.be(10);
          hasStruct2.isI32Equal(10).should.be(true);
          setSomeValues(hasStruct2.shared, 8);
          checkValues(hasStruct2.shared, 8, true);
          checkValues(shared, 8, true);
        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
        FHasStructMember1.nConstructorCalled.should.be(nConstructorsStruct1 + nStruct1);
        FHasStructMember1.nDestructorCalled.should.be(nDestructorsStruct1 + nStruct1);
        FHasStructMember2.nConstructorCalled.should.be(nConstructorsStruct2 + nStruct2);
        FHasStructMember2.nDestructorCalled.should.be(nDestructorsStruct2 + nStruct2);
      });
      it('should be able to use ref to structure', {
        var nStruct3 = 0,
            nConstructorsStruct3 = FHasStructMember3.nConstructorCalled,
            nDestructorsStruct3 = FHasStructMember3.nDestructorCalled,
            nObjects = 0;
        function run() {
          var hasStruct3 = FHasStructMember3.create();
          nObjects++; nStruct3++;
          hasStruct3.usedDefaultConstructor.should.be(true);
          hasStruct3.simple.i32 = 0xF0E;
          @:privateAccess hasStruct3.simple.parent.should.be(hasStruct3);
          hasStruct3.isI32Equal(0xF0E).should.be(true);
          setSomeValues(hasStruct3.simple, 9);
          checkValues(hasStruct3.simple, 9, true);
          checkValues(hasStruct3.ref, 9, true);

          var simple = FSimpleStruct.createWithArgs(1.1,2.2,3,4);
          nObjects++;
          simple.f1.should.beCloseTo(1.1);
          simple.d1.should.be(2.2);
          hasStruct3.ref = simple;
          hasStruct3.ref.f1.should.beCloseTo(1.1);
          hasStruct3.ref.d1.should.be(2.2);
          hasStruct3.simple.f1.should.beCloseTo(1.1);
          hasStruct3.simple.d1.should.be(2.2);

          var hasStruct3_1 = FHasStructMember3.createWithRef( simple );
          nObjects++; nStruct3++;
          hasStruct3_1.usedDefaultConstructor.should.be(false);
          setSomeValues(simple, 10);
          setSomeValues(hasStruct3_1.simple, 11);
          checkValues(simple, 10, false);
          checkValues(hasStruct3_1.ref, 10, false);
          checkValues(hasStruct3_1.simple, 11, true);

          FHasStructMember3.setRef(simple, hasStruct3_1.simple);
          nDestructors++; //we're using a pass-by-value struct
          checkValues(simple, 11, true);
          checkValues(hasStruct3_1.ref, 11, true);
        }
        run();
        // run twice to make sure that the finalizers have run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
        FHasStructMember3.nConstructorCalled.should.be(nConstructorsStruct3 + nStruct3);
        FHasStructMember3.nDestructorCalled.should.be(nDestructorsStruct3 + nStruct3);
      });
      it('should be able to be copied and owned', {
        var nObjects = 0;
        function run() {
          setSomeValues(FSimpleStruct.getRef(), 12);
          var copy = unreal.Wrapper.copy(FSimpleStruct.getRef());
          nObjects++;
          checkValues(copy, 12, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          copy.i32 = 0xF1F0;
          FSimpleStruct.isI32EqualShared(copy.toSharedPtr(), 0xF1F0).should.be(true);
          setSomeValues(copy, 13);
          checkValues(copy, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);

          var copy2 = unreal.Wrapper.copyStruct(FSimpleStruct.getRef());
          nObjects++;
          nDestructors++;
          setSomeValues(copy2, 14);
          checkValues(copy2, 14, true);
          checkValues(copy, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors); // note the change here: We're not using the normal constructors
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });
      it('should be able to be created as null', {
        FSimpleStruct.isNull(null).should.be(true);
        FSimpleStruct.getNull().should.be(null);
      });
      it('should be able to use types with superclasses', {
        var nObjects = 0;
        function run() {
          var base:FBase = FBase.create();
          nObjects++;
          setSomeValues(base, 13);
          checkValues(base, 13, true);
          base.getSomeInt().should.be(0xDEADF00);
          base.otherValue = 22.2;
          base.otherValue.should.beCloseTo(22.2);

          var child = FOverride.create();
          nObjects++;
          base = child;
          base.getSomeInt().should.be(0xBA5);
          base.otherValue = 33.3;
          base.otherValue.should.beCloseTo(33.3);
          child.getSomeInt().should.be(0xBA5);
          child.otherValue = 33.3;
          child.otherValue.should.beCloseTo(33.3);
          setSomeValues(child, 14);
          checkValues(child, 14, true);

          base = FBase.getOverride();
          base.getSomeInt().should.be(0xBA5);
          setSomeValues(base, 15);
          checkValues(base, 15, true);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        // make sure all objects were deleted
        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
        FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);
      });
      it('should be able to use pointers/ref/shared pointers to basic types'); // FIXME
      it('should be able to use pointers/ref/shared pointers to other pointers/ref/shared pointer types');
      it('should be able to check physical equality', {
        FSimpleStruct.getRef().pointerEquals(null).should.be(false);
        FSimpleStruct.getRef().pointerEquals(FSimpleStruct.getRef()).should.be(true);
        var simple1 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        var simple2 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        simple1.pointerEquals(simple2).should.be(false);
      });
      it('should be able to check structural equality', {
        var simple1 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        var simple2 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        var simple3 = FSimpleStruct.createWithArgs(100.1,200.2,5,9);
        var noOp1 = FSimpleStructNoEqualsOperator.createWithArgs(100.1, 200.2, 5, 10);
        var noOp2 = FSimpleStructNoEqualsOperator.createWithArgs(100.1, 200.2, 5, 10);
        var noOp3 = FSimpleStructNoEqualsOperator.createWithArgs(100.1, 200.2, 5, 9);

        simple1.equals(null).should.be(false);
        simple1.equals(simple1).should.be(true);
        simple1.equals(simple2).should.be(true);
        simple1.equals(simple3).should.be(false);

        noOp1.equals(null).should.be(false);
        //This test should pass because we check for physical equal first!
        noOp1.equals(noOp1).should.be(true);
        //These tests should fail because there is no equals operator!!!
        noOp1.equals(noOp2).should.be(false);
        noOp1.equals(noOp3).should.be(false);

      });
      it('should be able to construct haxe-defined structs', {
        var s = FHaxeStruct.create();
        s.name = "val";
        s.name.toString().should.be("val");

        var s = FHaxeStruct2.create();
        s.embedded.fname = "foo";
        s.embedded.fname.toString().should.be("foo");

        var s2 = s.embedded;
        s2.fname.toString().should.be("foo");
      });
    });
  }

}
