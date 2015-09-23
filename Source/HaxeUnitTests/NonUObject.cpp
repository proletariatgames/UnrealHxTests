#include "HaxeUnitTests.h"
#include "NonUObject.h"

int32 FSimpleStruct::nDestructorCalled = 0;
int32 FSimpleStruct::nConstructorCalled = 0;

static FSimpleStruct sharedRef = FSimpleStruct();

FSimpleStruct *FSimpleStruct::getRef() {
  return &sharedRef;
}
