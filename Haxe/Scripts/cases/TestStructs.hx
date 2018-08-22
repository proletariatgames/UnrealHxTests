package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;
import unreal.*;
import haxeunittests.*;

using unreal.CoreAPI;

@:ustruct(BlueprintType)
typedef FHaxeStruct = UnrealStruct<FHaxeStruct, [{
  @:uproperty
  var name:FString;
  @:uproperty
  var fname:FName;

  function someFunction() {
    return "name: " + name.toString();
  }
}]>;

@:uname("FHaxeStruct2Name")
typedef FHaxeStruct2 = UnrealStruct<FHaxeStruct2, [{
  @:uproperty
  var embedded:FHaxeStruct;
}]>;

typedef FDerivedStruct = UnrealStruct<FDerivedStruct, FPODStruct, [{
  @:uproperty
  var addedProperty:FHaxeStruct;
}]>;

@:uclass class UStructTest extends UObject {
  @:uproperty
  public var s:FHaxeStruct2;

  @:ufunction public function setPOD(pod:PRef<FPODStruct>) {
    pod.ui32 = 1;
    pod.i32 = 2;
    pod.d = 3.3;
    pod.f = 4.4;
  }

  @:ufunction public function checkPOD(pod:Const<PRef<FPODStruct>>) {
    pod.ui32.should().be(1);
    pod.i32.should().be(2);
    pod.d.should().beCloseTo(3.3);
    pod.f.should().beCloseTo(4.4);
  }
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

    cpp.vm.Gc.run(true);
    cpp.vm.Gc.run(true);
    beforeEach({
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
          // TestHelper.getType(simple).should.be( TestHelper.getType( (null : FSimpleStruct) ));
          nObjects++;

          var simpleNew = FSimpleStruct.createNew();
          // TestHelper.getType(simpleNew).should.be( TestHelper.getType( (null : unreal.POwnedPtr<FSimpleStruct>) ));

          simpleNew.toSharedPtr().dispose(); // make sure the reference is collected
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

          simple2 = null;
          simple = null;
          simpleNew = null;
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
          simple.isDisposed().should.be(true);
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
          var simple = FSimpleStruct.create();
          nObjects++;
          setSomeValues(simple, 6);
          checkValues(simple, 6, true);
          simple.dispose();
          simple.isDisposed().should.be(true);

          FSimpleStruct.nDestructorCalled.should.be(nDestructors + nObjects);

          simple = FSimpleStruct.createWithArgs(1.5,2.5,0xDEADBEE5,0xFFFFFFFF);
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
          var simple = FSimpleStruct.createNew(),
              shared = simple.toSharedPtr(),
              raw = shared.Get();
          nObjects++;
          raw.i32 = 10;
          FSimpleStruct.isI32EqualShared(shared, 10).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          shared.Get().i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualShared(shared, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          setSomeValues(shared.Get(), 5);
          checkValues(shared.Get(), 5, true);
          checkValues(shared.ToSharedRef().Get(), 5, true);
          checkValues(raw, 5, true);

          var ref = shared.ToSharedRef();
          ref.Get().i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualSharedRef(ref, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualSharedRef(ref, -1).should.be(false);
          setSomeValues(ref.Get(), 6);
          checkValues(ref.Get(), 6, true);
          checkValues(TSharedPtr.fromSharedRef(ref).Get(), 6, true);
          checkValues(raw, 6, true);

          ref.Get().i32 = 0x7FFFFFFF;
          var weak = TWeakPtr.fromSharedPtr( shared );
          FSimpleStruct.isI32EqualWeak(weak, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualWeak(weak, 0).should.be(false);
          setSomeValues(weak.Pin().Get(), 7);
          checkValues(weak.Pin().Get(), 7, true);
          checkValues(ref.Get(), 7, true);
          checkValues(raw, 7, true);

          var shared = FSimpleStruct.mkShared();
          shared.Get().i32 = 100;
          nObjects++;
          FSimpleStruct.isI32EqualShared(shared, 100).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          shared.Get().i32 = 0x7FFFFFFF;
          FSimpleStruct.isI32EqualShared(shared, 0x7FFFFFFF).should.be(true);
          FSimpleStruct.isI32EqualShared(shared, -1).should.be(false);
          setSomeValues(shared.Get(), 5);
          checkValues(shared.Get(), 5, true);
          checkValues(shared.ToSharedRef().Get(), 5, true);
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
          hasStruct1.fname = FName.fromString("Hello, World!"); // haxe issue #5226
          hasStruct1.fname.toString().should.be("Hello, World!");

          var simple2 = FSimpleStruct.createNew(),
              simple2Raw = simple2.getRaw();
          setSomeValues(simple2Raw, 1);

          var simple = hasStruct1.simple;
          simple.i32 = 10;
          hasStruct1.simple.i32.should.be(10);
          hasStruct1.isI32Equal(10).should.be(true);
          setSomeValues(hasStruct1.simple, 8);
          checkValues(hasStruct1.simple, 8, true);
          checkValues(simple, 8, true);
          hasStruct1.simple = simple2Raw;
          checkValues(hasStruct1.simple, 1, true);
          checkValues(simple, 1, true);

          var hasStruct2 = FHasStructMember2.create();
          nObjects++;
          nStruct2++;
          (hasStruct2.shared.IsValid()).should.be(false);
          hasStruct2.shared = simple2.toSharedPtr();
          checkValues(hasStruct2.shared.Get(), 1, true);
          checkValues(simple2Raw, 1, true);
          var shared = hasStruct2.shared;
          shared.Get().i32 = 10;
          hasStruct2.shared.Get().i32.should.be(10);
          hasStruct2.isI32Equal(10).should.be(true);
          setSomeValues(hasStruct2.shared.Get(), 8);
          checkValues(hasStruct2.shared.Get(), 8, true);
          checkValues(shared.Get(), 8, true);
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
          var copy = FSimpleStruct.getRef().copyNew(),
              rawCopy = copy.getRaw();
          nObjects++;
          checkValues(rawCopy, 12, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          rawCopy.i32 = 0xF1F0;
          FSimpleStruct.isI32EqualShared(copy.toSharedPtr(), 0xF1F0).should.be(true);
          setSomeValues(rawCopy, 13);
          checkValues(rawCopy, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          copy = FSimpleStruct.getRef().copyNew();
          rawCopy = copy.getRaw();
          nObjects++;
          checkValues(rawCopy, 12, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          rawCopy.i32 = 0xF1F0;
          FSimpleStruct.isI32EqualShared(copy.toSharedPtr(), 0xF1F0).should.be(true);
          setSomeValues(rawCopy, 13);
          checkValues(rawCopy, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          var copy2 = FSimpleStruct.getRef().copy();
          nObjects++;
          checkValues(copy2, 12, true);
          checkValues(FSimpleStruct.getRef(), 12, true);
          copy2.i32 = 0xF1F0;
          setSomeValues(copy2, 13);
          checkValues(copy2, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);

          var copy2 = FSimpleStruct.getRef().copy();
          nObjects++;
          setSomeValues(copy2, 14);
          checkValues(copy2, 14, true);
          checkValues(rawCopy, 13, true);
          checkValues(FSimpleStruct.getRef(), 12, true);

#if (pass >= 3)
          var v = new FSimpleUStruct();
#else
          var v = FSimpleUStruct.create();
#end
          v.f1 = 10;
          v.d1 = 11;
          v.i32 = 12;
          v.ui32 = 13;
          var v2 = v.copy();

          v.f1.should.be(10);
          v.d1.should.be(11);
          v.i32.should.be(12);
          v.ui32.should.be(13);
          v.f1 = 1000;
          v.d1 = 1000;
          v2.f1.should.be(10);
          v2.d1.should.be(11);
          v2.i32.should.be(12);
          v2.ui32.should.be(13);
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
        (FSimpleStruct.getRef() == FSimpleStruct.getRef()).should.be(true);
        (FSimpleStruct.getRef() != FSimpleStruct.getRef()).should.be(false);
        var ref1:Dynamic = FSimpleStruct.getRef();
        var ref2:Dynamic = FSimpleStruct.getRef();
        (ref1 == ref2).should.be(true);
        (ref1 != ref2).should.be(false);
        (FSimpleStruct.getRef() == null).should.be(false);
        (FSimpleStruct.getRef() == FSimpleStruct.getRef()).should.be(true);
        var simple1 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        var simple2 = FSimpleStruct.createWithArgs(100.1,200.2,5,10);
        (simple1 == simple2).should.be(false);
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
        s.name = FString.fromString("val"); // haxe issue #5226
        s.name.toString().should.be("val");
        s.someFunction().should.be('name: val');

        var s = FHaxeStruct2.create();
        s.embedded.fname = FName.fromString("foo"); // haxe issue #5226
        s.embedded.fname.toString().should.be("foo");
        var s2 = s.copy();
        s2.embedded.fname.toString().should.be("foo");

        var s2 = s.embedded;
        s2.fname.toString().should.be("foo");
      });
      it('should be able to declare/use haxe-defined structs', {
        var s = new FDerivedStruct();

        var test:UStructTest = UObject.NewObject(UObject.GetTransientPackage(), UStructTest.StaticClass());
        test.setPOD(s);
        test.checkPOD(s);

        s.addedProperty.name = "hey";
        s.ui32 = 1;
        s.i32 = 2;
        s.d = 2.2;
        s.f = 3.3;
        s.addedProperty.name.toString().should.be("hey");
        s.ui32.should.be(1);
        s.i32.should.be(2);
        s.d.should.beCloseTo(2.2);
        s.f.should.beCloseTo(3.3);

        TestHelper.reflectCall(test.setPOD(s));
        s.addedProperty.name.toString().should.be("hey");
        TestHelper.reflectCall(test.checkPOD(s));
      });
      it('should be able to use FVector_NetQuantize objects', {
        var X = FVector_NetQuantize.createFromVector(new FVector(1,2,3));
        X.X.should.beCloseTo(1);
        X.Y.should.beCloseTo(2);
        X.Z.should.beCloseTo(3);
      });
      it('should expose their StaticStruct type', {
        var s1 = FDerivedStruct.StaticStruct();
        s1.should.not.be(null);
        var s2 = FPODStruct.StaticStruct();
        s2.should.not.be(null);
        s1.IsChildOf(s2).should.be(true);
      });
#if (debug || UHX_CHECK_POINTER)
      it('should catch null references when running on debug mode / UE_CHECK_POINTER', {
        var fs:FSimpleStruct = getNullStruct();
        var caught = false;
        try {
          checkValues(fs, 0, true);
          true.should.be(false);
        }
        catch(e:Dynamic) {
          caught = true;
        }
        caught.should.be(true);
      });
#end
    });
  }

  public function getNullStruct():FSimpleStruct {
    return null;
  }
}
