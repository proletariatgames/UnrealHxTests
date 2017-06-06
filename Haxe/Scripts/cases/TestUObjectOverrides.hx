package cases;
import unreal.*;
import NonUObject;
using buddy.Should;
import UBasicTypesSub;

using unreal.CoreAPI;
using helpers.TestHelper;

class TestUObjectOverrides extends buddy.BuddySuite {

  public function new() {
    var __status:buddy.SpecAssertion = null;
    inline function setSomeValues(obj:UBasicTypesSub1, multiplier:Int) {
      obj.boolNonProp = true;
      obj.boolProp = true;
      obj.stringNonProp = 'Hello from Haxe!!' + multiplier;
      obj.textNonProp = 'Text should also work' + multiplier;
      obj.ui8NonProp = 1 * multiplier;
      obj.i8NonProp = 2 * multiplier;
      obj.ui16NonProp = 3 * multiplier;
      obj.i16NonProp = 4 * multiplier;
      obj.i32Prop = 5 * multiplier;
      obj.ui32NonProp = 6 * multiplier;
      obj.i64NonProp = 7 * multiplier;
      obj.ui64NonProp = 8 * multiplier;
      obj.floatProp = 9.1 * multiplier;
      obj.doubleNonProp = 10.2 * multiplier;
    }
    inline function checkValues(obj:UBasicTypesSub1, multiplier:Int, __status) {
      obj.boolNonProp.should.be(true);
      obj.boolProp.should.be(true);
      obj.stringNonProp.toString().should.be('Hello from Haxe!!' + multiplier);
      obj.textNonProp.toString().should.be('Text should also work' + multiplier);
      obj.ui8NonProp.should.be(1 * multiplier);
      obj.i8NonProp.should.be(2 * multiplier);
      obj.ui16NonProp.should.be(3 * multiplier);
      obj.i16NonProp.should.be(4 * multiplier);
      obj.i32Prop.should.be(5 * multiplier);
      obj.ui32NonProp.should.be(6 * multiplier);
      obj.i64NonProp.should.be(7 * multiplier);
      obj.ui64NonProp.should.be(8 * multiplier);
      obj.floatProp.should.beCloseTo(9.1 * multiplier);
      obj.doubleNonProp.should.be(10.2 * multiplier);
    }
    describe('Haxe: uobjects overrides', {
      it('should be able to access native properties (basic)', {
        var obj1 = UHaxeDerived1.create(),
            obj2 = UHaxeDerived2.create(),
            obj3 = UHaxeDerived3.create();
        setSomeValues(obj1, 1);
        setSomeValues(obj2, 2);
        setSomeValues(obj3, 3);
        checkValues(obj1, 1, __status);
        checkValues(obj2, 2, __status);
        checkValues(obj3, 3, __status);

        function testObj(obj1:UHaxeDerived1, kind:Int) {
          obj1.intProp = 10;
          obj1.intProp.should.be(10);
          obj1.otherInt = 20;
          obj1.otherInt.should.be(20);

          obj1.i32Prop = 222;
          obj1.getSomeNumber().should.be(2220);
          var cur = obj1.returnsItself();
          obj1.returnsItself().getSomeNumber().should.be(2220);
          TestHelper.reflectCall(obj1.returnsItself()).getSomeNumber().should.be(2220);
        }
        obj1.nonNative(10).should.be(20);
        obj2.nonNative(10).should.be(120);
        obj3.nonNative(10).should.be(320);
        obj2.getSubName().toString().should.be("HaxeDerived2");
        obj3.getSubName().toString().should.be("HaxeDerived3");
        testObj(obj1,1);
        testObj(obj2,2);
        testObj(obj3,3);
#if (pass >= 2)
        var obj4 = UHaxeDerived4.create();
        setSomeValues(obj4, 3);
        checkValues(obj4, 3, __status);
        obj4.nonNative(10).should.be(320);
        obj4.getSubName().toString().should.be("HaxeDerived4");
        testObj(obj4,3);

        var obj5 = UHaxeDerived5.create();
        obj5.theStr.toString().should.be("the str");
        obj5.theStr = "test";
        obj5.theStr.toString().should.be("test");
        setSomeValues(obj5, 3);
        checkValues(obj5, 3, __status);
        obj5.nonNative(10).should.be(320);
        obj5.getSubName().toString().should.be("HaxeDerived5");
        testObj(obj5,3);
#end
      });
      it('should be able to have their functions overridden', {
        var obj1 = UHaxeDerived1.create(),
            obj2 = UHaxeDerived2.create(),
            obj3 = UHaxeDerived3.create();
        obj1.setText("MyText").should.be(unreal.Int64Helpers.make(0,0xD00D));
        obj1.textNonProp.toString().should.be("MyText");
        obj2.getSomeInt().should.be(0xf00ba5);
        obj3.setText("MyText").should.be(unreal.Int64Helpers.make(0x0111,0xF0FA));
        obj3.boolProp.should.be(true);
        obj3.stringProp.toString().should.be("MyText");
        obj3.ui8Prop.should.be(100);
        obj3.i8Prop.should.be(101);

        TestHelper.reflectCallPass2(obj1.uFunction4());
        obj1.otherInt.should.be(10);
        TestHelper.reflectCallPass2(obj2.uFunction4());
        obj2.otherInt.should.be(25);
#if (pass >= 2)
        var obj4 = UHaxeDerived4.create();
        obj4.setText("MyText").should.be(unreal.Int64Helpers.make(0x0111,0xF0F0));
        obj4.otherProp = unreal.Int64Helpers.make(0x0222,0xF0F5);
        obj4.otherProp2 = unreal.Int64Helpers.make(0x1333,0xF3F4);
        obj4.otherProp.should.be(unreal.Int64Helpers.make(0x0222, 0xF0F5));
        obj4.otherProp2.should.be(unreal.Int64Helpers.make(0x1333, 0xF3F4));

        obj4.boolProp.should.be(true);
        obj4.stringProp.toString().should.be("MyText");
        obj4.ui8Prop.should.be(100);
        obj4.i8Prop.should.be(101);

        obj4.newProperty.toString().should.be('Dynamic load ok');
        obj4.getSubName().toString().should.be('HaxeDerived4');
        obj4.textProp.toString().should.be('test2()');

        var obj5 = UHaxeDerived5.create();
        obj5.setText("MyText").should.be(unreal.Int64Helpers.make(0x0111,0xF0F0));
        obj5.otherProp = unreal.Int64Helpers.make(0x0222,0xF0F5);
        obj5.otherProp2 = unreal.Int64Helpers.make(0x1333,0xF3F4);
        obj5.otherProp.should.be(unreal.Int64Helpers.make(0x0222, 0xF0F5));
        obj5.otherProp2.should.be(unreal.Int64Helpers.make(0x1333, 0xF3F4));

        obj5.boolProp.should.be(true);
        obj5.stringProp.toString().should.be("MyText");
        obj5.ui8Prop.should.be(100);
        obj5.i8Prop.should.be(101);

        obj5.newProperty.toString().should.be('Dynamic load ok');
        obj5.getSubName().toString().should.be('HaxeDerived5');
        obj5.textProp.toString().should.be('test3()');
#end
      }); // check if native side sees it as well
      it('should be able to check physical equality', {
        var derived =  UHaxeDerived1.create();
        (derived.getSelf() == null).should.be(false);
        (derived.getSelf() == derived.getSelf()).should.be(true);
      });
      it('should be able to check structural equality', {
        //This just checks pointers for uobjects
        var derived =  UHaxeDerived1.create();
        (derived.getSelf() == null).should.be(false);
        (derived.getSelf() == derived.getSelf()).should.be(true);
      });
      it('should be able to return itself even if typed as a subclass', {
        var derived =  UHaxeDerived1.create();
        Std.is(derived, UHaxeDerived1).should.be(true);
        Std.is(derived.getSelf(), UHaxeDerived1).should.be(true);
        (derived.getSelf() == derived).should.be(true);
      });
      it('should be able to call StaticClass', {
        UHaxeDerived1.StaticClass().should.not.be(null);
        UHaxeDerived1.StaticClass().GetName().toString().should.be('HaxeDerived1');
        UHaxeDerived2.StaticClass().should.not.be(null);
        UHaxeDerived2.StaticClass().GetName().toString().should.be('HaxeDerived2');
        UHaxeDerived3.StaticClass().should.not.be(null);
        UHaxeDerived3.StaticClass().GetName().toString().should.be('HaxeDerived3');
#if (pass >= 2)
        UHaxeDerived4.StaticClass().GetName().toString().should.be('HaxeDerived4');
        UHaxeDerived5.StaticClass().GetName().toString().should.be('HaxeDerived5');

        UHaxeDynamicClass1.StaticClass().GetName().toString().should.be('HaxeDynamicClass1');
        UHaxeDynamicClass2.StaticClass().GetName().toString().should.be('HaxeDynamicClass2');
        UHaxeDynamicClass3.StaticClass().GetName().toString().should.be('HaxeDynamicClass3');
        UHaxeDynamicClass4.StaticClass().GetName().toString().should.be('HaxeDynamicClass4');
#end
      });

#if (pass >= 2)
      it('should be able to create dynamic classes', {
        function testDynamicClass(obj:UHaxeDynamicClass1, name:String) {
          obj.nonUPropInt64.should.be(0);
          obj.nonUPropInt64 = 0x42424242;
          obj.nonUPropInt64.should.be(0x42424242);
          obj.setProps("obj-str2", 0xF0F1F2F3, 0x1B2B3B4).toString().should.be("setProps obj-str2");
          obj.str.toString().should.be("obj-str2");
          obj.i32.should.be(0xF0F1F2F3);
          obj.ui32.should.be(0x1B2B3B4);

          TestHelper.reflectCall(obj.setProps("obj-str3", 0xA0A1A2A3, 0x1C2C3C4)).toString().should.be("setProps obj-str3");
          obj.str.toString().should.be("obj-str3");
          obj.i32.should.be(0xA0A1A2A3);
          obj.ui32.should.be(0x1C2C3C4);

          obj.str = "obj-str";
          obj.i32 = 0xF00B45;
          obj.ui32 = 0x00DF00D;
          obj.str.toString().should.be('obj-str');
          obj.i32.should.be(0xF00B45);
          obj.ui32.should.be(0x00DF00D);
          obj.getSelf().should.be(obj);

          obj.getName().toString().should.be(name);
          obj.getSelf().getName().toString().should.be(name);
          TestHelper.reflectCall(obj.getName()).toString().should.be(name);
          TestHelper.reflectCall(TestHelper.reflectCall(obj.getSelf()).getName()).toString().should.be(name);
        }

        var obj1 = UHaxeDynamicClass1.create();
        testDynamicClass(obj1, "Dynamic1");

        var obj2 = UHaxeDynamicClass2.create();
#if (pass >= 4)
        obj2.test.toString().should.be("test");
#end
        obj2.str.toString().should.be("UHaxeDynamicClass2");
        obj2.i32_2.should.be(0);
        obj2.someStruct.i32.should.be(0);
        testDynamicClass(obj2, "Dynamic2");
#if (pass >= 4)
        obj2.test = "test2";
        obj2.test.toString().should.be("test2");
#end
        obj2.i32_2.should.be(10);
        obj2.someStruct.i32.should.be(0);
        obj2.someStruct.ui32.should.be(0);
        obj2.someStruct.f.should.be(0);
        obj2.someStruct.d.should.be(0);
        obj2.i32_2 = 0x606060;
        obj2.i32_2.should.be(0x606060);

        var obj3 = UHaxeDynamicClass3.create();
#if (pass >= 4)
        obj3.test.toString().should.be("test");
#end
        obj3.str.toString().should.be("UHaxeDynamicClass3");
        obj3.i32_2.should.be(0);
#if (pass >= 3)
        obj3.i32_3.should.be(0);
#end
        obj3.someStruct.i32.should.be(0);
        testDynamicClass(obj3, "Dynamic3");
#if (pass >= 4)
        obj3.test = "test2";
        obj3.test.toString().should.be("test2");
#end
        obj3.otherStr.toString().should.be('getSelf()');
        obj3.i32_2.should.be(10);
        obj3.someStruct.i32.should.be(0);
        obj3.someStruct.ui32.should.be(0);
        obj3.someStruct.f.should.be(0);
        obj3.someStruct.d.should.be(0);
        obj3.i32_2 = 0x606060;
        obj3.i32_2.should.be(0x606060);
#if (pass >= 3)
        obj3.i32_3 = 0x060606;
        obj3.i32_3.should.be(0x060606);
#end

        var obj4 = UHaxeDynamicClass4.create();
#if (pass >= 4)
        obj4.test.toString().should.be("test");
#end
        obj4.str.toString().should.be("UHaxeDynamicClass4");
        obj4.otherStr2.toString().should.be("Test");
        obj4.i32_2.should.be(0);
#if (pass >= 3)
        obj4.i32_3.should.be(0);
#end
        obj4.someStruct.i32.should.be(0);
        testDynamicClass(obj4, "Dynamic4");
#if (pass >= 4)
        obj4.test = "test2";
        obj4.test.toString().should.be("test2");
#end
        obj4.otherStr2.toString().should.be("getSelf2()");
        obj4.otherStr.toString().should.be('getSelf()');
        obj4.i32_2.should.be(10);
        obj4.someStruct.i32.should.be(0);
        obj4.someStruct.ui32.should.be(0);
        obj4.someStruct.f.should.be(0);
        obj4.someStruct.d.should.be(0);
        obj4.i32_2 = 0x606060;
        obj4.i32_2.should.be(0x606060);
#if (pass >= 3)
        obj4.i32_3 = 0x060606;
        obj4.i32_3.should.be(0x060606);
#end
      });
#end

      it('should be released when UObject is garbage collected');
      it('should be able to access super protected fields');

      it('should be able to define new BlueprintNativeEvent');
      it('should be able to use pointers to basic types');
      it('should be able to use structs');
      it('should be able to use pointers to structs');
      it('should be able to be referenced by weak pointer');
      it('should be able to be serialized and unserialized back', {
        var derived =  UHaxeDerived1.create();
        derived.i32Prop = 0xF00;
        derived.intProp = 0xBA5;
        derived.subclassArray.Push(UHaxeDerived2.StaticClass());
        derived.fname = 'Serialization works!';
        derived.subclassArray.length.should.be(1);
        derived.subclassArray[0].should.be(UHaxeDerived2.StaticClass());
        var d2:UHaxeDerived1 = cast UObject.StaticDuplicateObject(derived, UObject.GetTransientPackage(), 'None');
        d2.should.not.be(derived);
        d2.i32Prop.should.be(0xF00);
        d2.intProp.should.be(0xBA5);
        d2.subclassArray.length.should.be(1);
        d2.subclassArray[0].should.be(UHaxeDerived2.StaticClass());
        d2.fname.toString().should.be('Serialization works!');
        d2.uFunction5().toString().should.be('Serialization works!');
        d2.getSomeNumber().should.be(0xF00 * 10);
        d2.nonNative(25).should.be(35);
        d2.intProp = 10;
#if (pass >= 3)
        d2.uFunction1(10,true).should.be(20);
        TestHelper.reflectCall(d2.uFunction1(10,true)).should.be(20);
        d2.uFunction1(10,false).should.be(10);
        TestHelper.reflectCall(d2.uFunction1(10,false)).should.be(10);
#else
        d2.uFunction1().should.be(42);
        TestHelper.reflectCall(d2.uFunction1()).should.be(42);
#end
        derived.intProp.should.be(0xBA5);
      });
    });
  }
}

#if (cppia || WITH_CPPIA)
// because of a cppia dynamic uproperties limitation, we have to define a class that implements native interface with the
// @:upropertyExpose meta tag
@:uclass
@:upropertyExpose
class UHaxeDerived0 extends UBasicTypesSub1 implements IBasicType2 {
  public function doSomething():IBasicType2 {
    return null;
  }

  public function getSubName():unreal.FString {
    return "UHaxeDerived0";
  }

  public function getSomeInt():Int {
    return 0xf0f0;
  }
}
#end

@:uclass(BlueprintType)
class UHaxeDerived1 extends #if (cppia || WITH_CPPIA) UHaxeDerived0 #else UBasicTypesSub1 #end {
  public static function create():UHaxeDerived1 {
    var ret = UObject.NewObject(new TypeParam<UHaxeDerived1>());
    return ret;
  }

  public var otherInt:Int32;

#if (pass >= 4)
  @:uproperty
  @:uname('someFName') public var fname:unreal.FString;
#else
  @:uproperty
  @:uname('someFName') public var fname:unreal.FName;
#end

  @:uproperty
  @:uname('protectedFName') private var protectedFName:unreal.FName;

  @:uproperty
  public var intProp:unreal.Int32;

  @:uproperty
  public var subclassArray:unreal.TArray<unreal.TSubclassOf<UHaxeDerived2>>;

  // non-exposed Haxe types - tested by TestReflect
  public var haxeType:{ i32:Int, d64:Float, arr:Array<Int>, arr2:Array<{ x:Int, y:Float }> };
  public var someString:String;
  public var someArray:Array<{ x:Int, y:Float }>;

  override public function getSomeNumber():Int {
    return this.i32Prop * 10;
  }

  public function nonNative(i:Int):Int {
    return i + 10;
  }

  @:ufunction
  public function returnsItself():UHaxeDerived1 {
    return this;
  }

#if (pass >= 3)
  @:ufunction(BlueprintCallable, Category=Test)
  public function uFunction1(i:Int, b:Bool):Int {
    return b ? i * 2 : i;
  }
#else
  @:ufunction(BlueprintCallable, Category=Test)
  public function uFunction1():Int {
    return 42;
  }
#end

  @:ufunction(BlueprintCallable, Category=Testing)
  @:uname('uFunctionNameChanged') public function uFunction2():Int {
    return 442;
  }

  @:ufunction(BlueprintImplementableEvent, BlueprintAuthorityOnly)
  public function uFunction3(delta:Float32):Void;

  @:ufunction(BlueprintImplementableEvent, BlueprintAuthorityOnly)
  @:uname('uFunctionNameChanged2') public function uFunction3_1(delta:Float32):Void;

  @:ufunction(BlueprintNativeEvent)
  public function uFunction4():Void;

  public function uFunction4_Implementation() {
    this.otherInt = 10;
  }

#if (pass >= 4)
  @:ufunction
  public function uFunction5():unreal.FString {
    return fname;
  }
#else
  @:ufunction
  public function uFunction5():unreal.FName {
    return fname;
  }
#end

  @:uproperty
  private var ttest:Bool;

  @:uproperty
  var ttest2:Bool;

  @:ufunction(BlueprintImplementableEvent)
  public function TestFName(i32:unreal.Int32, fname:unreal.FName) : Void;
  @:ufunction(BlueprintImplementableEvent)
  public function TestFText(i32:unreal.Int32, someText:unreal.Const<unreal.PRef<unreal.FText>>) : Void;
}

@:uclass(BlueprintType)
class UHaxeDerived2 extends UHaxeDerived1 #if !(cppia || WITH_CPPIA) implements IBasicType2 #end {
  public static function create():UHaxeDerived2 {
    var ret = UObject.NewObject(new TypeParam<UHaxeDerived2>());
    return ret;
  }
  public var myEnum:SomeEnum.EMyEnum;
  public var myCppEnum:SomeEnum.EMyCppEnum;
  public var myNamespacedEnum:SomeEnum.EMyNamespacedEnum;

  override public function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool
  {
    return !super.setUI64_I64_Float_Double(ui64, i64 + 42, f, d);
  }

  override public function nonNative(i:Int):Int {
    return super.nonNative(i) + 100;
  }

  #if (cppia || WITH_CPPIA) override #end public function doSomething():IBasicType2 {
    return this;
  }

  #if (cppia || WITH_CPPIA) override #end public function getSubName():unreal.FString {
    return "HaxeDerived2";
  }

  #if (cppia || WITH_CPPIA) override #end public function getSomeInt():Int {
    return 0xf00ba5;
  }

  override public function uFunction4_Implementation() {
    this.otherInt = 25;
  }
}

@:uclass(BlueprintType)
class UHaxeDerived3 extends UHaxeDerived2 {
  public static function create():UHaxeDerived3 {
    var ret = UObject.NewObject(new TypeParam<UHaxeDerived3>());
    return ret;
  }

  @:uexpose
  public static var someObj:TWeakObjectPtr<UHaxeDerived3>;

  @:ufunction
  public static function testStatic() : Void {
  }

  override public function setText(txt:unreal.FText):unreal.Int64 {
    TestHelper.reflectCallPass2(this.setBool_String_UI8_I8(true,txt.toString(),100,101));
    this.textProp = this.test();
    return unreal.Int64Helpers.make(0x0111,0xF0FA);
  }

  override public function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool
  {
    return !super.setUI64_I64_Float_Double(ui64 + 10, i64, f, d);
  }

  override public function nonNative(i:Int):Int {
    return super.nonNative(i) + 200;
  }

  override public function getSubName():FString {
    return "HaxeDerived3";
  }

  private function test() {
    return "test()";
  }
}

@:uclass
class AHaxeTestActorReplication extends AActor {
  @:uproperty @:ureplicate
  public var replicatedPropA:unreal.Int32;

  @:uproperty(Transient) @:ureplicate(OwnerOnly)
  public var replicatedPropB:unreal.Int32;

  @:uproperty @:ureplicate(customRepFunction)
  public var replicatedPropC:unreal.Int32;

  public function customRepFunction() : Bool {
    return true;
  }

  @:ufunction
  function onRep_replicatedPropA() : Void {
  }

  @:ufunction
  function onRep_replicatedPropB(i:unreal.Int32) : Void {
  }
}

#if (pass >= 2)
@:uclass
class UHaxeDerived4 extends UHaxeDerived3 {
  @:uname("newProp") @:uproperty
  public var newProperty:FString;

  @:uproperty
  public var otherProp:Int64;

  @:uproperty
  public var otherProp2:Int64;

  public var notAProp:String;

  public function new(wrapped) {
    super(wrapped);
    this.newProperty = "Dynamic load ok";
  }
  public static function create():UHaxeDerived4 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDerived4.StaticClass(), "", 0);
    return cast ret;
  }

  override public function setText(txt:unreal.FText):unreal.Int64 {
    TestHelper.reflectCallPass2(this.setBool_String_UI8_I8(true,txt.toString(),100,101));
    this.textProp = this.test();
    return unreal.Int64Helpers.make(0x0111,0xF0F0);
  }

  override public function getSubName():FString {
    return "HaxeDerived4";
  }

  override private function test() {
    return "test2()";
  }
}

@:uclass
class UHaxeDerived5 extends UHaxeDerived4 {
#if (pass >= 3)
  @:uproperty public var theStr:FString;
#else
  @:uproperty public var theStr:FName;
#end
  public function new(wrapped) {
    super(wrapped);
    this.theStr = "the str";
  }

  public static function create():UHaxeDerived5 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDerived5.StaticClass(), "", 0);
    return cast ret;
  }

  override public function getSubName():FString {
    return "HaxeDerived5";
  }

  override private function test() {
    return "test3()";
  }
}

@:uclass
class AHaxeTestActorReplication2 extends AActor {
  @:uproperty @:ureplicate
  public var replicatedPropA:unreal.Int32;

  @:uproperty(Transient) @:ureplicate(OwnerOnly)
  public var replicatedPropB:unreal.Int32;

  @:uproperty @:ureplicate(customRepFunction)
  public var replicatedPropC:unreal.Int32;

  public function customRepFunction() : Bool {
    return true;
  }

  @:ufunction
  function onRep_replicatedPropA() : Void {
  }

  @:ufunction
  function onRep_replicatedPropB(i:unreal.Int32) : Void {
  }
}

@:uclass
class UHaxeDynamicClass1 extends UObject {
  @:uproperty
  public var str:FString;

  @:uproperty
  public var i32:Int32;

  @:uproperty
  public var ui32:UInt32;

  public var nonUPropInt64:Int64;

  public function new(wrapped) {
    super(wrapped);
    this.str = "UHaxeDynamicClass1";
  }

  @:ufunction public function getSelf():UHaxeDynamicClass1 {
    return this;
  }

  @:ufunction public function getName():FString {
    return "Dynamic1";
  }

  @:ufunction public function setProps(str:FString, i32:Int32, ui32:UInt32):FString {
    this.str = str;
    this.i32 = i32;
    this.ui32 = ui32;
    return "setProps " + str;
  }

  public static function create():UHaxeDynamicClass1 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDynamicClass1.StaticClass(), "", 0);
    return cast ret;
  }
}

@:uclass
class UHaxeDynamicClass2 extends UHaxeDynamicClass1 {
#if (pass >= 4)
  @:uproperty
  public var test:FString;
#end

  @:uproperty public var i32_2:Int32;

  @:uproperty public var someStruct:FPODStruct;

  public function new(wrapped) {
    super(wrapped);
    this.str = "UHaxeDynamicClass2";
#if (pass >= 4)
    this.test = "test";
#end
  }

  override public function getName():FString {
    return "Dynamic2";
  }

  public static function create():UHaxeDynamicClass2 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDynamicClass2.StaticClass(), "", 0);
    return cast ret;
  }

  override public function getSelf():UHaxeDynamicClass2 {
    i32_2 = 10;
    return this;
  }
}

@:uclass
class UHaxeDynamicClass3 extends UHaxeDynamicClass2 {
#if (pass >= 3)
  @:uproperty
  public var otherStr:FString;

  @:uproperty
  public var i32_3:Int32;
#else
  @:uproperty
  public var otherStr:FName;
#end

  public function new(wrapped) {
    super(wrapped);
    this.str = "UHaxeDynamicClass3";
  }

  override public function getName():FString {
    return "Dynamic3";
  }

  public static function create():UHaxeDynamicClass3 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDynamicClass3.StaticClass(), "", 0);
    return cast ret;
  }

  override public function getSelf():UHaxeDynamicClass3 {
    otherStr = "getSelf()";
    return cast super.getSelf();
  }
}

@:uclass
class UHaxeDynamicClass4 extends UHaxeDynamicClass3 {
  @:uproperty public var otherStr2:FString;

  public function new(wrapped) {
    super(wrapped);
    this.str = "UHaxeDynamicClass4";
    this.otherStr2 = "Test";
  }

  override public function getName():FString {
    return "Dynamic4";
  }

  public static function create():UHaxeDynamicClass4 {
    var ret = UObject.NewObject_NoTemplate(UObject.GetTransientPackage(), UHaxeDynamicClass4.StaticClass(), "", 0);
    return cast ret;
  }

  override public function getSelf():UHaxeDynamicClass4 {
    otherStr2 = "getSelf2()";
    return cast super.getSelf();
  }
}
#end
