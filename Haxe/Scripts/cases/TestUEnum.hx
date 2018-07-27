package cases;
import unreal.*;
import NonUObject;
import haxeunittests.EMyCppEnum;
import haxeunittests.EMyEnum;
import haxeunittests.EMyNamespacedEnum;
import statics.StaticEnums.SomeEnumTest;
using buddy.Should;

@:uenum(BlueprintType) @:class(uint8) enum ETestHxEnumClass {
  @:umeta(DisplayName="FirstOne") E_1st;
  @:umeta(DisplayName="SecondOne") E_2nd;
  @:umeta(DisplayName="ThirdOne") E_3rd;
}

@:uclass class UTestUseEnum extends unreal.UObject {
  @:uproperty(BlueprintReadWrite)
  public var test1:ETestHxEnumClass;

  @:uproperty
  public var test2:EMyEnum;

  @:uproperty
  public var test3:EMyCppEnum;

  @:uproperty
  public var test4:EMyNamespacedEnum;

  @:uproperty
  public var test5:statics.StaticEnums.SomeEnumTest;

  @:uproperty
  public var test6:TArray<TEnumAsByte<EMyEnum>>;

  @:uproperty
  public var test7:TArray<EMyCppEnum>;

  @:uproperty
  public var test8:TArray<TEnumAsByte<EMyNamespacedEnum>>;

  @:uproperty
  public var test9:TArray<ETestHxEnumClass>;

  @:uproperty
  public var test10:TArray<statics.StaticEnums.SomeEnumTest>;

  @:uextern @:uproperty
  public var compiled_test6:TArray<TEnumAsByte<EMyEnum>>;

  @:uextern @:uproperty
  public var compiled_test7:TArray<EMyCppEnum>;

  @:uextern @:uproperty
  public var compiled_test8:TArray<TEnumAsByte<EMyNamespacedEnum>>;

  @:uextern @:uproperty
  public var compiled_test9:TArray<ETestHxEnumClass>;

  @:uextern @:uproperty
  public var compiled_test10:TArray<statics.StaticEnums.SomeEnumTest>;

  @:ufunction
  public function setTest(val:ETestHxEnumClass) {
    test1 = val;
  }

  @:ufunction
  public function getTest() : ETestHxEnumClass {
    return test1;
  }
}

class TestUEnum extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UEnums', {
      it('should be able to get/set UEnum fields', {
        var s = FHasStructMember1.create();
        s.myEnum = SomeEnum1;
        s.myCppEnum = CppEnum1;
        s.myNamespacedEnum = NSEnum1;
        s.myEnum.should.equal(SomeEnum1);
        s.myCppEnum.should.equal(CppEnum1);
        s.myNamespacedEnum.should.equal(NSEnum1);

        s.myEnum = SomeEnum2;
        s.myCppEnum = CppEnum2;
        s.myNamespacedEnum = NSEnum2;
        s.myEnum.should.equal(SomeEnum2);
        s.myCppEnum.should.equal(CppEnum2);
        s.myNamespacedEnum.should.equal(NSEnum2);

        s.myEnum = SomeEnum3;
        s.myCppEnum = CppEnum3;
        s.myNamespacedEnum = NSEnum3;
        s.myEnum.should.equal(SomeEnum3);
        s.myCppEnum.should.equal(CppEnum3);
        s.myNamespacedEnum.should.equal(NSEnum3);
      });
      it('should be able to define new UEnums', {
        var val = E_1st;
        val.should.equal(E_1st);
      });
      it('should be able to use uenums as uproperties', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>(), UObject.GetTransientPackage(), UTestUseEnum.StaticClass());
        obj.test1 = E_1st;
        obj.test1.should.equal(E_1st);
        obj.test1 = E_2nd;
        obj.test1.should.equal(E_2nd);
        obj.test1 = E_3rd;
        obj.test1.should.equal(E_3rd);

        obj.test2 = SomeEnum1;
        obj.test2.should.equal(SomeEnum1);
        obj.test2 = SomeEnum2;
        obj.test2.should.equal(SomeEnum2);
        obj.test2 = SomeEnum3;
        obj.test2.should.equal(SomeEnum3);

        obj.test3 = CppEnum1;
        obj.test3.should.equal(CppEnum1);
        obj.test3 = CppEnum2;
        obj.test3.should.equal(CppEnum2);
        obj.test3 = CppEnum3;
        obj.test3.should.equal(CppEnum3);

        obj.test5 = One;
        obj.test5.should.equal(One);
        obj.test5 = Two;
        obj.test5.should.equal(Two);
        obj.test5 = Three;
        obj.test5.should.equal(Three);
      });
      it('should be able to use TArray of uenums as uproperties', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>(), UObject.GetTransientPackage(), UTestUseEnum.StaticClass());
        var i = 0;
        for (v in [E_2nd, E_1st, E_3rd])
        {
          obj.test9.push(v);
          obj.test9[i++].should.equal(v);
        }

        var i = 0;
        for (v in [SomeEnum2, SomeEnum1, SomeEnum3])
        {
          obj.test6.push((v));
          obj.test6[i++].GetValue().should.equal(v);
        }
        var test6:TArray<EMyEnum> = TArray.create();
        var i = 0;
        for (v in [SomeEnum2, SomeEnum1, SomeEnum3])
        {
          test6.push(v);
          test6[i++].should.equal(v);
        }

        var i = 0;
        for (v in [CppEnum3, CppEnum1, CppEnum2])
        {
          obj.test7.push(v);
          obj.test7[i++].should.equal(v);
        }

        var i = 0;
        for (v in [One, Three, Two])
        {
          obj.test10.push(v);
          obj.test10[i++].should.equal(v);
        }

        var i = 0;
        for (v in [E_2nd, E_1st, E_3rd])
        {
          obj.compiled_test9.push(v);
          obj.compiled_test9[i++].should.equal(v);
        }

        var i = 0;
        for (v in [SomeEnum2, SomeEnum1, SomeEnum3])
        {
          obj.compiled_test6.push((v));
          obj.compiled_test6[i++].GetValue().should.equal(v);
        }
        var compiled_test6:TArray<EMyEnum> = TArray.create();
        var i = 0;
        for (v in [SomeEnum2, SomeEnum1, SomeEnum3])
        {
          compiled_test6.push((v));
          compiled_test6[i++].should.equal(v);
        }
        var compiled_test6:TArray<TEnumAsByte<EMyEnum>> = TArray.create();
        var i = 0;
        for (v in [SomeEnum2, SomeEnum1, SomeEnum3])
        {
          compiled_test6.push((v));
          compiled_test6[i++].should.equal(v);
        }

        var i = 0;
        for (v in [CppEnum3, CppEnum1, CppEnum2])
        {
          obj.compiled_test7.push(v);
          obj.compiled_test7[i++].should.equal(v);
        }

        var i = 0;
        for (v in [One, Three, Two])
        {
          obj.compiled_test10.push(v);
          obj.compiled_test10[i++].should.equal(v);
        }
      });
      it('should be able to pass enums back and forth to C++', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>(), UObject.GetTransientPackage(), UTestUseEnum.StaticClass());
        obj.setTest(E_1st);
        obj.getTest().should.equal(E_1st);
        obj.setTest(E_2nd);
        obj.getTest().should.equal(E_2nd);
        obj.setTest(E_3rd);
        obj.getTest().should.equal(E_3rd);
      });
      it('should be able to reference enums with params', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>(), UObject.GetTransientPackage(), UTestUseEnum.StaticClass());
        var e1 = NoParam,
            e2 = FTextParam("SomeText"),
            e3 = ObjParam(obj),
            e4 = ArrParam(TArray.fromIterable([new FString("Test")]));
        e1.match(NoParam).should.be(true);
        var match = switch(e2) {
          case FTextParam(param) if (param.toString() == "SomeText"):
            true;
          case _:
            false;
        };
        match.should.be(true);
        match = switch(e3) {
          case ObjParam(mobj) if (mobj == obj):
            true;
          case _:
            false;
        };
        match.should.be(true);
        match = switch(e4) {
          case ArrParam(arr) if (arr[0].toString() == "Test"):
            true;
          case _:
            false;
        };
        match.should.be(true);
      });
    });
  }
}

enum EnumWithParams {
  NoParam;
  FTextParam(txt:FText);
  ObjParam(uobj:UObject);
  ArrParam(arr:TArray<FString>);
}

  // public var myEnum:SomeEnum.EMyEnum;
  // public var myCppEnum:SomeEnum.EMyCppEnum;
  // public var myNamespacedEnum:SomeEnum.EMyNamespacedEnum;
