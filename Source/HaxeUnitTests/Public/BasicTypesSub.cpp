#include "HaxeUnitTests.h"
#include "BasicTypesSub.h"

int64 UBasicTypesSub1::setText(FText text)
{
  Super::setText(text);
  return 0xD00DLL;
}

int64 UBasicTypesSub3::setText(FText text)
{
  this->textProp = text;
  this->stringProp = text.ToString();
  return 0xDEADF00DLL;
}

bool UBasicTypesSub3::setUI64_I64_Float_Double(uint64 ui64, int64 i64, float f, double d)
{
  Super::setUI64_I64_Float_Double(ui64, i64, f, d);
  return true;
}

UBasicTypesUObject *UBasicTypesSub1::SomeObject = nullptr;