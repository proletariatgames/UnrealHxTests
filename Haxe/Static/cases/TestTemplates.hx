package cases;
import NonUObject;
import UBasicTypesSub;
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

      struct.ToString().toString().should.be('Simple Struct (${usedDefaultConstructor ? 1 : 0}) { ${Std.int(struct.f1)}, ${Std.int(struct.d1)}, ${struct.i32}, ${struct.ui32} }');
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

        var templ = FTemplatedClass1.create(4.2);
        templ.value.should.be(4.2);
        templ.get().should.be(4.2);
        templ.value = 42.2;
        templ.value.should.be(42.2);
        templ.get().should.be(42.2);
        templ.set(52.2);
        templ.value.should.be(52.2);
        templ.get().should.be(52.2);
        templ.value += 10;
        templ.value.should.be(62.2);
        templ.get().should.be(62.2);

        var templ = FTemplatedClass2.create(new TypeParam<Float32>(), new TypeParam<Int16>());
        templ.createWithA(11.1).value.should.beCloseTo(11.1);
        templ.createWithB(10).value.should.be(10);
        templ.createRec(22.2).value.value.should.beCloseTo(22.2);

        var ntempl = FNonTemplatedClass.create();
        ntempl.obj.value.should.be(null);
        ntempl.obj.value = ntempl;
        ntempl.obj.value.should.not.be(null);

        var arr = TArrayImpl.create(new TypeParam<UTemplatesDef>());
        var obj = UObject.NewObject(new TypeParam<PStruct<UTemplatesDef>>());
        var obj2 = UObject.NewObject(new TypeParam<PStruct<UTemplatesDef>>());
        arr.Push(obj);
        arr.get_Item(0).should.not.be(null);
        arr.set_Item(0, obj2);
        arr.get_Item(0).should.not.be(null);
        arr.Num().should.be(1);

        var arr = TArrayImpl.create(new TypeParam<UTemplateMyClass>());
        var obj = UObject.NewObject(new TypeParam<PStruct<UTemplateMyClass>>());
        var obj2 = UObject.NewObject(new TypeParam<PStruct<UTemplateMyClass>>());
        arr.Push(obj);
        arr.get_Item(0).should.be(obj);
        arr.set_Item(0, obj2);
        arr.get_Item(0).should.not.be(obj);
        arr.get_Item(0).should.be(obj2);
        arr.Num().should.be(1);

        var arr = TArrayImpl.create(new TypeParam<TSubclassOf<UBasicTypesSub2>>());
        arr.Push( UBasicTypesSub2.StaticClass() );
        arr.Push( UBasicTypesSub3.StaticClass() );
        for (i in 0...arr.Num()) {
          arr.get_Item(i).GetDesc().toString().should.be('BasicTypesSub' + (i+2));
        }

        var arr = TArrayImpl.create(new TypeParam<PStruct<FName>>());
        for (i in 0...5)
          arr.Push(i + "");
        for (i in 0...5) {
          arr.get_Item(i).toString().should.be(i + "");
        }

        // var arr = TArray.create(new TypeParam<PStruct<FString>>());
        // for (i in 0...5) {
        //   Sys.println(i);
        //   arr.Push(i + "");
        // }
        // for (i in 0...5) {
        //   Sys.println(i);
        //   Sys.println(arr.get_Item(i));
        //   arr.get_Item(i).should.be(i + "");
        // }
      });
    });
  }
}

@:uclass
class UTemplateMyClass extends UObject {
  public var templ:PStruct<FTemplatedClass1<Int>>;
  public var templ2:PStruct<TArray<Int>>;
  public var templ3:PStruct<TArray<UTemplateMyClass>>;
  @:uproperty
  public var templ4:PStruct<TArray<UTemplateMyClass>>;

  @:uproperty
  public var templ5:PStruct<TArray<UBasicTypesUObject>>;
}
