package cases;
import NonUObject;
import SomeEnum;
using buddy.Should;

class TestUEnum extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UEnums', {
      it('should be able to get/set UEnum fields', {
        var s = FHasStructMember1.create();
        s.myEnum = SomeEnum1;
        s.myCppEnum = CppEnum1;
        s.myNamespacedEnum = NSEnum1;
        s.myEnum.should.be(SomeEnum1);
        s.myCppEnum.should.be(CppEnum1);
        s.myNamespacedEnum.should.be(NSEnum1);

        s.myEnum = SomeEnum2;
        s.myCppEnum = CppEnum2;
        s.myNamespacedEnum = NSEnum2;
        s.myEnum.should.be(SomeEnum2);
        s.myCppEnum.should.be(CppEnum2);
        s.myNamespacedEnum.should.be(NSEnum2);

        s.myEnum = SomeEnum3;
        s.myCppEnum = CppEnum3;
        s.myNamespacedEnum = NSEnum3;
        s.myEnum.should.be(SomeEnum3);
        s.myCppEnum.should.be(CppEnum3);
        s.myNamespacedEnum.should.be(NSEnum3);
      });
      it('should be able to define new UEnums');
    });
  }
}
  // public var myEnum:SomeEnum.EMyEnum;
  // public var myCppEnum:SomeEnum.EMyCppEnum;
  // public var myNamespacedEnum:SomeEnum.EMyNamespacedEnum;
