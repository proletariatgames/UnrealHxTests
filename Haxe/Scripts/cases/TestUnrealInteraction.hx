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
      });
#end
    //   it('should be able to override C++ blueprint functions', {
    //     var staticExtern:ACppStaticExtern = UObject.NewObject(null, UObject.GetTransientPackage(), ABPOverrideTest.StaticClass());
    //     staticExtern.runBlueprints("Hey").should.be(43 * 3);
    //     staticExtern.theString = "theString";
    //     var ret:FString = "";
    //     staticExtern.runBlueprints2(ret).should.be(43);
    //     ret.toString().should.be('theString');
    //   });
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

// @:uclass(Blueprintable, Category="Cppia")
// class ABPOverrideTest extends ACppStaticExtern {
// // #if (pass > 3)
//   override public function runBlueprints(str : unreal.FString) : unreal.Int32 {
//     return this.runCppFunction(43, str);
//   }

//   override public function runBlueprints2(str : unreal.PRef<unreal.FString>) : unreal.Int32 {
//     str.assign(this.theString);
//     return 43;
//   }
// // #end
// }


@:uclass(Blueprintable, Category="Cppia")
class UBPTest extends UObject {
  @:uproperty(BlueprintReadWrite, Category="Cppia")
  public var theString:FString;

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
    trace('assigning $str to ${arr[0].i32}');
    str.assign(new FText(arr[0].i32 + ''));
    trace('assigning i to ${arr[1].i32}');
    i.set(arr[1].i32);
    return arr.length;
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