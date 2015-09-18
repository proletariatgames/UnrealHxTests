package cases;
using buddy.Should;
import haxe.Int64;

class TestUObjectExterns extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UObjects', {
      var basic = UBasicTypesUObject.CreateFromCpp();
      it('should be able to access native properties (basic)', {
        basic.boolNonProp.should.be(false);
        basic.boolProp.should.be(false);
        basic.stringNonProp.should.be('');
        basic.ui8NonProp.should.be(0);
        basic.i8NonProp.should.be(0);
        basic.ui16NonProp.should.be(0);
        basic.i16NonProp.should.be(0);
        basic.i32NonProp.should.be(0);
        basic.ui32NonProp.should.be(0);
        Int64.eq(basic.i64NonProp, 0).should.be(true);
        Int64.eq(basic.ui64NonProp, 0).should.be(true);
        basic.floatNonProp.should.be(0);
        basic.doubleNonProp.should.be(0);

        basic.boolNonProp = true;
        basic.boolProp = true;
        basic.stringNonProp = 'Hello from Haxe!!';
        basic.ui8NonProp = 1;
        basic.i8NonProp = 2;
        basic.ui16NonProp = 3;
        basic.i16NonProp = 4;
        basic.i32NonProp = 5;
        basic.ui32NonProp = 6;
        basic.i64NonProp = 7;
        basic.ui64NonProp = 8;
        basic.floatNonProp = 9.1;
        basic.doubleNonProp = 10.2;

        basic.boolNonProp.should.be(true);
        basic.boolProp.should.be(true);
        basic.stringNonProp.should.be('Hello from Haxe!!');
        basic.ui8NonProp.should.be(1);
        basic.i8NonProp.should.be(2);
        basic.ui16NonProp.should.be(3);
        basic.i16NonProp.should.be(4);
        basic.i32NonProp.should.be(5);
        basic.ui32NonProp.should.be(6);
        Int64.eq(basic.i64NonProp, 7).should.be(true);
        Int64.eq(basic.ui64NonProp, 8).should.be(true);
        basic.floatNonProp.should.beCloseTo(9.1);
        basic.doubleNonProp.should.be(10.2);
      });
      it('should be able to be accessed through reflection (basic)', {
      });
      it('should be able to access native properties of superclasses (basic)');
      it('should be able to call native functions (basic)');
      it('should be able to call native functions of superclasses (basic)');
      it('should be able to be created by Haxe code');
      it('should create a wrapper of the right type');
    });
  }
}

