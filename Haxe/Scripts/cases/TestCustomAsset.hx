package cases;
using buddy.Should;
import unreal.*;
import assets.*;
import haxeunittests.*;
import NonUObject;

class TestCustomAsset extends buddy.BuddySuite {

  public function new() {
    describe('Haxe - Custom asset', {
      it('should be able to load a custom asset saved as a game content', {
        var obj = UObject.LoadObject(new TypeParam<UHaxeAsset>(), UHaxeAsset.StaticClass(), '/Game/test', '/Game/test', 0, null);
        obj.should.not.be(null);
        Std.is(obj,UHaxeAsset).should.be(true);
        obj.data.a.should.be(10);
        obj.data.b.should.be(100);
        obj.data.c.should.be(1000.1);

      });
      // it('should be able to load an asset previously saved by a commandlet', {
      //   var obj = UObject.LoadObject(new TypeParam<UHaxeAsset>(), UHaxeAsset.StaticClass(), '/Game/SomeAsset', '/Game/SomeAsset', 0, null);
      //   obj.data.stamp.should.not.be(null);
      //   if (Sys.getEnv('CUSTOM_STAMP') != null) {
      //     trace('Checking stamp ${Sys.getEnv("CUSTOM_STAMP")}');
      //     obj.data.stamp.should.be(Sys.getEnv('CUSTOM_STAMP'));
      //   }
      //   obj.data.someInt.should.be(42);
      // });
    });
  }
}
