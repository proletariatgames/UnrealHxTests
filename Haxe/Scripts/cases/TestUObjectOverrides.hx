package cases;
import unreal.*;
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
        UHaxeDerived1.StaticClass().GetDesc().toString().should.be('HaxeDerived1');
        UHaxeDerived2.StaticClass().should.not.be(null);
        UHaxeDerived2.StaticClass().GetDesc().toString().should.be('HaxeDerived2');
        UHaxeDerived3.StaticClass().should.not.be(null);
        UHaxeDerived3.StaticClass().GetDesc().toString().should.be('HaxeDerived3');
#if (pass >= 2)
        UHaxeDerived4.StaticClass().GetDesc().toString().should.be('HaxeDerived4');
#end
      });
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
        d2.uFunction1().should.be(42);
        TestHelper.reflectCall(d2.uFunction1()).should.be(42);
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

@:uclass
class UHaxeDerived1 extends #if (cppia || WITH_CPPIA) UHaxeDerived0 #else UBasicTypesSub1 #end {
  public static function create():UHaxeDerived1 {
    var ret = UObject.NewObject(new TypeParam<UHaxeDerived1>());
    return ret;
  }

  public var otherInt:Int32;

#if (pass >= 3)
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

  @:ufunction
  public function uFunction1():Int {
    return 42;
  }

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

#if (pass >= 3)
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

@:uclass
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

@:uclass
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
#end
