#pragma once

#include "GameFramework/GameMode.h"
#include "BasicTypesUObject.h"
#include "BasicTypesSub.generated.h"

/**
 * 
 */
UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub1 : public UBasicTypesUObject
{
  GENERATED_BODY()
    
  public:
  bool isSub1 = true;

  UFUNCTION()
  virtual int64 setText(FText text) override;

  virtual int32 getSomeNumber() const override {
    return 43;
  }

  static UBasicTypesSub1 *CreateFromCpp() {
    return NewObject<UBasicTypesSub1>();
  }
};

UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub2 : public UBasicTypesUObject
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
};

UCLASS()
class HAXEUNITTESTS_API UBasicTypesSub3 : public UBasicTypesSub2
{
  GENERATED_BODY()
    
  public:
  bool isSub3 = true;
  virtual bool setUI64_I64_Float_Double(uint64 ui64, int64 i64, float f, double d) override;

  UFUNCTION()
  virtual int64 setText(FText text) override;

  static UBasicTypesSub3 *CreateFromCpp() {
    return NewObject<UBasicTypesSub3>();
  }

  virtual int32 getSomeNumber() const override {
    return 45;
  }
};

