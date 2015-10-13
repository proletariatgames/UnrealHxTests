package helpers;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import ue4hx.internal.*;
#end

class TParamHelper {
  macro public static function addInclude() {
    var local = Context.getLocalClass().get();
    var runtime = NativeGlueCode.haxeRuntimeDir + '/Generated/TypeParam.h';
    local.meta.add(':cppInclude', macro $v{runtime}, Context.currentPos() );
  }
}
