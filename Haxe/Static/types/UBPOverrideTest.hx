package types;
import unreal.*;
import haxeunittests.*;

@:uclass(Blueprintable, Category="Cppia")
class UBPOverrideTest extends UCppStaticExternObject {
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
class UBPOverrideTest_Child extends UBPOverrideTest {
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
