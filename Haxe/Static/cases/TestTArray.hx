package cases;
import unreal.*;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestTArray extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - TArray', {
      it('should be able to use TArray of basic types',{
        var arr = TArrayImpl.create(new TypeParam<Int32>());
        for (i in 0...10) {
          arr.Push(i+1);
        }
        for (i in 0...10) {
          arr.get_Item(i).should.be(i+1);
        }

        var arr = TArrayImpl.create(new TypeParam<Float64>());
        for (i in 0...10) {
          arr.Push(i+1 + (i+1) / 10);
        }
        for (i in 0...10) {
          arr.get_Item(i).should.be(i+1 + (i + 1) / 10);
        }

        var arr = TArrayImpl.create(new TypeParam<Float32>());
        for (i in 0...10) {
          arr.Push(i+1 + (i+1) / 10);
        }
        for (i in 0...10) {
          arr.get_Item(i).should.beCloseTo(i+1 + (i + 1) / 10);
        }
      });
      it('should be able to use TArray of uclass types');
      it('should be able to use TArray of structs');
      it('should be able to use TArray as member of extern uclass types');
      it('should be able to use TArray as member of declared uclass types (UPROPERTY)', {
        var obj = UObject.NewObject(new TypeParam<PStruct<UTestTArray>>());
        obj.array.Push("Hello from Haxe!");
        obj.array.length.should.be(1);
        obj.array[0].toString().should.be("Hello from Haxe!");
      });
      it('should be able to use TArray on structs');
    });
  }
}

@:uclass
class UTestTArray extends UObject {
  @:uproperty
  public var array:TArray<FString>;
}
