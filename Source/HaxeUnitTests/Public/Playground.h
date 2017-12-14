#pragma once

#include "Engine.h"
#include "UnrealNetwork.h"
#include "Playground.generated.h"

UCLASS()
class HAXEUNITTESTS_API AReplicationTests : public AActor {
  GENERATED_BODY()

public:
  UPROPERTY(Replicated)
  TArray<uint32> intArray;

  UPROPERTY(ReplicatedUsing=OnRep_something)
  int32 something;

  UFUNCTION()
  void OnRep_something() {
  }


  DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FInnerDelTest, int32, argument);
  UPROPERTY()
  FInnerDelTest delTest;

  void GetLifetimeReplicatedProps(TArray< FLifetimeProperty > & OutLifetimeProps) const override {
    DOREPLIFETIME(AReplicationTests, intArray);
    DOREPLIFETIME(AReplicationTests, something);
  }


  UFUNCTION(NetMulticast, Reliable)
  void doSomething(const FString& str);

  void doSomething_Implementation(const FString& str) {
  }

  UFUNCTION(NetMulticast, Reliable)
  void doSomething2(const FString& str);

  void doSomething2_Implementation(const FString& str) {
  }

  UFUNCTION(Server, WithValidation, Reliable)
  void Server_WithValidation_Reliable(const FString& str);

  void Server_WithValidation_Reliable_Implementation(const FString& str) {
  }

  bool Server_WithValidation_Reliable_Validate(const FString& str) {
    return true;
  }
};

UCLASS(Blueprintable, Category="Cppia")
class HAXEUNITTESTS_API UCppBPTest : public UObject {
  GENERATED_BODY()

public:
  UPROPERTY(BlueprintReadOnly, EditAnywhere, Category="Cppia")
  FString theString;

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints(const FString& str);

  UFUNCTION(BlueprintCallable, Category="Cppia")
  int runHaxeFunction(int i, const FString& str) {
    return i * 100;
  }

  UFUNCTION(BlueprintImplementableEvent, Category="Cppia")
  int runBlueprints2(FString& str);

  UFUNCTION(BlueprintCallable, Category="Cppia")
  FString getOutValue() {
    FString ret;
    runBlueprints2(ret);
    return ret;
  }

  UFUNCTION(BlueprintCallable, Category="Cppia")
  void testOut(FString& str) {
    str = TEXT("ohai called");
  }

};


UCLASS()
class HAXEUNITTESTS_API USomeTests : public UObject {
  GENERATED_BODY()

public:

  UFUNCTION()
  void test(UWorld *world, ETravelFailure::Type failure, const FString& msg) {
    testMsg = msg;
  }

  UPROPERTY()
  FString testMsg;
};