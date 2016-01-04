package templates;
import unreal.*;

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class UTemplatesDef extends unreal.UObject {
  @:typeName static function getSomeStaticInt<T>():Int;
  function copyNew<T>(withType:PStruct<T>):PHaxeCreated<T>;
}

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class FTemplatedClass1<A> {
  public var value:A;
  public function get():A;
  public function set(v:A):Void;

  @:uname('new') static function create<A>(val:A):PHaxeCreated<FTemplatedClass1<A>>;
}

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class FTemplatedClass2<A,B> {
  public function createWithA(value:A):PStruct<FTemplatedClass1<A>>;
  public function createWithB(value:B):PStruct<FTemplatedClass1<B>>;
  public function createRec(value:A):PStruct<FTemplatedClass1< PStruct<FTemplatedClass1<A>> >>;

  @:uname('new') static function create<A,B>():PHaxeCreated<FTemplatedClass2<A,B>>;
}

@:glueCppIncludes("TemplatesDef.h")
@:uname("FNonTemplatedClass1")
@:umodule("HaxeUnitTests")
@:uextern extern class FNonTemplatedClass {
  public var obj:PStruct< FTemplatedClass1<PExternal<FNonTemplatedClass>> >;

  @:uname('new') static function create():PHaxeCreated<FNonTemplatedClass>;
}
