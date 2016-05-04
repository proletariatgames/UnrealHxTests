package cases;
import unreal.*;
using buddy.Should;
import UBasicTypesSub;

using unreal.CoreAPI;

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
      Int64.eq(obj.i64NonProp, 7 * multiplier).should.be(true);
      Int64.eq(obj.ui64NonProp, 8 * multiplier).should.be(true);
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
        }
        obj1.nonNative(10).should.be(20);
        obj2.nonNative(10).should.be(120);
        obj3.nonNative(10).should.be(320);
        obj2.getSubName().toString().should.be("HaxeDerived2");
        obj3.getSubName().toString().should.be("HaxeDerived3");
        testObj(obj1,1);
        testObj(obj2,2);
        testObj(obj3,3);
      });
      it('should be able to have their functions overridden', {
        var obj1 = UHaxeDerived1.create(),
            obj2 = UHaxeDerived2.create(),
            obj3 = UHaxeDerived3.create();
        Int64.eq(obj1.setText("MyText"), Int64.ofInt(0xD00D)).should.be(true);
        obj1.textNonProp.toString().should.be("MyText");
        obj2.getSomeInt().should.be(0xf00ba5);
        Int64.eq(obj3.setText("MyText"), Int64.make(0x0111,0xF0FA)).should.be(true);
        obj3.boolProp.should.be(true);
        obj3.stringProp.toString().should.be("MyText");
        obj3.ui8Prop.should.be(100);
        obj3.i8Prop.should.be(101);

        obj1.uFunction4();
        obj1.otherInt.should.be(10);
        obj2.uFunction4();
        obj2.otherInt.should.be(25);
      }); // check if native side sees it as well
      it('should be able to check physical equality', {
        var derived =  UHaxeDerived1.create();
        (derived.getSelf() == null).should.be(false);
        (derived.getSelf() == derived.getSelf()).should.be(true);
      });
      it('should be able to check structural equality', {
        //This just checks pointers for uobjects
        var derived =  UHaxeDerived1.create();
        derived.getSelf().equals(null).should.be(false);
        derived.getSelf().equals(derived.getSelf()).should.be(true);
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
        var d2:UHaxeDerived1 = cast UObject.StaticDuplicateObject(derived, UObject.GetTransientPackage(), 'None');
        d2.should.not.be(derived);
        d2.i32Prop.should.be(0xF00);
        d2.intProp.should.be(0xBA5);
        d2.subclassArray.length.should.be(1);
        d2.subclassArray[0].should.be(UHaxeDerived2.StaticClass());
        d2.fname.toString().should.be('Serialization works!');
        d2.getSomeNumber().should.be(0xF00 * 10);
        d2.nonNative(25).should.be(35);
        d2.intProp = 10;
        d2.uFunction1().should.be(42);
        derived.intProp.should.be(0xBA5);
      });
    });
  }
}

@:uclass
class UHaxeDerived1 extends UBasicTypesSub1 {
  public static function create():UHaxeDerived1 {
    var ret = UObject.NewObject(new TypeParam<UHaxeDerived1>());
    return ret;
  }

  public var otherInt:Int32;
  @:uproperty
  @:uname('someFName') public var fname:unreal.FName;

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

  @:ufunction
  public function uFunction5():unreal.FName {
    return fname;
  }

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
class UHaxeDerived2 extends UHaxeDerived1 implements IBasicType2 {
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

  public function doSomething():IBasicType2 {
    return this;
  }

  public function getSubName():unreal.FString {
    return "HaxeDerived2";
  }

  public function getSomeInt():Int {
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
    this.setBool_String_UI8_I8(true,txt.toString(),100,101);
    this.textProp = this.test();
    return unreal.Int64.make(0x0111,0xF0FA);
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
