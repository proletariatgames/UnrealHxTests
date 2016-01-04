
@:glueCppIncludes("DelegatesTest.h")
@:umodule("HaxeUnitTests")
@:uextern extern class DelIntInt extends unreal.Delegate<Int->Int> {}

@:glueCppIncludes("DelegatesTest.h")
@:umodule("HaxeUnitTests")
@:uextern extern class DelIntObj extends unreal.Delegate<Int->unreal.UObject> {}
