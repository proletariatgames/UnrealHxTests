#pragma once

#include "GameFramework/GameMode.h"
#include "BasicTypesUObject.h"
#include "BasicType2.h"
#include "EnumAsByte.h"
#include "SomeEnum.h"
#include "UserWidget.h"
#include "BasicTypesSub.generated.h"

DECLARE_DYNAMIC_DELEGATE_RetVal_OneParam(int32, FDynIntInt, int32, name);
/**
 *
 */
UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub1 : public UBasicTypesUObject
{
  GENERATED_BODY()

  public:
  bool isSub1 = true;

  static UBasicTypesUObject *SomeObject;

  virtual int64 setText(FText text) override;

  UFUNCTION(BlueprintImplementableEvent)
  int32 bpImplementableEvent(const FString& s);

  UFUNCTION(BlueprintNativeEvent)
  int32 bpNativeEvent(FString& s);

  UFUNCTION()
  int enumAsByteTest(FName actionName, TEnumAsByte< EInputEvent > EventType) {
    return (int) EventType.GetValue() + actionName.ToString().Len();
  }

  UFUNCTION()
  int enumAsByteTest2(FName actionName, EInputEvent EventType) {
    return (int) EventType + actionName.ToString().Len();
  }

  UFUNCTION()
  static void GetPathName() {
    // testing extern generator name collision
  }

  void getSomeEnum(int i, EMyEnum& out) {
    if (i == 0) {
      out = SomeEnum1;
    } else {
      out = SomeEnum3;
    }
  }

  void getSomeCppEnum(int i, EMyCppEnum & out) {
    if (i == 0) {
      out = EMyCppEnum::CppEnum1;
    } else {
      out = EMyCppEnum::CppEnum3;
    }
  }

  UPROPERTY()
  FDynIntInt someDelegate;

  int32 bpNativeEvent_Implementation(FString& s) {
    return s.Len();
  }


  virtual int32 getSomeNumber() const override {
    return 43;
  }

  virtual bool writeToByteArray(uint8 *arr, int loc, uint8 what) {
    arr[loc] = what;
    return true;
  }

  static UBasicTypesSub1 *CreateFromCpp() {
    return NewObject<UBasicTypesSub1>();
  }

protected:
  UFUNCTION()
  int enumAsByteTestPrivate(FName actionName, TEnumAsByte< EInputEvent > EventType) {
    return (int) EventType.GetValue() + actionName.ToString().Len();
  }

  UFUNCTION()
  int enumAsByteTestPrivate2(FName actionName, EInputEvent EventType) {
    return (int) EventType + actionName.ToString().Len();
  }
};

UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub2 : public UBasicTypesUObject, public IBasicType2
{
  GENERATED_BODY()

  public:
  bool isSub2 = true;

  static UBasicTypesSub2 *CreateFromCpp() {
    return NewObject<UBasicTypesSub2>();
  }

  virtual int32 getSomeNumber() const override {
    return 44;
  }

  virtual IBasicType2 *doSomething() override {
    return this;
  }

  virtual FString getSubName() override {
    return TEXT("Sub2");
  }

  virtual int32 getSomeInt() override {
    return 0xf00;
  }
};

UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub3 : public UBasicTypesSub2
{
  GENERATED_BODY()

  public:
  bool isSub3 = true;
  virtual bool setUI64_I64_Float_Double(uint64 ui64, int64 i64, float f, double d) override;

  virtual int64 setText(FText text) override;

  static UBasicTypesSub3 *CreateFromCpp() {
    return NewObject<UBasicTypesSub3>();
  }

  virtual int32 getSomeNumber() const override {
    return 45;
  }

  virtual FString getSubName() override {
    return TEXT("Sub3");
  }

  virtual int32 getSomeInt() override {
    return 0xba5;
  }
};

