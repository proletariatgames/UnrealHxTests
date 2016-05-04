
@:glueCppIncludes("DelegatesTest.h")
@:umodule("HaxeUnitTests")
@:uname('DelIntInt')
typedef DelIntInt = unreal.Delegate<DelIntInt, Int->Int>;

@:glueCppIncludes("DelegatesTest.h")
@:umodule("HaxeUnitTests")
@:uname('DelIntObj')
typedef DelIntObj = unreal.Delegate<DelIntObj, Int->unreal.UObject>;
