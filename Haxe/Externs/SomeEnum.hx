
@:glueCppIncludes("SomeEnum.h")
@:uextern extern enum EMyEnum {
  SomeEnum1;
  SomeEnum2;
  SomeEnum3;
}

@:glueCppIncludes("SomeEnum.h")
@:uextern @:class extern enum EMyCppEnum {
  CppEnum1;
  CppEnum2;
  CppEnum3;
}

@:glueCppIncludes("SomeEnum.h")
@:uname('EMyNamespacedEnum.Value')
@:uextern extern enum EMyNamespacedEnum {
  NSEnum1;
  NSEnum2;
  NSEnum3;
}
