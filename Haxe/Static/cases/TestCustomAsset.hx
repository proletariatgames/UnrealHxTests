package cases;
using buddy.Should;
import unreal.*;
import assets.*;
import UBasicTypesUObject;

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
    });
  }
}
