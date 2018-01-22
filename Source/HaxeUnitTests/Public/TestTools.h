#pragma once

#include "CoreMinimal.h"
#include "TestTools.generated.h"

UCLASS()
class HAXEUNITTESTS_API UTestTools : public UObject
{
  GENERATED_BODY()

	public:
	UFUNCTION()
	static void openAutomationFrontend();
};