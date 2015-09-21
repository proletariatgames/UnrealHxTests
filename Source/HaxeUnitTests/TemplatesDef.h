#pragma once

#include "GameFramework/GameMode.h"
#include "TemplatesDef.generated.h"

UCLASS()
class HAXEUNITTESTS_API UTemplatesDef : public UObject
{
  GENERATED_BODY()

  template<class T>
  static int getSomeStaticInt(T *someInstance) {
    return T::someStaticInt;
  }
};
