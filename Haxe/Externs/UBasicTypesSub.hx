@:umodule("HaxeUnitTests")
@:glueCppIncludes("BasicTypesSub.h")
@:uextern extern class UBasicTypesSub1 extends UBasicTypesUObject {
  public var isSub1:Bool;
  static function CreateFromCpp():UBasicTypesSub1;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("BasicTypesSub.h")
@:uextern extern class UBasicTypesSub2 extends UBasicTypesUObject {
  public var isSub2:Bool;
  static function CreateFromCpp():UBasicTypesSub2;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("BasicTypesSub.h")
@:uextern extern class UBasicTypesSub3 extends UBasicTypesSub2 {
  public var isSub3:Bool;
  static function CreateFromCpp():UBasicTypesSub3;
}
