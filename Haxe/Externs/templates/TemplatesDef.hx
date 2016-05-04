package templates;
import unreal.*;

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class UTemplatesDef extends unreal.UObject {
  @:typeName static function getSomeStaticInt<T>():Int;
  @:typeName function copyNew<T>(withType:T):POwnedPtr<T>;
}

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class FTemplatedClass1<A> {
  public var value:A;
  public function get():A;
  public function set(v:A):Void;

  @:uname('.ctor') static function create<A>(val:A):FTemplatedClass1<A>;
  @:uname('new') static function createNew<A>(val:A):POwnedPtr<FTemplatedClass1<A>>;
}

@:glueCppIncludes("TemplatesDef.h")
@:umodule("HaxeUnitTests")
@:uextern extern class FTemplatedClass2<A,B> {
  public function createWithA(value:A):FTemplatedClass1<A>;
  public function createWithB(value:B):FTemplatedClass1<B>;
  public function createRec(value:A):FTemplatedClass1< FTemplatedClass1<A> >;

  @:uname('.ctor') static function create<A,B>():FTemplatedClass2<A,B>;
  @:uname('new') static function createNew<A,B>():POwnedPtr<FTemplatedClass2<A,B>>;
}

@:glueCppIncludes("TemplatesDef.h")
@:uname("FNonTemplatedClass1")
@:umodule("HaxeUnitTests")
@:uextern extern class FNonTemplatedClass {
  public var obj:FTemplatedClass1<PPtr<FNonTemplatedClass>>;

  @:uname('.ctor') static function create():FNonTemplatedClass;
  @:uname('new') static function createNew():POwnedPtr<FNonTemplatedClass>;
}
