#pragma once

#include "CoreMinimal.h"
#include "StaticExtern.generated.h"

UCLASS(Blueprintable, Category="Cppia")
class HAXEUNITTESTS_API ACppStaticExtern : public AActor {
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

  UFUNCTION(BlueprintNativeEvent, Category="Cppia")
  int runBlueprints3(FString& str);

  virtual int runBlueprints3_Implementation(FString& str) {
    int len = theString.Len();
    str = theString + TEXT("_Implementation");
    return len;
  }

};

UCLASS(Blueprintable, Category="Cppia")
class HAXEUNITTESTS_API UCppStaticExternObject : public UObject {
  GENERATED_BODY()

public:
  UPROPERTY(BlueprintReadOnly, EditAnywhere, Category="Cppia")
  FString theString;

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints(const FString& str);

  UFUNCTION()
  int run_runBlueprints(const FString& str) {
    return runBlueprints(str);
  }

  UFUNCTION(BlueprintCallable, Category="Cppia")
  int runCppFunction(int i, const FString& str) {
    return i * str.Len();
  }

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints2(FString& str);

  UFUNCTION()
  int run_runBlueprints2(FString& str) {
    return runBlueprints2(str);
  }

  UFUNCTION(BlueprintCallable, Category="Cppia")
  void testOut(FString& str) {
    str = TEXT("called");
  }

  UFUNCTION(BlueprintNativeEvent, Category="Cppia")
  int runBlueprints3(FString& str);

  UFUNCTION()
  int run_runBlueprints3(FString& str) {
    return runBlueprints3(str);
  }

  virtual int runBlueprints3_Implementation(FString& str) {
    int len = theString.Len();
    str = theString + TEXT("_Implementation");
    return len;
  }

};
