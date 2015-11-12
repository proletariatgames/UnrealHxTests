#include "HaxeUnitTests.h"
#include "TypeParamTester.h"
#include <TypeParamGlue.h>
#include <cstdio>
#include "SomeEnum.h"
#include <ETestHxEnumClass.h>

#define TEST_ROUNDTRIP(type,obj) \
  printf("Testing " #type" (" #obj")\n"); \
  if (TypeParamGlue<type>::haxeToUe(TypeParamGlue<type>::ueToHaxe(obj)) != obj) { \
    fprintf(stderr, "ERROR roundtrip on "#type" for "#obj"\n"); \
    return false; \
  }

bool FTypeParamTester::testRoundtrip() {
  TEST_ROUNDTRIP(bool, true);
  TEST_ROUNDTRIP(bool, false);
  TEST_ROUNDTRIP(int32, 42);
  TEST_ROUNDTRIP(uint32, 0xFFFFFFFF);
  TEST_ROUNDTRIP(int8, (int8) -1);
  TEST_ROUNDTRIP(uint8, 0xFF);
  TEST_ROUNDTRIP(int16, (int16) -1);
  TEST_ROUNDTRIP(uint16, 0xFFFF);
  TEST_ROUNDTRIP(int32, (int32) -1);
  TEST_ROUNDTRIP(uint32, 0xFFFFFFFF);
  TEST_ROUNDTRIP(int64, (int64) -1LL);
  TEST_ROUNDTRIP(uint64, 0xFFFFFFFFFFFFFFFFULL);
  TEST_ROUNDTRIP(EMyEnum, SomeEnum2);
  TEST_ROUNDTRIP(EMyCppEnum, EMyCppEnum::CppEnum1);
  TEST_ROUNDTRIP(EMyNamespacedEnum::Value, EMyNamespacedEnum::NSEnum3);

  return true;
}

