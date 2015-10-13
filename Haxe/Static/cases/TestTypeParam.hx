package cases;
import NonUObject;
import SomeEnum;
import unreal.*;

using buddy.Should;

class TestTypeParam extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Type Params', {
      it('should be able to do a roundtrip between UE and Haxe', {
        // make sure all used types are defined
        var x:unreal.TypeParam<Bool> = null;
        var x:unreal.TypeParam<Int> = null;
        var x:unreal.TypeParam<FakeUInt32> = null;
        var x:unreal.TypeParam<Int8> = null;
        var x:unreal.TypeParam<UInt8> = null;
        var x:unreal.TypeParam<Int16> = null;
        var x:unreal.TypeParam<UInt16> = null;
        var x:unreal.TypeParam<Int64> = null;
        var x:unreal.TypeParam<FakeUInt64> = null;
        var x:unreal.TypeParam<Float32> = null;
        var x:unreal.TypeParam<Float64> = null;

        TypeParamTester.testRoundtrip().should.be(true);
      });
    });
  }
}
  // public var myEnum:SomeEnum.EMyEnum;
  // public var myCppEnum:SomeEnum.EMyCppEnum;
  // public var myNamespacedEnum:SomeEnum.EMyNamespacedEnum;

