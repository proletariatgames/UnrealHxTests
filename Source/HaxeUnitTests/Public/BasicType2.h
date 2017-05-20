#pragma once
#include "Engine.h"
#include "Interface.h"
#include "BasicType2.generated.h"

UINTERFACE()
class HAXEUNITTESTS_API UBasicType2 : public UInterface
{
  GENERATED_UINTERFACE_BODY()
  public:
};

class HAXEUNITTESTS_API IBasicType2
{
  GENERATED_IINTERFACE_BODY()

  public:
    virtual IBasicType2 *doSomething() = 0;
    virtual FString getSubName() = 0;
    UFUNCTION()
    virtual int32 getSomeInt() = 0;
};
