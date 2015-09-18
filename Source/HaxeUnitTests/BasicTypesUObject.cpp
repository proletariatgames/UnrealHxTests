// Fill out your copyright notice in the Description page of Project Settings.

#include "HaxeUnitTests.h"
#include "BasicTypesUObject.h"

UBasicTypesUObject *UBasicTypesUObject::CreateFromCpp() {
  return NewObject<UBasicTypesUObject>();
}
