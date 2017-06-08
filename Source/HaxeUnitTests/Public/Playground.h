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
};
