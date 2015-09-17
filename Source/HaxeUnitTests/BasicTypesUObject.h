#pragma once

#include "GameFramework/GameMode.h"
#include "BasicTypesUObject.generated.h"

/**
 * 
 */
UCLASS()
class HAXEUNITTESTS_API UBasicTypesUObject : public UObject
{
  GENERATED_BODY()
    
  public:
  bool boolNonProp;
  FString stringNonProp;
  uint8 ui8NonProp;
  int8 i8NonProp;
  uint16 ui16NonProp;
  int16 i16NonProp;
  int32 i32NonProp;
  uint32 ui32NonProp;
  int64 i64NonProp;
  uint64 ui64NonProp;
  float floatNonProp;
  double doubleNonProp;

  UPROPERTY()
  bool boolProp;
  UPROPERTY()
  FString stringProp;
  UPROPERTY()
  uint8 ui8Prop;
  UPROPERTY()
  int8 i8Prop;
  UPROPERTY()
  uint16 ui16Prop;
  UPROPERTY()
  int16 i16Prop;
  UPROPERTY()
  int32 i32Prop;
  UPROPERTY()
  uint32 ui32Prop;
  UPROPERTY()
  int64 i64Prop;
  UPROPERTY()
  uint64 ui64Prop;
  UPROPERTY()
  float floatProp;
  UPROPERTY()
  double doubleProp;

  static UBasicTypesUObject *CreateFromCpp();
};

