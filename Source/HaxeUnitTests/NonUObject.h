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

    ~FSimpleStruct() {
      nDestructorCalled++;
    }

    FString toString() {
      return FString::Printf(TEXT("Simple Struct (%d) { %d, %d, %d, %d }"), usedDefaultConstructor, (int)f1, (int)d1, i32, ui32);
    }
};
