package cases;
import unreal.*;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestTArray extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - TArray', {
      it('should be able to use TArray of basic types',{
        var arr = TArray.create(new TypeParam<Int32>());
        for (i in 0...10) {
          arr.Push(i+1);
        }
        for (i in 0...10) {
          arr.get_Item(i).should.be(i+1);
        }

        var arr = TArray.create(new TypeParam<Float64>());
        for (i in 0...10) {
          arr.Push(i+1 + (i+1) / 10);
        }
        for (i in 0...10) {
          arr.get_Item(i).should.be(i+1 + (i + 1) / 10);
        }
      });
      it('should be able to use TArray of uclass types');
      it('should be able to use TArray of structs');
      it('should be able to use TArray as member of extern uclass types');
      it('should be able to use TArray as member of declared uclass types (UPROPERTY)');
      it('should be able to use TArray on structs');
    });
  }
}

