#include "NonUObject.h"
#include "HaxeUnitTests.h"

int FSimpleStruct::someStaticInt = 442;

int32 FSimpleStruct::nDestructorCalled = 0;
int32 FSimpleStruct::nConstructorCalled = 0;
int32 FSimpleUStruct::nDestructorCalled = 0;
int32 FSimpleUStruct::nConstructorCalled = 0;
int32 FSimpleUStruct::nCopyConstructorCalled = 0;
// int32 FSimpleUStruct::nMoveConstructorCalled = 0;

static FSimpleStruct sharedRef = FSimpleStruct();

FSimpleStruct *FSimpleStruct::getRef() {
  return &sharedRef;
}

int32 FHasStructMember1::nDestructorCalled = 0;
int32 FHasStructMember1::nConstructorCalled = 0;

int32 FHasStructMember2::nDestructorCalled = 0;
int32 FHasStructMember2::nConstructorCalled = 0;

int32 FHasStructMember3::nDestructorCalled = 0;
int32 FHasStructMember3::nConstructorCalled = 0;

static FOverride sharedOverride = FOverride();

FBase *FBase::getOverride() {
  return &sharedOverride;
}
