package templates;

@:uextern
@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
extern class UTemplatesDef extends unreal.UObject {
  static function getSomeStaticInt<T>():Int;
}
