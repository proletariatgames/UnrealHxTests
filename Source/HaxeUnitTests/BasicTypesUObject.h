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
  static int someStaticInt;

  bool boolNonProp;
  FString stringNonProp;
  FText textNonProp;
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
  FText textProp;
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

  UFUNCTION()
  bool getBoolProp();
  UFUNCTION()
  FString getStringProp();
  UFUNCTION()
  uint8 getUi8Prop();
  UFUNCTION()
  int8 getI8Prop();
  uint16 getUi16Prop();
  int16 getI16Prop();
  UFUNCTION()
  int32 getI32Prop();
  UFUNCTION()
  uint32 getUi32Prop();
  UFUNCTION()
  int64 getI64Prop();
  uint64 getUi64Prop();
  UFUNCTION()
  float getFloatProp();
  UFUNCTION()
  double getDoubleProp();

  UFUNCTION()
  UBasicTypesUObject *setBool_String_UI8_I8(bool b, FString str, uint8 ui8, int8 i8);

  void setUI16_I16_UI32_I32(uint16 ui16, int16 i16, uint32 ui32, int32 i32);

  virtual bool setUI64_I64_Float_Double(uint64 ui64, int64 i64, float f, double d);

  UFUNCTION()
  virtual int64 setText(FText text);

  virtual int32 getSomeNumber() const {
    return 42;
  }
};

