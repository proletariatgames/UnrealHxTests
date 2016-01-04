
@:glueCppIncludes("SomeEnum.h")
@:umodule("HaxeUnitTests")
@:uextern extern enum EMyEnum {
  SomeEnum1;
  SomeEnum2;
  SomeEnum3;
}

@:glueCppIncludes("SomeEnum.h")
@:umodule("HaxeUnitTests")
@:uextern @:class extern enum EMyCppEnum {
  CppEnum1;
  CppEnum2;
  CppEnum3;
}

@:glueCppIncludes("SomeEnum.h")
@:umodule("HaxeUnitTests")
@:uname('EMyNamespacedEnum.Value')
@:uextern extern enum EMyNamespacedEnum {
  NSEnum1;
  NSEnum2;
  NSEnum3;
}
