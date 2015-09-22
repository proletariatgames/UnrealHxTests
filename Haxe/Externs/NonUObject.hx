import unreal.*;

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FSimpleStruct {
  public static var nDestructorCalled:Int32;

  public var f1:Float32;
  public var d1:Float64;
  public var i32:Int32;
  public var ui32:FakeUInt32;
  public var usedDefaultConstructor:Bool;

  public static function getRef():FSimpleStruct;
  @:uname('new') public static function create():PHaxeCreated<FSimpleStruct>;
  @:uname('new') public static function createWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):PHaxeCreated<FSimpleStruct>;

  @:final public function toString():FString;

  // @:native('()') public static function createStruct():Struct<FSimpleStruct>;
  // @:native('()') public static function createStructWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):Struct<FSimpleStruct>;
}
