@:umodule("HaxeUnitTests")
@:glueCppIncludes("BasicTypesUObject.h")
@:uextern extern class UBasicTypesUObject extends unreal.UObject {
  var boolNonProp:Bool;
  var stringNonProp:unreal.FString;
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
}
