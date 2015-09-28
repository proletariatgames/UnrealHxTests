import unreal.*;

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FSimpleStruct {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var f1:Float32;
  public var d1:Float64;
  public var i32:Int32;
  public var ui32:FakeUInt32;
  public var usedDefaultConstructor:Bool;

  public static function getRef():PExternal<FSimpleStruct>;
  @:uname('new') public static function create():PHaxeCreated<FSimpleStruct>;
  @:uname('new') public static function createWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):PHaxeCreated<FSimpleStruct>;

  @:final public function toString():FString;

  static function isI32EqualByVal(self:PStruct<FSimpleStruct>, i:Int32):Bool;
  static function isI32Equal(self:FSimpleStruct, i:Int32):Bool;
  static function isI32EqualShared(self:TSharedPtr<FSimpleStruct>, i:Int32):Bool;
  static function isI32EqualSharedRef(self:TSharedRef<FSimpleStruct>, i:Int32):Bool;
  static function isI32EqualWeak(self:TWeakPtr<FSimpleStruct>, i:Int32):Bool;

  @:final public static function mkShared():TSharedPtr<FSimpleStruct>;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasStructMember1 {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var simple:PStruct<FSimpleStruct>;
  @:uname('new') public static function create():PHaxeCreated<FHasStructMember1>;

  public function isI32Equal(i:Int32):Bool;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasStructMember2 {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var shared:TSharedPtr<FSimpleStruct>;
  @:uname('new') public static function create():PHaxeCreated<FHasStructMember2>;

  public function isI32Equal(i:Int32):Bool;
}
