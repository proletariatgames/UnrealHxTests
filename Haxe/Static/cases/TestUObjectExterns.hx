package cases;
using buddy.Should;
import UBasicTypesSub;
import unreal.*;

using unreal.CoreAPI;

class TestUObjectExterns extends buddy.BuddySuite {

  public function new() {
    var x = unreal.FPlatformFileManager.Get();
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
          empty.stringNonProp.toString().should.be('');
          empty.textNonProp.toString().should.be('');
          empty.ui8NonProp.should.be(0);
          empty.i8NonProp.should.be(0);
          empty.ui16NonProp.should.be(0);
          empty.i16NonProp.should.be(0);
          empty.i32Prop.should.be(0);
          empty.ui32NonProp.should.be(0);
          empty.i64NonProp.should.be(0);
          empty.ui64NonProp.should.be(0);
          empty.floatProp.should.be(0);
          empty.doubleNonProp.should.be(0);

          basic.boolNonProp.should.be(true);
          basic.boolProp.should.be(true);
          basic.stringNonProp.toString().should.be('Hello from Haxe!!');
          basic.textNonProp.toString().should.be('Text should also work');
          basic.ui8NonProp.should.be(1);
          basic.i8NonProp.should.be(2);
          basic.ui16NonProp.should.be(3);
          basic.i16NonProp.should.be(4);
          basic.i32Prop.should.be(5);
          basic.ui32NonProp.should.be(6);
          basic.i64NonProp.should.be(7);
          basic.ui64NonProp.should.be(8);
          basic.floatProp.should.beCloseTo(9.1);
          basic.doubleNonProp.should.be(10.2);
        });

        it('should be able to be accessed through reflection (basic)', {
          var i64:Int64 = 0;
          var basicDyn:Dynamic = basic;

          Reflect.setProperty(basicDyn,"boolNonProp", false);
          Reflect.setProperty(basicDyn,"boolProp", true);
          Reflect.setProperty(basicDyn,"stringProp", new unreal.FString('Hello from Haxe reflection!'));
          Reflect.setProperty(basicDyn,"stringNonProp", new unreal.FString('Hello from Haxe reflection! (non-prop)'));
          Reflect.setProperty(basicDyn,"textProp", new unreal.FText('Hello from Haxe reflection! (non-prop text)'));
          Reflect.setProperty(basicDyn,"ui8NonProp", 10);
          Reflect.setProperty(basicDyn,"i8NonProp", 20);
          Reflect.setProperty(basicDyn,"ui16NonProp", 30);
          Reflect.setProperty(basicDyn,"i16NonProp", 40);
          Reflect.setProperty(basicDyn,"i32NonProp", 50);
          Reflect.setProperty(basicDyn,"ui32NonProp", 60);
          Reflect.setProperty(basicDyn,"i64NonProp", i64 = cast haxe.Int64.make(0xf0f0f0f0, 0xc0c0c0));
          Reflect.setProperty(basicDyn,"ui64NonProp", i64 = cast haxe.Int64.make(0xC001, 0x0FF1C3));
          Reflect.setProperty(basicDyn,"floatNonProp", 99.1);
          Reflect.setProperty(basicDyn,"doubleNonProp", 100.2);

          Reflect.getProperty(basicDyn,"boolNonProp").should.be(false);
          Reflect.getProperty(basicDyn,"boolProp").should.be(true);
          (Reflect.getProperty(basicDyn,"stringProp") : unreal.FString).toString().should.be('Hello from Haxe reflection!');
          (Reflect.getProperty(basicDyn,"stringNonProp") : unreal.FString).toString().should.be('Hello from Haxe reflection! (non-prop)');
          (Reflect.getProperty(basicDyn,"textProp") : unreal.FText).toString().should.be('Hello from Haxe reflection! (non-prop text)');
          Reflect.getProperty(basicDyn,"ui8NonProp").should.be(10);
          Reflect.getProperty(basicDyn,"i8NonProp").should.be(20);
          Reflect.getProperty(basicDyn,"ui16NonProp").should.be(30);
          Reflect.getProperty(basicDyn,"i16NonProp").should.be(40);
          Reflect.getProperty(basicDyn,"i32NonProp").should.be(50);
          Reflect.getProperty(basicDyn,"ui32NonProp").should.be(60);
          Reflect.getProperty(basicDyn,"i64NonProp").should.be(i64 = cast haxe.Int64.make(0xf0f0f0f0, 0xc0c0c0));
          Reflect.getProperty(basicDyn,"ui64NonProp").should.be(i64 = cast haxe.Int64.make(0xC001, 0x0FF1C3));
          (Reflect.getProperty(basicDyn,"floatNonProp") : Float).should.beCloseTo(99.1);
          (Reflect.getProperty(basicDyn,"doubleNonProp") : Float).should.be(100.2);
        });
        it('should be able to be created as null', {
          UBasicTypesUObject.isNull(null).should.be(true);
          UBasicTypesUObject.getNull().should.be(null);
        });
        it('should be able to check physical equality', {
          var basicType =  UBasicTypesUObject.CreateFromCpp();
          (basicType.getSelf() == null).should.be(false);
          (basicType.getSelf() == basicType.getSelf()).should.be(true);
          (basicType.getSelf() == basicType).should.be(true);
          (basicType.getSelf() != basicType).should.be(false);
          var dyn:Dynamic = basicType;
          (dyn.getSelf() == dyn).should.be(true);
          (dyn.getSelf() != dyn).should.be(false);
          var iface1:IInterface = basicType;
          var iface2:IInterface = basicType.getSelf();
          (iface1 == iface2).should.be(true);
          (iface1 != iface2).should.be(false);
        });
        it('should be able to check structural equality', {
          //This just checks pointers for uobjects
          var basicType =  UBasicTypesUObject.CreateFromCpp();
          (basicType.getSelf() == null).should.be(false);
          (basicType.getSelf() == basicType.getSelf()).should.be(true);
        });
        it('should be able to be accessed from subclasses (basic)', {
          var sub1 = UBasicTypesSub1.CreateFromCpp();
          var sub2 = UBasicTypesSub2.CreateFromCpp();
          var sub3 = UBasicTypesSub3.CreateFromCpp();
          sub1.isSub1.should.be(true);
          sub2.isSub2.should.be(true);
          sub3.isSub2.should.be(true);
          sub3.isSub3.should.be(true);

          sub1.stringProp = 'Test sub1';
          sub1.stringProp.toString().should.be('Test sub1');
          sub2.stringProp = 'Test sub2';
          sub2.stringProp.toString().should.be('Test sub2');
          sub3.stringProp = 'Test sub3';
          sub3.stringProp.toString().should.be('Test sub3');

          Std.is(sub2, IBasicType2).should.be(true);
          sub2.doSomething().getSubName().toString().should.be("Sub2");
          sub2.getSubName().toString().should.be("Sub2");
          sub2.getSomeInt().should.be(0xf00);

          sub2 = sub3;
          sub2.stringProp = 'Test sub3';
          sub2.stringProp.toString().should.be('Test sub3');

          sub2.doSomething().getSubName().toString().should.be("Sub3");
          sub2.getSubName().toString().should.be("Sub3");
          sub2.getSomeInt().should.be(0xba5);
        });
      });

      describe('native functions', {
        it('should be able to be called (basic)', {
          var ret = basic.setBool_String_UI8_I8(false, "Hello from function", 255, 127);
          ret.should.not.be(null);
          ret.stringProp.toString().should.be("Hello from function");
          basic.boolProp.should.be(false);
          basic.stringProp.toString().should.be("Hello from function");
          basic.ui8Prop.should.be(255);
          basic.i8Prop.should.be(127);

          basic.setUI16_I16_UI32_I32(0xf0f0, 0x7f7f, 0xd3adb33f, 0xBADA55);
          basic.ui16Prop.should.be(0xf0f0);
          basic.i16Prop.should.be(0x7f7f);
          basic.ui32Prop.should.be(0xD3ADB33F);
          basic.i32Prop.should.be(0xBADA55);

          basic.setUI64_I64_Float_Double(cast haxe.Int64.make(0xCAF3,0xBAB3), cast haxe.Int64.make(0xD3AD,0xD00D), 11.1, 22.2).should.be(false);
          var i64:Int64 = 0;
          basic.ui64Prop.should.be((i64 = cast haxe.Int64.make(0xCAF3,0xBAB3)));
          basic.i64Prop.should.be(i64 = cast haxe.Int64.make(0xD3AD,0xD00D));
          basic.floatProp.should.beCloseTo(11.1);
          basic.doubleProp.should.be(22.2);

          basic.setText("Hello, FText!").should.be(i64 = cast haxe.Int64.make(0xDEADBEEF, 0x8BADF00D));
          basic.textNonProp.toString().should.be("Hello, FText!");

          basic.getSomeNumber().should.be(42);
        });

        it('should be able to be called from subclasses (basic)', {
          var i64:Int64 = 0;
          var sub1 = UBasicTypesSub1.CreateFromCpp();
          var sub2 = UBasicTypesSub2.CreateFromCpp();
          var sub3 = UBasicTypesSub3.CreateFromCpp();

          sub1.getSomeNumber().should.be(43);
          sub2.getSomeNumber().should.be(44);
          sub3.getSomeNumber().should.be(45);

          sub1.setText("testing subclass call").should.be(i64 = cast haxe.Int64.ofInt(0xD00D));
          sub2.setText("testing subclass call2").should.be(i64 = cast haxe.Int64.make(0xDEADBEEF, 0x8BADF00D));
          sub3.setText("testing subclass call3").should.be(i64 = cast haxe.Int64.make(0,0xDEADF00D));
          sub1.textNonProp.toString().should.be("testing subclass call");
          sub2.textNonProp.toString().should.be("testing subclass call2");
          sub3.textProp.toString().should.be("testing subclass call3");

          var base1:UBasicTypesUObject = sub1;
          var base2:UBasicTypesUObject = sub2;
          var base3:UBasicTypesUObject = sub3;

          base1.getSomeNumber().should.be(43);
          base2.getSomeNumber().should.be(44);
          base3.getSomeNumber().should.be(45);

          base1.setText("testing baseclass call").should.be(i64 = cast haxe.Int64.ofInt(0xD00D));
          base2.setText("testing baseclass call2").should.be(i64 = cast haxe.Int64.make(0xDEADBEEF, 0x8BADF00D));
          base3.setText("testing baseclass call3").should.be(i64 = cast haxe.Int64.make(0,0xDEADF00D));
          base1.textNonProp.toString().should.be("testing baseclass call");
          base2.textNonProp.toString().should.be("testing baseclass call2");
          base3.textProp.toString().should.be("testing baseclass call3");

          sub2 = sub3;
          sub2.setText("testing subclass call3-1").should.be(i64 = cast haxe.Int64.make(0,0xDEADF00D));
          sub2.textProp.toString().should.be("testing subclass call3-1");
        });
      });

      it('derived classes should be able to access protected members', {
        var protected1 = unreal.UObject.NewObject(new unreal.TypeParam<UHaxeProtected1>());
        var ret = protected1.callProtectedFunc1();
        ret.should.not.be(null);
        ret.stringProp.toString().should.be("Hello from protected");
        protected1.boolProp.should.be(true);
        protected1.stringProp.toString().should.be("Hello from protected");
        protected1.ui8Prop.should.be(254);
        protected1.i8Prop.should.be(-99);

        protected1.callProtectedFunc2();
        protected1.boolProp.should.be(false);
        protected1.stringProp.toString().should.be("Second hello from protected");
        protected1.ui8Prop.should.be(253);
        protected1.i8Prop.should.be(-88);
      });

      it('derived classes should be able to override external protected functions', {
        var protected2 = unreal.UObject.NewObject(new unreal.TypeParam<UHaxeProtected2>());
        var ret = protected2.callProtectedFunc1();
        ret.should.not.be(null);
        ret.stringProp.toString().should.be("Overridden in HaxeProtected2!");
        protected2.boolProp.should.be(true);
        protected2.stringProp.toString().should.be("Overridden in HaxeProtected2!");
        protected2.ui8Prop.should.be(123);
        protected2.i8Prop.should.be(-123);
        protected2.getProtectedI32().should.be(1024*16);
        protected2.getProtectedFString().toString().should.be("FString overridden!");

        protected2.callProtectedFunc2();
        protected2.boolProp.should.be(false);
        protected2.stringProp.toString().should.be("ALSO overridden in HaxeProtected2!");
        protected2.ui8Prop.should.be(0);
        protected2.i8Prop.should.be(-1);
        protected2.getProtectedI32().should.be(666);
        protected2.getProtectedFString().toString().should.be("FString ALSO overridden!");
      });
      it('should be able to use pointers to uint8', {
        var bsub = UObject.NewObject(new TypeParam<UBasicTypesSub1>());
        var arr = ByteArray.alloc(20);
        arr.set(0,0);
        bsub.writeToByteArray(arr, 0, 15).should.be(true);
        arr.get(0).should.be(15);
        bsub.writeToByteArray(arr, 2, 42);
        arr.get(2).should.be(42);
      });

      it('should be able to tell whether it is valid', {
        var sub2 = UBasicTypesSub2.CreateFromCpp();
        // (GIsEditor ? RF_Native|RF_AsyncLoading|RF_Standalone|RF_Async : RF_Native|RF_AsyncLoading|RF_Async)
        var flags = EObjectFlags.RF_Native|EObjectFlags.RF_AsyncLoading|EObjectFlags.RF_Async;
        UObject.CollectGarbage(flags, true);
        sub2.isValid().should.be(false);
      });

      it('should be able to call global functions');
      it('should be able to be called when overloads exist');
      it('should be able to be created by Haxe code');
      it('should create a wrapper of the right type');
      it('should be able to call functions with defaults');
      it('should be able to call global functions');
      it('should be able to use pointers to basic types');
      it('should be able to use structs');
      it('should be able to use pointers to structs');
      it('should be able to be referenced by weak pointer');
    });
  }
}

// Derived class with calls to protected members of the base class

@:uclass
class UHaxeProtected1 extends UBasicTypesUObject {
  public function callProtectedFunc1() : UBasicTypesUObject {
    return setBool_String_UI8_I8_protected(true, "Hello from protected", 254, -99);
  }
  public function callProtectedFunc2() : Void  {
    nonUFUNCTION_setBool_String_UI8_I8_protected(false, "Second hello from protected", 253, -88);
  }
  public function getProtectedI32() : unreal.Int32 { return m_i32; }
  public function getProtectedFString() : unreal.FString { return m_FStringProp; }

  //TODO Blocked on const reference
  // @:ufunction(BlueprintImplementableEvent)
  // @:uname("OnBlueprintImplementedFName")
  // public function onBlueprintImplementedFName(i32:unreal.Int32, fname:unreal.PStruct<unreal.FName>) : Void;
}

@:uclass
class UHaxeProtected2 extends UHaxeProtected1 {

  override private function setBool_String_UI8_I8_protected(b:Bool, str:unreal.FString, ui8:unreal.UInt8, i8:unreal.Int8) : UBasicTypesUObject {
    var ret = super.setBool_String_UI8_I8_protected(b, str, ui8, i8);
    boolProp = true;
    stringProp = "Overridden in HaxeProtected2!";
    ui8Prop = 123;
    i8Prop = -123;
    m_i32 = 1024*16;
    m_FStringProp = "FString overridden!";
    return ret;
  }

  override private function nonUFUNCTION_setBool_String_UI8_I8_protected(b:Bool, str:unreal.FString, ui8:unreal.UInt8, i8:unreal.Int8) : Void {
    boolProp = false;
    stringProp = "ALSO overridden in HaxeProtected2!";
    ui8Prop = 0;
    i8Prop = -1;
    m_i32 = 666;
    m_FStringProp = "FString ALSO overridden!";
  }
}


