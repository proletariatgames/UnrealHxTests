package helpers;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class TestHelper {
  macro public static function getType(e:haxe.macro.Expr):haxe.macro.Expr {
    return macro $v{haxe.macro.Context.typeof(e) + ""};
  }

  macro public static function reflectCall(e:haxe.macro.Expr):haxe.macro.Expr {
    return reflectCall_pvt(e);
  }

  macro public static function reflectCallPass2(e:haxe.macro.Expr):haxe.macro.Expr {
    if (Context.defined('pass2')) {
      return reflectCall_pvt(e);
    } else {
      return e;
    }
  }
#if macro
  private static function reflectCall_pvt(e:haxe.macro.Expr):haxe.macro.Expr {
    var type = Context.typeof(e).toComplexType();
    switch(e.expr) {
    case ECall({ expr:EField(ef, name) }, args):
      var ret = macro unreal.ReflectAPI.callMethod($ef, $v{name}, $a{args});
      if (type == null) {
        return ret;
      } else {
        return macro ($ret : $type);
      }
    case _:
      throw new Error('reflectCall: Invalid expression', e.pos);
    }
  }
#end
}
