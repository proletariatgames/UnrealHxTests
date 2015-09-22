package cases;
using buddy.Should;
import NonUObject;

class TestStructs extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Structs', {
      it('should be able to use simple non-uobject classes', {
        FSimpleStruct.nDestructorCalled.should.be(0);
        // run in a separate function to make sure no hidden references are kept in the stack
        function run() {
          var simple = FSimpleStruct.getRef();
          simple.f1 = 1.1;
          simple.d1 = 2.2;
          simple.i32 = 10;
          simple.ui32 = 20;
          var s2 = FSimpleStruct.getRef();
          s2.f1.should.beCloseTo(1.1);
          s2.d1.should.be(2.2);
          s2.i32.should.be(10);
          s2.ui32.should.be(20);
          simple = null;
          s2 = null;
        }
        // run twice to make sure that the finalizers are run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        FSimpleStruct.nDestructorCalled.should.be(0);
      });
      it('should be able to instantiate simple non-uobject classes', {
        FSimpleStruct.nDestructorCalled.should.be(0);
        // var simple = FSimpleStruct.create();
      });
    });
  }
}
