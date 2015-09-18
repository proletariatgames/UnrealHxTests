package cases;
using buddy.Should;
import haxe.Int64;

class TestUObjectExterns extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - UObjects', {
      var basic = UBasicTypesUObject.CreateFromCpp();
      before({
        basic.boolNonProp = true;
        basic.boolProp = true;
        basic.stringNonProp = 'Hello from Haxe!!';
        basic.textNonProp = 'Text should also work';
        basic.ui8NonProp = 1;
        basic.i8NonProp = 2;
        basic.ui16NonProp = 3;
        basic.i16NonProp = 4;
        basic.i32Prop = 5;
        basic.ui32NonProp = 6;
        basic.i64NonProp = 7;
        basic.ui64NonProp = 8;
        basic.floatProp = 9.1;
        basic.doubleNonProp = 10.2;
      });

      describe('native properties', {

        it('should be able to be accessed (basic)', {
          var empty = UBasicTypesUObject.CreateFromCpp();
          empty.boolNonProp.should.be(false);
          empty.boolProp.should.be(false);
          empty.stringNonProp.should.be('');
          empty.textNonProp.should.be('');
          empty.ui8NonProp.should.be(0);
          empty.i8NonProp.should.be(0);
          empty.ui16NonProp.should.be(0);
          empty.i16NonProp.should.be(0);
          empty.i32Prop.should.be(0);
          empty.ui32NonProp.should.be(0);
          Int64.eq(empty.i64NonProp, 0).should.be(true);
          Int64.eq(empty.ui64NonProp, 0).should.be(true);
          empty.floatProp.should.be(0);
          empty.doubleNonProp.should.be(0);

          basic.boolNonProp.should.be(true);
          basic.boolProp.should.be(true);
          basic.stringNonProp.should.be('Hello from Haxe!!');
          basic.textNonProp.should.be('Text should also work');
          basic.ui8NonProp.should.be(1);
          basic.i8NonProp.should.be(2);
          basic.ui16NonProp.should.be(3);
          basic.i16NonProp.should.be(4);
          basic.i32Prop.should.be(5);
          basic.ui32NonProp.should.be(6);
          Int64.eq(basic.i64NonProp, 7).should.be(true);
          Int64.eq(basic.ui64NonProp, 8).should.be(true);
          basic.floatProp.should.beCloseTo(9.1);
          basic.doubleNonProp.should.be(10.2);
        });

        it('should be able to be accessed through reflection (basic)', {
          var basicDyn:Dynamic = basic;

          Reflect.setProperty(basicDyn,"boolNonProp", false);
          Reflect.setProperty(basicDyn,"boolProp", true);
          Reflect.setProperty(basicDyn,"stringProp", 'Hello from Haxe reflection!');
          Reflect.setProperty(basicDyn,"stringNonProp", 'Hello from Haxe reflection! (non-prop)');
          Reflect.setProperty(basicDyn,"textProp", 'Hello from Haxe reflection! (non-prop text)');
          Reflect.setProperty(basicDyn,"ui8NonProp", 10);
          Reflect.setProperty(basicDyn,"i8NonProp", 20);
          Reflect.setProperty(basicDyn,"ui16NonProp", 30);
          Reflect.setProperty(basicDyn,"i16NonProp", 40);
          Reflect.setProperty(basicDyn,"i32NonProp", 50);
          Reflect.setProperty(basicDyn,"ui32NonProp", 60);
          Reflect.setProperty(basicDyn,"i64NonProp", Int64.make(0xf0f0f0f0, 0xc0c0c0));
          Reflect.setProperty(basicDyn,"ui64NonProp", Int64.make(0xC001, 0x0FF1C3));
          Reflect.setProperty(basicDyn,"floatNonProp", 99.1);
          Reflect.setProperty(basicDyn,"doubleNonProp", 100.2);

          Reflect.getProperty(basicDyn,"boolNonProp").should.be(false);
          Reflect.getProperty(basicDyn,"boolProp").should.be(true);
          Reflect.getProperty(basicDyn,"stringProp").should.be('Hello from Haxe reflection!');
          Reflect.getProperty(basicDyn,"stringNonProp").should.be('Hello from Haxe reflection! (non-prop)');
          Reflect.getProperty(basicDyn,"textProp").should.be('Hello from Haxe reflection! (non-prop text)');
          Reflect.getProperty(basicDyn,"ui8NonProp").should.be(10);
          Reflect.getProperty(basicDyn,"i8NonProp").should.be(20);
          Reflect.getProperty(basicDyn,"ui16NonProp").should.be(30);
          Reflect.getProperty(basicDyn,"i16NonProp").should.be(40);
          Reflect.getProperty(basicDyn,"i32NonProp").should.be(50);
          Reflect.getProperty(basicDyn,"ui32NonProp").should.be(60);
          Int64.eq(Reflect.getProperty(basicDyn,"i64NonProp"), Int64.make(0xf0f0f0f0, 0xc0c0c0)).should.be(true);
          Int64.eq(Reflect.getProperty(basicDyn,"ui64NonProp"), Int64.make(0xC001, 0x0FF1C3)).should.be(true);
          (Reflect.getProperty(basicDyn,"floatNonProp") : Float).should.beCloseTo(99.1);
          (Reflect.getProperty(basicDyn,"doubleNonProp") : Float).should.be(100.2);
        });

        it('should be able to be accessed from subclasses (basic)', {
        });

        it('should be able to access "const" types');
      });

      describe('native functions', {
        it('should be able to be called (basic)', {
          var ret = basic.setBool_String_UI8_I8(false, "Hello from function", 255, 127);
          ret.should.not.be(null);
          ret.stringProp.should.be("Hello from function");
          basic.boolProp.should.be(false);
          basic.stringProp.should.be("Hello from function");
          basic.ui8Prop.should.be(255);
          basic.i8Prop.should.be(127);

          basic.setUI16_I16_UI32_I32(0xf0f0, 0x7f7f, 0xd3adb33f, 0xBADA55);
          basic.ui16Prop.should.be(0xf0f0);
          basic.i16Prop.should.be(0x7f7f);
          basic.ui32Prop.should.be(0xD3ADB33F);
          basic.i32Prop.should.be(0xBADA55);

          basic.setUI64_I64_Float_Double(Int64.make(0xCAF3,0xBAB3), Int64.make(0xD3AD,0xD00D), 11.1, 22.2).should.be(false);
          Int64.eq(basic.ui64Prop, Int64.make(0xCAF3,0xBAB3)).should.be(true);
          Int64.eq(basic.i64Prop, Int64.make(0xD3AD,0xD00D)).should.be(true);
          basic.floatProp.should.beCloseTo(11.1);
          basic.doubleProp.should.be(22.2);

          Int64.eq(basic.setText("Hello, FText!"), Int64.make(0xDEADBEEF, 0x8BADF00D)).should.be(true);
          basic.textNonProp.should.be("Hello, FText!");
        });

        it('should be able to be called from subclasses (basic)', {
        });
      });
      it('should be able to be created by Haxe code');
      it('should create a wrapper of the right type');
    });
  }
}

