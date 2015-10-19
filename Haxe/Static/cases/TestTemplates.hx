package cases;
import NonUObject;
import SomeEnum;
import templates.TemplatesDef;
import unreal.*;

using buddy.Should;

class TestTemplates extends buddy.BuddySuite {
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

    describe('Haxe - Templates', {
      it('should be able to call templated functions', {
        var nObjects = 0;
        function run() {
          UTemplatesDef.getSomeStaticInt(new TypeParam<PStruct<FSimpleStruct>>()).should.be(442);
          UTemplatesDef.getSomeStaticInt(new TypeParam<PStruct<UTemplatesDef>>()).should.be(42);

          var templ = UObject.NewObject(new TypeParam<PStruct<UTemplatesDef>>());
          templ.should.not.be(null);

          var struct = FSimpleStruct.create();
          nObjects++;
          setSomeValues(struct, 1);
          checkValues(struct, 1, true);

          var struct2 = templ.copyNew(new TypeParam<PStruct<FSimpleStruct>>(), cast struct);
          nObjects++;
          checkValues(struct2, 1, true);
          setSomeValues(struct, 2);
          checkValues(struct, 2, true);
          checkValues(struct2, 1, true);
        }
        run();
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        FSimpleStruct.nConstructorCalled.should.be(nConstructors + nObjects);
      });

      it('should be able to use templated classes', {
        var templ = FTemplatedClass1.create(10);
        templ.value.should.be(10);
        templ.get().should.be(10);
        templ.value = 42;
        templ.value.should.be(42);
        templ.get().should.be(42);
        templ.set(52);
        templ.value.should.be(52);
        templ.get().should.be(52);
        templ.value += 10;
        templ.value.should.be(62);
        templ.get().should.be(62);
      });
    });
  }
}


