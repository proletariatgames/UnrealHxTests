package templates;
import unreal.*;

@:glueCppIncludes("TemplatesDef.h")
@:uextern extern class UTemplatesDef extends unreal.UObject {
  static function getSomeStaticInt<T>():Int;
  function copyNew<T>(withType:PStruct<T>):PHaxeCreated<T>;
}

@:glueCppIncludes("TemplatesDef.h")
@:uextern extern class FTemplatedClass1<A> {
  public var value:A;
  public function get():A;
  public function set(v:A):Void;

  @:uname('new') static function create<A>(val:A):PHaxeCreated<FTemplatedClass1<A>>;
}

@:glueCppIncludes("TemplatesDef.h")
@:uextern extern class FTemplatedClass2<A,B> {
  public function createWithA(value:A):FTemplatedClass1<A>;
  public function createWithB(value:B):FTemplatedClass1<B>;

  @:uname('new') static function create<A,B>():PHaxeCreated<FTemplatedClass2<A,B>>;
}
