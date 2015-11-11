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
        var x:unreal.TypeParamGlue<Bool> = null;
        var x:unreal.TypeParamGlue<Int> = null;
        var x:unreal.TypeParamGlue<FakeUInt32> = null;
        var x:unreal.TypeParamGlue<Int8> = null;
        var x:unreal.TypeParamGlue<UInt8> = null;
        var x:unreal.TypeParamGlue<Int16> = null;
        var x:unreal.TypeParamGlue<UInt16> = null;
        var x:unreal.TypeParamGlue<Int64> = null;
        var x:unreal.TypeParamGlue<FakeUInt64> = null;
        var x:unreal.TypeParamGlue<Float32> = null;
        var x:unreal.TypeParamGlue<Float64> = null;
        var x:unreal.TypeParamGlue<EMyEnum> = null;
        var x:unreal.TypeParamGlue<EMyCppEnum> = null;
        var x:unreal.TypeParamGlue<EMyNamespacedEnum> = null;
        var x:unreal.TypeParamGlue<cases.TestUEnum.ETestHxEnumClass> = null;

        TypeParamTester.testRoundtrip().should.be(true);
      });
    });
  }
}
