package cases;
using buddy.Should;
import NonUObject;
import haxeunittests.*;

class TestInterfaces extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Interfaces', {
      it('should be able to call extern interface functions');
      it('should be able to implement interfaces');
    });
  }
}
