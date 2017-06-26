package cases;
import unreal.*;
import NonUObject;
import SomeEnum;
import haxeunittests.EMyCppEnum;
import haxeunittests.EMyEnum;
import haxeunittests.*;
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
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>());
        obj.test1 = E_1st;
        obj.test1.should.equal(E_1st);
        obj.test1 = E_2nd;
        obj.test1.should.equal(E_2nd);
        obj.test1 = E_3rd;
        obj.test1.should.equal(E_3rd);
      });
      it('should be able to pass enums back and forth to C++', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>());
        obj.setTest(E_1st);
        obj.getTest().should.equal(E_1st);
        obj.setTest(E_2nd);
        obj.getTest().should.equal(E_2nd);
        obj.setTest(E_3rd);
        obj.getTest().should.equal(E_3rd);
      });
      it('should be able to reference enums with params', {
        var obj = UObject.NewObject(new TypeParam<UTestUseEnum>());
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
