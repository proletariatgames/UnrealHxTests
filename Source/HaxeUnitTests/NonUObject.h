#pragma once

#include <Engine.h>

struct FPODStruct {
  float f;
  double d;
  int32 i32;
  uint32 ui32;
};

class FSimpleStruct {
  public:
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

    static FSimpleStruct *getRef();

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

    ~FSimpleStruct() {
      nDestructorCalled++;
    }

    FString toString() {
      return FString::Printf(TEXT("Simple Struct (%d) { %4.2f, %4.2f, %d, %u }"), usedDefaultConstructor, f1, d1, i32, ui32);
    }
};
