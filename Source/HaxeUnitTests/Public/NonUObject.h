#pragma once

#include <cstdio>
#include "Engine.h"
#include "SomeEnum.h"
#include "NonUObject.generated.h"

USTRUCT(BlueprintType)
struct HAXEUNITTESTS_API FPODStruct {
  GENERATED_BODY()

  UPROPERTY()
  float f;
  UPROPERTY()
  double d;
  UPROPERTY(BlueprintReadWrite, Category="POD Struct")
  int32 i32;
  UPROPERTY()
  uint32 ui32;
};

USTRUCT()
struct HAXEUNITTESTS_API FSimpleUStruct {
  GENERATED_BODY()

  static int32 nDestructorCalled;
  static int32 nConstructorCalled;
  static int32 nCopyConstructorCalled;
  // static int32 nMoveConstructorCalled;

  float f1;
  double d1;
  int32 i32;
  uint32 ui32;

  bool usedDefaultConstructor;

  FSimpleUStruct() : usedDefaultConstructor(true) {
    nConstructorCalled++;
  }

  FSimpleUStruct(float iF1, double iD1, int32 iI32, uint32 iUi32) :
    f1(iF1),
    d1(iD1),
    i32(iI32),
    ui32(iUi32),
    usedDefaultConstructor(false)
  {
    nConstructorCalled++;
  }

  FSimpleUStruct(const FSimpleUStruct& inOrig) :
    f1(inOrig.f1),
    d1(inOrig.d1),
    i32(inOrig.i32),
    ui32(inOrig.ui32),
    usedDefaultConstructor(inOrig.usedDefaultConstructor)
  {
    nCopyConstructorCalled++;
  }

  virtual ~FSimpleUStruct() {
    nDestructorCalled++;
  }

};

class HAXEUNITTESTS_API FSimpleStruct {
  public:
    static int someStaticInt;
    static int32 nDestructorCalled;
    static int32 nConstructorCalled;

    float f1;
    double d1;
    int32 i32;
    uint32 ui32;

    bool usedDefaultConstructor;

    FSimpleStruct() : usedDefaultConstructor(true) {
      nConstructorCalled++;
    }

    FSimpleStruct(float iF1, double iD1, int32 iI32, uint32 iUi32) :
      f1(iF1),
      d1(iD1),
      i32(iI32),
      ui32(iUi32),
      usedDefaultConstructor(false)
    {
      nConstructorCalled++;
    }

    static bool isNull(FSimpleStruct *obj) {
      return obj == nullptr;
    }

    static FSimpleStruct *getNull() {
      return nullptr;
    }

    static FSimpleStruct *getRef();

    // TODO
    // static FSimpleStruct& getRef();

    static bool isI32EqualByVal(FSimpleStruct self, int32 i) {
      return self.i32 == i;
    }

    static bool isI32Equal(FSimpleStruct *self, int32 i) {
      return self->i32 == i;
    }

    static bool isI32EqualRef(FSimpleStruct& self, int32 i) {
      return self.i32 == i;
    }

    static bool isI32EqualShared(TSharedPtr<FSimpleStruct> self, int32 i) {
      return self->i32 == i;
    }

    static bool isI32EqualSharedRef(TSharedRef<FSimpleStruct> self, int32 i) {
      return self->i32 == i;
    }

    static bool isI32EqualWeak(TWeakPtr<FSimpleStruct> self, int32 i) {
      return self.Pin()->i32 == i;
    }

    static TSharedPtr<FSimpleStruct> mkShared() {
      return MakeShareable(new FSimpleStruct());
    }

    static TSharedPtr<FSimpleStruct> createSharedPtr() {
      return MakeShareable(new FSimpleStruct());
    }

    static TWeakPtr<FSimpleStruct> setF1AndReturnWeak(TSharedPtr<FSimpleStruct> shared, float f1) {
      shared->f1 = f1;
      return shared;
    }

    static TSharedRef<FSimpleStruct> createSharedRef() {
      return TSharedRef<FSimpleStruct>(new FSimpleStruct());
    }

    virtual ~FSimpleStruct() {
      nDestructorCalled++;
    }

    FString ToString() {
      return FString::Printf(TEXT("Simple Struct (%d) { %d, %d, %d, %d }"), usedDefaultConstructor, (int)f1, (int)d1, i32, ui32);
    }

    bool operator==(const FSimpleStruct& other) const {
      return f1 == other.f1 &&
             d1 == other.d1 &&
             i32 == other.i32 &&
             ui32 == other.ui32;
    }
};

class HAXEUNITTESTS_API FSimpleStructNoEqualsOperator {
  public:
    float f1;
    double d1;
    int32 i32;
    uint32 ui32;


    FSimpleStructNoEqualsOperator(float iF1, double iD1, int32 iI32, uint32 iUi32) :
      f1(iF1),
      d1(iD1),
      i32(iI32),
      ui32(iUi32)
    {
    }
  private:
    FSimpleStructNoEqualsOperator(FSimpleStruct& copied) {
    }
};

class HAXEUNITTESTS_API FHasStructMember1 {
  public:
    static int32 nDestructorCalled;
    static int32 nConstructorCalled;

    FSimpleStruct simple;
    FName fname;
    EMyEnum myEnum;
    EMyCppEnum myCppEnum;
    EMyNamespacedEnum::Value myNamespacedEnum;

    FHasStructMember1() {
      nConstructorCalled++;
    }

    bool isI32Equal(int32 i) {
      return this->simple.i32 == i;
    }

    ~FHasStructMember1() {
      nDestructorCalled++;
    }
};

class HAXEUNITTESTS_API FHasStructMember2 {
  public:
    static int32 nDestructorCalled;
    static int32 nConstructorCalled;

    TSharedPtr<FSimpleStruct> shared;

    FHasStructMember2() {
      nConstructorCalled++;
    }

    bool isI32Equal(int32 i) {
      return this->shared->i32 == i;
    }

    ~FHasStructMember2() {
      nDestructorCalled++;
    }
};

class HAXEUNITTESTS_API FHasStructMember3 {
  public:
    static int32 nDestructorCalled;
    static int32 nConstructorCalled;

    FSimpleStruct& ref;
    FSimpleStruct simple;
    bool usedDefaultConstructor;

    FHasStructMember3(FSimpleStruct &theref) : ref(theref), usedDefaultConstructor(false) {
      nConstructorCalled++;
    }

    FHasStructMember3() : ref(simple), usedDefaultConstructor(true) {
      nConstructorCalled++;
    }

    FHasStructMember3(const FHasStructMember3& inRHS) :
      ref( inRHS.usedDefaultConstructor ? simple : inRHS.ref ),
      simple( inRHS.simple ),
      usedDefaultConstructor( inRHS.usedDefaultConstructor ) {}

    bool isI32Equal(int32 i) {
      return this->ref.i32 == i;
    }

    static void setRef(FSimpleStruct &ref, FSimpleStruct to) {
      ref = to;
    }

    ~FHasStructMember3() {
      nDestructorCalled++;
    }
};

class HAXEUNITTESTS_API FHasPointers {
  public:
    int *intptr;
    int **ptrIntptr;
    void *voidptr;
    float *floatptr;
    TSharedPtr<int> sharedInt;
    TSharedPtr<int *> sharedIntptr;
    int &intref;
    int someInt;

    FHasPointers() : intref(someInt) {
    }

    FHasPointers(int &ref) : intref(ref) {
    }
};

class HAXEUNITTESTS_API FBase : public FSimpleStruct {
  public:
    float otherValue;
    virtual int32 getSomeInt() {
      return 0xDEADF00;
    }

    static FBase *getOverride();
};

class HAXEUNITTESTS_API FOverride : public FBase {
  public:
    double yetAnotherValue;
    virtual int32 getSomeInt() override {
      return 0xBA5;
    }
};
