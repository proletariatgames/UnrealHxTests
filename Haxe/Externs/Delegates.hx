
@:glueCppIncludes("DelegatesTest.h")
@:uextern extern class DelIntInt implements unreal.Delegate<Int->Int> {}

@:glueCppIncludes("DelegatesTest.h")
@:uextern extern class DelIntObj implements unreal.Delegate<Int->unreal.UObject> {}
