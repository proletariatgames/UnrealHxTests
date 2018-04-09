package haxeunittests;
import unreal.*;

extern class UBasicTypesUObject_Extra {
  var boolNonProp:Bool;
  var stringNonProp:unreal.FString;
  var textNonProp:unreal.FText;
  var ui8NonProp:unreal.UInt8;
  var i8NonProp:unreal.Int8;
  var ui16NonProp:unreal.UInt16;
  var i16NonProp:unreal.Int16;
  var ui32NonProp:unreal.FakeUInt32;
  var i32NonProp:unreal.Int32;
  var ui64NonProp:unreal.FakeUInt64;
  var i64NonProp:unreal.Int64;
  var floatNonProp:unreal.Float32;
  var doubleNonProp:unreal.Float64;

  static function CreateFromCpp():UBasicTypesUObject;

  @:final function setUI16_I16_UI32_I32(ui16:unreal.UInt16, i16:unreal.Int16, ui32:unreal.FakeUInt32, i32:unreal.Int32):Void;
  function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool;

  @:thisConst function getSomeNumber():Int;

  public static function isNull(obj:UBasicTypesUObject) : Bool;
  public static function getNull() : UBasicTypesUObject;

  public function getSelf() : UBasicTypesUObject;

  @:thisConst
  public function testConstParam(geo:unreal.Const<unreal.PRef<unreal.slatecore.FGeometry>>) : unreal.FString;

  private var m_i32:unreal.Int32;

  private function nonUFUNCTION_setBool_String_UI8_I8_protected(b:Bool, str:unreal.FString, ui8:unreal.UInt8, i8:unreal.Int8) : Void;

  // Protected member externs
  @:ufunction()
  @:thisConst
  private function testConstParam_protected(geo:unreal.Const<unreal.PRef<unreal.slatecore.FGeometry>>) : unreal.FString;

  public function testRefInt(refInt:Ref<Int>):Void;
  public function testRefEnum(refEnum:Ref<EMyCppEnum>):Void;
  public function testRefObject(refObj:Ref<UBasicTypesUObject>):Int;
  public function testRefVector(refVec:Ref<PPtr<FVector>>):Void;
}
