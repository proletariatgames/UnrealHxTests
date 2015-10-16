package templates;
import unreal.*;

@:uextern
@:glueCppIncludes("TemplatesDef.h")
extern class UTemplatesDef extends unreal.UObject {
  static function getSomeStaticInt<T>():Int;
  function copyNew<T>(withType:PStruct<T>):PHaxeCreated<T>;
}
