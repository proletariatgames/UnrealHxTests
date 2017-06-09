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
