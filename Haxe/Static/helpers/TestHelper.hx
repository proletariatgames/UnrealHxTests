package helpers;

class TestHelper {
  macro public static function getType(e:haxe.macro.Expr):haxe.macro.Expr {
    return macro $v{haxe.macro.Context.typeof(e) + ""};
  }
}
