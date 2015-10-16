#pragma once

#include "GameFramework/GameMode.h"
#include "TemplatesDef.generated.h"

UCLASS()
class HAXEUNITTESTS_API UTemplatesDef : public UObject
{
  GENERATED_BODY()

public:
  static int someStaticInt;

  template<class T>
  static int getSomeStaticInt() {
    return T::someStaticInt;
  }

  template<class T>
  static T *copyNew(T withType) {
    T *ret = new T();
    *ret = withType;
    return ret;
  }
};
