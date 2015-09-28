package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestVector extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - FVector types', {
      it('should be able to create new vectors');
      it('should be able to manipulate vectors');
      it('should be able to declare externs with vectors');
      it('should be able to declare new classes with vector members (UPROPERTY and not)');
    });
  }
}



