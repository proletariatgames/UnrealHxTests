@:glueCppIncludes("BasicTypesUObject.h")
@:uextern extern class UBasicTypesUObject extends unreal.UObject {
  var boolNonProp:Bool;
  var stringNonProp:unreal.FString;
  var ui8NonProp:cpp.UInt8;
  var i8NonProp:cpp.Int8;
  var ui16NonProp:cpp.UInt16;
  var i16NonProp:cpp.Int16;
  var ui32NonProp:cpp.UInt32;
  var i32NonProp:cpp.Int32;
  var ui64NonProp:cpp.UInt64;
  var i64NonProp:cpp.Int64;
  var floatNonProp:cpp.Float32;
  var doubleNonProp:cpp.Float64;

  @:uproperty
  var boolProp:Bool;
  @:uproperty
  var ui8Prop:cpp.UInt8;
  @:uproperty
  var i8Prop:cpp.Int8;
  @:uproperty
  var ui16Prop:cpp.UInt16;
  @:uproperty
  var i16Prop:cpp.Int16;
  @:uproperty
  var ui32Prop:cpp.UInt32;
  @:uproperty
  var i32Prop:cpp.Int32;
  @:uproperty
  var ui64Prop:cpp.UInt64;
  @:uproperty
  var i64Prop:cpp.Int64;
  @:uproperty
  var floatProp:cpp.Float32;
  @:uproperty
  var doubleProp:cpp.Float64;

  static function CreateFromCpp():UBasicTypesUObject;
}
