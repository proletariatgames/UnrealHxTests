package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestTArray extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - TArray', {
      it('should be able to use TArray of basic types');
      it('should be able to use TArray of uclass types');
      it('should be able to iterate/use array methods');
      it('should be able to use TArray of structs');
      it('should be able to use TArray as member of extern uclass types');
      it('should be able to use TArray as member of declared uclass types (UPROPERTY)');
      it('should be able to use TArray on structs');
    });
  }
}

