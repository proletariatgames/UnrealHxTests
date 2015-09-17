// Fill out your copyright notice in the Description page of Project Settings.

#include "HaxeUnitTests.h"
#include "HaxeUnitTestsGameMode.h"

UBasicTypesUObject *UBasicTypesUObject::CreateFromCpp() {
  return NewObject<UBasicTypesUObject>();
}
