package cases;
using buddy.Should;
import UBasicTypesUObject;

class TestConst extends buddy.BuddySuite {

  public function new() {
    var const1 = unreal.UObject.NewObject(new unreal.TypeParam<unreal.PStruct<UHaxeConst>>());
    var geo = unreal.FGeometry.create();
    describe('Haxe - Const params', {
      it('should be able to generate code that uses const types', {
        const1.should.not.be(null);
      });
      it('should be able to override public functions with const parameters', {
        var geoStr = geo.ToString();
        var out = const1.testConstParam(geo);
        out.should.be('OVERRIDE ' + geoStr);
      });
      it('should be able to override protected functions with const parameters', {
        // TODO pending protected const extension
        //
        // var geoStr = geo.ToString();
        // var out = const1.doTestConstParam_protected(geo);
        // out.should.be('OVERRIDE PROTECTED ' + geoStr);
      });
    });
  }
}

// Derived class with calls to protected members of the base class

@:uclass
class UHaxeConst extends UBasicTypesUObject {
  @:ufunction(BlueprintImplementableEvent)
  @:uname("OnBlueprintImplementedFText")
  public function onBlueprintImplementedFGeometry(i32:unreal.Int32, someGeo:unreal.Const<unreal.PRef<unreal.FGeometry>>) : Void;

  override public function testConstParam(geo:unreal.Const<unreal.PRef<unreal.FGeometry>>) : unreal.FString {
    return "OVERRIDE " + super.testConstParam(geo);
  }

  // TODO pending protected const extension
  //

  // override public function testConstParam_protected(geo:unreal.Const<unreal.PRef<unreal.FGeometry>>) : unreal.FString {
  //   return "OVERRIDE PROTECTED " + super.testConstParam(geo);
  // }

  // public function doTestConstParam_protected(geo:unreal.Const<unreal.PRef<unreal.FGeometry>>) : unreal.FString {
  //   return this.testConstParam_protected(geo);
  //}
}
