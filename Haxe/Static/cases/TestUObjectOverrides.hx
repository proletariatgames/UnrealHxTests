package cases;
using buddy.Should;

class TestUObjectOverrides extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UObjects overrides', {
      it('should be able to access native properties (basic)');
      it('should be able to call native code (basic)');
      it('should be able to have their functions overridden'); // check if native side sees it as well
      // test const this
      it('should be able to call super methods');
      it('should be able to define non-uclass classes');
      it('should be able to define new uproperties (basic)');
      it('should be able to define new ufunctions (basic)');
      it('should be able to perform garbage-collection operations inside an overridden code');
      it('should be able to throw inside overridden code');
      it('should be released when UObject is garbage collected');
      it('should be able to access super protected fields');

      it('should be able to define new BlueprintNativeEvent');
    });
  }
}

