#include "HaxeUnitTests.h"
#include "BasicTypesUObject.h"

int UBasicTypesUObject::someStaticInt = 0;

UBasicTypesUObject *UBasicTypesUObject::CreateFromCpp() {
  return NewObject<UBasicTypesUObject>();
}

bool UBasicTypesUObject::getBoolProp() {
  return this->boolProp;
}

FString UBasicTypesUObject::getStringProp() {
  return this->stringProp;
}

uint8 UBasicTypesUObject::getUi8Prop() {
  return this->ui8Prop;
}

int8 UBasicTypesUObject::getI8Prop() {
  return this->i8Prop;
}

uint16 UBasicTypesUObject::getUi16Prop() {
  return this->ui16Prop;
}

int16 UBasicTypesUObject::getI16Prop() {
  return this->i16Prop;
}

int32 UBasicTypesUObject::getI32Prop() {
  return this->i32Prop;
}

uint32 UBasicTypesUObject::getUi32Prop() {
  return this->ui32Prop;
}

int64 UBasicTypesUObject::getI64Prop() {
  return this->i64Prop;
}

uint64 UBasicTypesUObject::getUi64Prop() {
  return this->ui64Prop;
}

float UBasicTypesUObject::getFloatProp() {
  return this->floatProp;
}

double UBasicTypesUObject::getDoubleProp() {
  return this->doubleProp;
}


UBasicTypesUObject *UBasicTypesUObject::setBool_String_UI8_I8(bool b, FString str, uint8 ui8, int8 i8) {
  this->boolProp = b;
  this->stringProp = str;
  this->ui8Prop = ui8;
  this->i8Prop = i8;

  return this;
}

void UBasicTypesUObject::setUI16_I16_UI32_I32(uint16 ui16, int16 i16, uint32 ui32, int32 i32) {
  this->ui16Prop = ui16;
  this->i16Prop = i16;
  this->ui32Prop = ui32;
  this->i32Prop = i32;
}

bool UBasicTypesUObject::setUI64_I64_Float_Double(uint64 ui64, int64 i64, float f, double d) {
  this->ui64Prop = ui64;
  this->i64Prop = i64;
  this->floatProp = f;
  this->doubleProp = d;

  return false;
}

int64 UBasicTypesUObject::setText(FText txt) {
  this->textNonProp = txt;

  return 0xDEADBEEF8BADF00DLL;
}
