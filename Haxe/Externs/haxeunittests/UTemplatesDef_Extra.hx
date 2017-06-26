package haxeunittests;
import unreal.*;

extern class UTemplatesDef_Extra {
  @:typeName static function getSomeStaticInt<T>():Int;
  @:typeName function copyNew<T>(withType:T):POwnedPtr<T>;
}
