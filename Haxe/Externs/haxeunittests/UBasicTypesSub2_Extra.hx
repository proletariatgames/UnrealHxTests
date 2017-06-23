package haxeunittests;
import unreal.*;

extern class UBasicTypesSub2_Extra {
  public var isSub2:Bool;
  static function CreateFromCpp():UBasicTypesSub2;

  function doSomething():IBasicType2;
  function getSubName():unreal.FString;
  function getSomeInt():Int;
}
