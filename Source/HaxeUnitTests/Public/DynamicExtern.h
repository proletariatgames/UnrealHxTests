#pragma once

#include "CoreMinimal.h"
#include "DynamicExtern.generated.h"

UCLASS(Blueprintable, Category="Cppia")
class HAXEUNITTESTS_API ACppDynamicExtern : public AActor {
  GENERATED_BODY()

public:
  UPROPERTY(BlueprintReadOnly, EditAnywhere, Category="Cppia")
  FString theString;

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints(const FString& str);

  UFUNCTION(BlueprintCallable, Category="Cppia")
  int runCppFunction(int i, const FString& str) {
    return i * str.Len();
  }

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints2(FString& str);

  UFUNCTION(BlueprintCallable, Category="Cppia")
  void testOut(FString& str) {
    str = TEXT("called");
  }

  UFUNCTION()
  static int32 getStringSize(const FString& str) {
    return str.Len();
  }
};