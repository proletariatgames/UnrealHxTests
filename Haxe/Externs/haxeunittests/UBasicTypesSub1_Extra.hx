package haxeunittests;
import unreal.*;

extern class UBasicTypesSub1_Extra {
  public var isSub1:Bool;
  static function CreateFromCpp():UBasicTypesSub1;
  function writeToByteArray(arr:ByteArray, loc:Int, what:UInt8):Bool;
  @:ureplace @:ufunction @:final public function enumAsByteTest(actionName : unreal.FName, EventType : unreal.TEnumAsByte<unreal.EInputEvent>) : unreal.Int32;
  @:ureplace @:ufunction @:final private function enumAsByteTestPrivate(actionName : unreal.FName, EventType : unreal.TEnumAsByte<unreal.EInputEvent>) : unreal.Int32;

  function getSomeEnum(i:Int, out:Ref<EMyEnum>):Void;
  function getSomeCppEnum(i:Int, out:Ref<EMyCppEnum>):Void;

  static var SomeObject:UBasicTypesUObject;
}
