import unreal.*;

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FSimpleStruct {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public static function isNull(obj:PPtr<FSimpleStruct>) : Bool;
  public static function getNull() : PPtr<FSimpleStruct>;

  public var f1:Float32;
  public var d1:Float64;
  public var i32:Int32;
  public var ui32:FakeUInt32;
  public var usedDefaultConstructor:Bool;

  public static function getRef():PPtr<FSimpleStruct>;
  @:uname('.ctor') public static function create():FSimpleStruct;
  @:uname('new') public static function createNew():POwnedPtr<FSimpleStruct>;
  @:uname('.ctor') public static function createWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):FSimpleStruct;
  @:uname('new') public static function createNewWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):POwnedPtr<FSimpleStruct>;

  @:final public function ToString():FString;

  static function isI32EqualByVal(self:FSimpleStruct, i:Int32):Bool;
  static function isI32Equal(self:PPtr<FSimpleStruct>, i:Int32):Bool;
  static function isI32EqualShared(self:TSharedPtr<FSimpleStruct>, i:Int32):Bool;
  static function isI32EqualSharedRef(self:TSharedRef<FSimpleStruct>, i:Int32):Bool;
  static function isI32EqualWeak(self:TWeakPtr<FSimpleStruct>, i:Int32):Bool;

  @:final public static function mkShared():TSharedPtr<FSimpleStruct>;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:ustruct
@:uextern @:ustruct extern class FPODStruct {
  public var f:Float32;
  public var d:Float64;
  public var i32:Int32;
  public var ui32:FakeUInt32;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:noCopy
@:uextern extern class FSimpleStructNoEqualsOperator {
  @:uname('.ctor') public static function createWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):FSimpleStructNoEqualsOperator;
  @:uname('new') public static function createNewWithArgs(f1:Float32, d1:Float64, i32:Int32, ui32:FakeUInt32):POwnedPtr<FSimpleStructNoEqualsOperator>;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasStructMember1 {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var simple:FSimpleStruct;
  public var fname:FName;
  public var myEnum:SomeEnum.EMyEnum;
  public var myCppEnum:SomeEnum.EMyCppEnum;
  public var myNamespacedEnum:SomeEnum.EMyNamespacedEnum;

  @:uname('.ctor') public static function create():FHasStructMember1;
  @:uname('new') public static function createNew():POwnedPtr<FHasStructMember1>;

  public function isI32Equal(i:Int32):Bool;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasStructMember2 {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var shared:TSharedPtr<FSimpleStruct>;
  @:uname('.ctor') public static function create():FHasStructMember2;
  @:uname('new') public static function createNew():POwnedPtr<FHasStructMember2>;

  public function isI32Equal(i:Int32):Bool;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasStructMember3 {
  public static var nDestructorCalled:Int32;
  public static var nConstructorCalled:Int32;

  public var simple:FSimpleStruct;
  public var ref:PRef<FSimpleStruct>;
  public var usedDefaultConstructor:Bool;
  @:uname('.ctor') public static function create():FHasStructMember3;
  @:uname('new') public static function createNew():POwnedPtr<FHasStructMember3>;
  @:uname('.ctor') public static function createWithRef(ref:PRef<FSimpleStruct>):FHasStructMember3;
  @:uname('new') public static function createNewWithRef(ref:PRef<FSimpleStruct>):POwnedPtr<FHasStructMember3>;

  public static function setRef(ref:PRef<FSimpleStruct>, to:FSimpleStruct):Void;

  public function isI32Equal(i:Int32):Bool;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FHasPointers {
  // var intptr:cpp.Pointer<Int>;
  // var ptrIntptr:cpp.Pointer<cpp.Pointer<Int>>;
  // var voidptr:cpp.Pointer<Dynamic>; // closest possible :(
  // var floatptr:cpp.Pointer<Float>;
  // var sharedInt:TSharedPtr<Int>;
  // var sharedIntptr:TSharedPtr<cpp.Pointer<Int>>;
  // var intref:PRef<Int>;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FBase extends FSimpleStruct {
  var otherValue:Float32;

  @:uname('.ctor') public static function create():FBase;
  @:uname('new') public static function createNew():POwnedPtr<FBase>;

  public function getSomeInt():Int;
  public static function getOverride():PPtr<FBase>;
}

@:umodule("HaxeUnitTests")
@:glueCppIncludes("NonUObject.h")
@:uextern extern class FOverride extends FBase {
  var yetAnotherValue:Float;

  @:uname('.ctor') public static function create():FOverride;
  @:uname('new') public static function createNew():POwnedPtr<FOverride>;
}
