package cases;
using buddy.Should;

class TestUEnum extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UEnums', {
      it('should be able to reference UEnums');
      it('should be able to get/set UEnum fields');
      it('should be able to define new UEnums');
    });
  }
}
