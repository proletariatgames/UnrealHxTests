#pragma once

#include <Engine.h>
#include "SomeEnum.generated.h"

UENUM()
enum EMyEnum {
  SomeEnum1 = 1,
  SomeEnum2 = 100,
  SomeEnum3 = 200
};

UENUM(BlueprintType)
enum class EMyCppEnum : uint8 {
  CppEnum1,
  CppEnum2 = 30,
  CppEnum3 = 40
};

UENUM()
namespace EMyNamespacedEnum {
  enum Value {
    NSEnum1,
    NSEnum2 = 101,
    NSEnum3 = 201
  };
}
