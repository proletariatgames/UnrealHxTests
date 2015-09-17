package cases;
using buddy.Should;

class TestUObjectExterns extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UObjects', {
      it('should be able to access native properties (basic)');
      it('should be able to access native properties of superclasses (basic)');
      it('should be able to call native functions (basic)');
      it('should be able to call native functions of superclasses (basic)');
      it('should be able to be created by Haxe code');
      it('should create a wrapper of the right type');
    });
  }
}

