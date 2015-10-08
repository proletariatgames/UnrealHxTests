package cases;
using buddy.Should;
import UBasicTypesSub;

class TestUObjectOverrides extends buddy.BuddySuite {
  public function new() {
    describe('Haxe: uobjects overrides', {
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
      it('should be able to use pointers to basic types');
      it('should be able to use structs');
      it('should be able to use pointers to structs');
      it('should be able to be referenced by weak pointer');
    });
  }
}

@:uclass
class UHaxeDerived1 extends UBasicTypesSub1 {
  @:uproperty
  public var fname:unreal.PStruct<unreal.FName>;

  override public function getSomeNumber():Int {
    return this.i32Prop;
  }

  public function nonNative(i:Int):Int {
    return i + 10;
  }

  @:ufunction
  public function uFunction1():Int {
    return 42;
  }

  @:ufunction(BlueprintCallable, Category=Testing)
  public function uFunction2():Int {
    return 442;
  }

  @:ufunction(BlueprintImplementableEvent)
  public function uFunction3():Void;

  @:ufunction(BlueprintNativeEvent)
  public function uFunction4():Void {
  }
}

// just make sure this will compile
@:keep class NonUClass extends UHaxeDerived1 {
  public var other:UHaxeDerived1;

  override public function getSomeNumber():Int {
    return super.getSomeNumber() + 10;
  }
}

@:uclass
class UHaxeDerived2 extends UHaxeDerived1 {
  override public function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool
  {
    return !super.setUI64_I64_Float_Double(ui64, i64 + 42, f, d);
  }

  override public function nonNative(i:Int):Int {
    return super.nonNative(i) + 100;
  }
}

@:uclass
class UHaxeDerived3 extends UHaxeDerived2 {
  override public function setText(txt:unreal.FText):unreal.Int64 {
    this.setBool_String_UI8_I8(true,txt,100,101);
    this.textProp = this.test();
    return unreal.Int64.make(0x0111,0xF0FA);
  }

  override public function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool
  {
    return !super.setUI64_I64_Float_Double(ui64 + 10, i64, f, d);
  }

  override public function nonNative(i:Int):Int {
    return super.nonNative(i) + 100;
  }

  private function test() {
    return "test()";
  }
}

// @:uclass
// @:umodule('HaxeUnitTests')
// class UImplementedAnotherModule extends unreal.UObject {
//   // @:uproperty
//   // public var other:UHaxeDerived1;
// }
