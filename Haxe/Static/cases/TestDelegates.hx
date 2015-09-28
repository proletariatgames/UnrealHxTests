package cases;
using buddy.Should;
import NonUObject;
import helpers.TestHelper;

class TestDelegates extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Delegates', {
      it('should be able to call delegates');
      it('should be able to register delegates from Haxe code');
      it('should be able to unregister delegates from Haxe code');
      it('should be able to create new UCLASS types that use delegates');
      it('should be able to declare new delegate types');
    });
  }
}


