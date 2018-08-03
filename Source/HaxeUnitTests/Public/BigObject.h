#pragma once

#include "CoreMinimal.h"
#include "Object.h"
#include "BigObject.generated.h"

UCLASS()
class HAXEUNITTESTS_API UBigObject : public UObject
{
  GENERATED_BODY()

public:
  uint8 someData[512];

  UPROPERTY()
  bool test;
};