package haxeunittests;
import unreal.*;

extern class FSimpleUStruct_Extra {
  var f1:Float32;
  var d1:Float;
  var i32:Int32;
  var ui32:UInt32;

  @:uname(".ctor") static function createWithArgs(f1:Float32, d1:Float, i32:Int32, ui32:UInt32):FSimpleUStruct;
  @:uname(".ctor") static function create():FSimpleUStruct;
  static var nDestructorCalled:Int;
  static var nCopyConstructorCalled:Int;
  static var nConstructorCalled:Int;

}
