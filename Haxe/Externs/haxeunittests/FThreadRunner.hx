package haxeunittests;
import unreal.*;

@:glueCppIncludes("ThreadRunner.h")
@:uextern extern class FThreadRunner {
  function new(inInit:FSimpleDelegate, inLoop:FSimpleDelegate, inEnd:FSimpleDelegate, inTimes:Int);
  static function start(inInit:FSimpleDelegate, inLoop:FSimpleDelegate, inEnd:FSimpleDelegate, inTimes:Int):Void;
}