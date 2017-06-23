package haxeunittests;
import unreal.*;

extern class UBasicTypesSub1_Extra {
  public var isSub1:Bool;
  static function CreateFromCpp():UBasicTypesSub1;
  function writeToByteArray(arr:ByteArray, loc:Int, what:UInt8):Bool;
}
