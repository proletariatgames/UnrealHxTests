package cases;
import unreal.*;
import haxeunittests.*;
using buddy.Should;
import NonUObject;

class TestUnrealInteraction extends buddy.BuddySuite {
  public function new(worldCtx:AActor) {
    describe('haxe: blueprint interaction', {
      it('should be able to interact with blueprint', {
        var cls:UClass = getObjectClass("/Game/Blueprints/BlueprintHaxeClass");
        cls.should.not.be(null);
        var obj:UBPTest = UObject.NewObject(null, UObject.GetTransientPackage(), cls);
        var ret = obj.runBlueprints("Unreal.hx test");
        obj.stringSet.should.be("Unreal.hx test");
        obj.theInt.should.be(42);
        ret.should.be(4200);

        var out1 = new FText('');
        var out2:Ref<Int> = Ref.createStack();
        var ret2 = obj.runBlueprints2(out1, out2);
        out1.toString().should.be('BP 42');
        out2.get().should.be(44 - 3);
        ret2.toString().should.be('BP 42 returned');
      });
      it('should be able to interact with a c++-base blueprint', {
        var staticExtern:ACppStaticExtern = cast UObject.StaticFindObjectFast(ACppStaticExtern.StaticClass(), worldCtx.GetOuter(), "TheStaticCpp", false, false, 0);
        staticExtern.runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
      });
#if (pass >= 2)
      it('should be able to interact with a c++-base blueprint through cppia', {
        var staticExtern:ACppDynamicExtern = cast UObject.StaticFindObjectFast(ACppDynamicExtern.StaticClass(), worldCtx.GetOuter(), "TheDynamicCpp", false, false, 0);
        staticExtern.runBlueprints("Hey").should.be(42 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.runBlueprints2(ret).should.be(42);
        ret.toString().should.be('theString');
        ACppDynamicExtern.getStringSize(ret).should.be('theString'.length);
      });
#end
      it('should be able to use TSoftObjectPtr and SoftClassPtr', {
        var cls:UClass = getObjectClass("/Game/Blueprints/BlueprintHaxeClass");
        cls.should.not.be(null);
        var obj:UBPTest = UObject.NewObject(null, UObject.GetTransientPackage(), cls);

        var bpTest:UBPTest = UObject.NewObject(null, UObject.GetTransientPackage(), UBPTest.StaticClass());
        bpTest.softObj.Get().should.be(null);
        bpTest.softObj2.Get().should.be(null);
        bpTest.softCls.Get().should.be(null);
        bpTest.softCls2.Get().should.be(null);

        bpTest.softObj.Set(bpTest);
        bpTest.softObj.Get().should.be(bpTest);
        // trace(bpTest.softObj.Get());
        // Sys.println(bpTest.softObj.Get());
        bpTest.softObj2 = bpTest.softObj;
        bpTest.softObj.Get().should.be(bpTest);
        bpTest.softObj2.Get().should.be(bpTest);

        bpTest.softCls.Set(cls);
        bpTest.softCls2 = bpTest.softCls;
        bpTest.softCls.Get().should.be(cls);
        bpTest.softCls2.Get().should.be(cls);
      });
      it('should be able to override C++ blueprint functions', {
        var staticExtern:UCppStaticExternObject = UObject.NewObject(null, UObject.GetTransientPackage(), types.UBPOverrideTest.StaticClass());
        staticExtern.run_runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.run_runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.run_runBlueprints3(ret).should.be(staticExtern.theString.length + 10);
        ret.toString().should.be('theString_Implementation from Haxe');
        var staticExtern:UCppStaticExternObject = UObject.NewObject(null, UObject.GetTransientPackage(), types.UBPOverrideTest.UBPOverrideTest_Child.StaticClass());
        staticExtern.run_runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.run_runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.run_runBlueprints3(ret).should.be(staticExtern.theString.length + 25);
        ret.toString().should.be('theString_Implementation from Haxe from Haxe');
        var staticExtern:UCppStaticExternObject = UObject.NewObject(null, UObject.GetTransientPackage(), UBPOverrideTest2.StaticClass());
        staticExtern.run_runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.run_runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.run_runBlueprints3(ret).should.be(staticExtern.theString.length + 10);
        ret.toString().should.be('theString_Implementation from Haxe');
        var staticExtern:UCppStaticExternObject = UObject.NewObject(null, UObject.GetTransientPackage(), UBPOverrideTest2_Child.StaticClass());
        staticExtern.run_runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.run_runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.run_runBlueprints3(ret).should.be(staticExtern.theString.length + 25);
        ret.toString().should.be('theString_Implementation from Haxe from Haxe');
        var staticExtern:UBPTest = UObject.NewObject(null, UObject.GetTransientPackage(), UBPOverrideTest4.StaticClass());
        staticExtern.runBlueprints("Hey").should.be(4300);
        staticExtern.theString = "theString";
        var out1:FText = new FText("");
        var out2:Ref<Int> = Ref.createStack();
        staticExtern.runBlueprints2(out1,out2).toString().should.be("43");
        out1.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.runBlueprints3(ret).should.be(staticExtern.theString.length + 10);
        ret.toString().should.be('theString_Implementation from Haxe');
        var ret:FString = "";
        ( ReflectAPI.callMethod(staticExtern, 'runBlueprints3', [ret]) : Int).should.be(staticExtern.theString.length + 10);
        ret.toString().should.be('theString_Implementation from Haxe');
        var staticExtern:UBPTest = UObject.NewObject(null, UObject.GetTransientPackage(), UBPOverrideTest4_Child.StaticClass());
        staticExtern.runBlueprints("Hey").should.be(4300);
        staticExtern.theString = "theString";
        var out1:FText = new FText("");
        staticExtern.runBlueprints2(out1,out2).toString().should.be("43");
        out1.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.runBlueprints3(ret).should.be(staticExtern.theString.length + 25);
        ret.toString().should.be('theString_Implementation from Haxe from Haxe');
        var ret:FString = "";
        ( ReflectAPI.callMethod(staticExtern, 'runBlueprints3', [ret]) : Int).should.be(staticExtern.theString.length + 25);
        ret.toString().should.be('theString_Implementation from Haxe from Haxe');
        #if (pass >= 3)
        var staticExtern:UCppStaticExternObject = UObject.NewObject(null, UObject.GetTransientPackage(), UBPOverrideTest3.StaticClass());
        staticExtern.run_runBlueprints("Hey").should.be(43 * 3);
        staticExtern.theString = "theString";
        var ret:FString = "";
        staticExtern.run_runBlueprints2(ret).should.be(43);
        ret.toString().should.be('theString');
        var ret:FString = "";
        staticExtern.run_runBlueprints3(ret).should.be(220);
        ret.toString().should.be('from Haxe');
        #end
      });
    });
  }

  public static function getObjectClass(path:String):UClass {
    // make sure that the package is loaded already
    var pack = UObject.FindPackage(null, path);
    if (pack == null) {
      pack = UObject.LoadPackage(null, path, 0);
    }
    if (pack == null) {
      trace('Warning', 'Package for path $path could not be loaded!');
    } else {
      pack.FullyLoad();

      var arr = TArray.create(new TypeParam<UObject>());
      UObject.GetObjectsWithOuter(pack, arr, true, RF_NoFlags);
      for (val in arr) {
        if (Std.is(val, UBlueprint)) {
          return (cast val : UBlueprint).GeneratedClass;
        } else if (Std.is(val, UClass)) {
          return cast val;
        }
      }
    }

    var obj = UObject.LoadObject(new TypeParam<UBlueprint>(), null, path);
    if (obj == null) {
      trace('Warning', 'The blueprint path $path does not exist!');
      return null;
    }
    return obj.GeneratedClass;
  }
}

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest2 extends UCppStaticExternObject {
  override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
    return this.runCppFunction(43, str);
  }

  override public function runBlueprints2(str : unreal.PRef<unreal.FString>) : unreal.Int32 {
    str.assign(this.theString);
    return 43;
  }

  override public function runBlueprints3(str : unreal.PRef<unreal.FString>) : Int {
    var ret = super.runBlueprints3(str);
    str.assign(new FString(str.toString() + ' from Haxe'));
    return ret + 10;
  }
}

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest2_Child extends UBPOverrideTest2 {
  override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
    return this.runCppFunction(43, str);
  }

  override public function runBlueprints2(str : unreal.PRef<unreal.FString>) : unreal.Int32 {
    str.assign(this.theString);
    return 43;
  }

  override public function runBlueprints3(str : unreal.PRef<unreal.FString>) : Int {
    var ret = super.runBlueprints3(str);
    str.assign(new FString(str.toString() + ' from Haxe'));
    return ret + 15;
  }
}

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest3 extends UCppStaticExternObject {
#if (pass >= 2)
  override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
    return this.runCppFunction(43, str);
  }

  override public function runBlueprints2(str : unreal.PRef<unreal.FString>) : unreal.Int32 {
    str.assign(this.theString);
    return 43;
  }

  override public function runBlueprints3(str : unreal.PRef<unreal.FString>) : Int {
    str.assign(new FString('from Haxe'));
    return 220;
  }
#end
}

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest4 extends UBPTest {
  override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
    return this.runHaxeFunction(43, str);
  }

  override public function runBlueprints2(str : unreal.PRef<unreal.FText>, i:Ref<Int>) : FString {
    str.assign(FText.FromString(this.theString));
    return "43";
  }

  override public function runBlueprints3_Implementation(str : unreal.PRef<unreal.FString>) : Int {
    var ret = super.runBlueprints3_Implementation(str);
    str.assign(new FString(str.toString() + ' from Haxe'));
    return ret + 10;
  }
}

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest4_Child extends UBPOverrideTest4 {
  override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
    return this.runHaxeFunction(43, str);
  }

  override public function runBlueprints2(str : unreal.PRef<unreal.FText>, i:Ref<Int>) : FString {
    str.assign(FText.FromString(this.theString));
    return "43";
  }

  override public function runBlueprints3_Implementation(str : unreal.PRef<unreal.FString>) : Int {
    var ret = super.runBlueprints3_Implementation(str);
    str.assign(new FString(str.toString() + ' from Haxe'));
    return ret + 15;
  }
}

@:uclass(Blueprintable, Category="Cppia")
class UBPTest extends UObject {
  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var theString:FString;

  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var softObj:TSoftObjectPtr<UBPTest>;

  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var softObj2:TSoftObjectPtr<UBPTest>;

  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var softCls:TSoftClassPtr<UBPTest>;

  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var softCls2:TSoftClassPtr<UBPTest>;

  public var theInt:Int;

  public var stringSet:String;

  @:ufunction(BlueprintImplementableEvent, Category="Cppia")
  public function runBlueprints(str:Const<PRef<FString>>):Int;

  @:ufunction(BlueprintCallable, Category="Cppia")
  public function runHaxeFunction(i:Int, str:Const<PRef<FString>>):Int {
    this.stringSet = str.toString();
    theInt = i;
    return theInt * 100;
  }

  @:ufunction(BlueprintImplementableEvent, Category="Cppia")
  public function runBlueprints2(str:PRef<FText>, i:Ref<Int>):FString;

  @:ufunction(BlueprintCallable, Category="Cppia")
  public function runHaxeFunction2(str:PRef<FText>, i:Ref<Int>, arr:Const<PRef<TArray<FPODStruct>>>):Int {
    str.assign(new FText(arr[0].i32 + ''));
    i.set(arr[1].i32);
    return arr.length;
  }

  @:ufunction(BlueprintNativeEvent, Category="Cppia")
  public function runBlueprints3(str:PRef<FString>):Int;

  function runBlueprints3_Implementation(str:PRef<FString>):Int {
    var len = theString.length;
    str.assign(new FString(theString.toString() + "_Implementation"));
    return len;
  }

#if (UE_VER >= 4.17)
  @:uproperty(Category="Cppia", EditAnywhere, BlueprintGetter=getPropCall, BlueprintSetter=setPropCall)
  public var prop:FString;

  @:ufunction
  public function getPropCall():FString {
    return prop;
  }

  @:ufunction
  public function setPropCall(str:FString):Void {
    this.prop = str;
  }
#end
}