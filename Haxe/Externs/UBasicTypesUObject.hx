import unreal.*;

@:umodule("HaxeUnitTests")
@:glueCppIncludes("BasicTypesUObject.h")
@:uextern extern class UBasicTypesUObject extends unreal.UObject {
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

  @:uproperty
  var boolProp:Bool;
  @:uproperty
  var stringProp:unreal.FString;
  @:uproperty
  var textProp:unreal.FText;
  @:uproperty
  var ui8Prop:unreal.UInt8;
  @:uproperty
  var i8Prop:unreal.Int8;
  @:uproperty
  var ui16Prop:unreal.UInt16;
  @:uproperty
  var i16Prop:unreal.Int16;
  @:uproperty
  var ui32Prop:unreal.FakeUInt32;
  @:uproperty
  var i32Prop:unreal.Int32;
  @:uproperty
  var ui64Prop:unreal.FakeUInt64;
  @:uproperty
  var i64Prop:unreal.Int64;
  @:uproperty
  var floatProp:unreal.Float32;
  @:uproperty
  var doubleProp:unreal.Float64;

  static function CreateFromCpp():UBasicTypesUObject;

  @:ufunction
  @:final function getBoolProp():Bool;
  @:ufunction
  @:final function getUi8Prop():unreal.UInt8;
  @:ufunction
  @:final function getI8Prop():unreal.Int8;
  @:final function getUi16Prop():unreal.UInt16;
  @:final function getI16Prop():unreal.Int16;
  @:ufunction
  @:final function getUi32Prop():unreal.FakeUInt32;
  @:ufunction
  @:final function getI32Prop():unreal.Int32;
  @:final function getUi64Prop():unreal.FakeUInt64;
  @:ufunction
  @:final function getI64Prop():unreal.Int64;
  @:ufunction
  @:final function getFloatProp():unreal.Float32;
  @:ufunction
  @:final function getDoubleProp():unreal.Float64;

  @:ufunction
  @:final function setBool_String_UI8_I8(b:Bool, s:unreal.FString, ui8:unreal.UInt8, i8:unreal.Int8):UBasicTypesUObject;
  @:final function setUI16_I16_UI32_I32(ui16:unreal.UInt16, i16:unreal.Int16, ui32:unreal.FakeUInt32, i32:unreal.Int32):Void;
  function setUI64_I64_Float_Double(ui64:unreal.FakeUInt64, i64:unreal.Int64, f:unreal.Float32, d:unreal.Float64):Bool;
  function setText(txt:unreal.FText):unreal.Int64;

  @:thisConst function getSomeNumber():Int;

  public static function isNull(obj:PExternal<UBasicTypesUObject>) : Bool;
  public static function getNull() : PExternal<UBasicTypesUObject>;
}
