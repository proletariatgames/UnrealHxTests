/**
 * 
 * WARNING! This file was autogenerated by: 
 *  _   _ _   _ __   __ 
 * | | | | | | |\ \ / / 
 * | | | | |_| | \ V /  
 * | | | |  _  | /   \  
 * | |_| | | | |/ /^\ \ 
 *  \___/\_| |_/\/   \/ 
 * 
 * This file was autogenerated by UnrealHxGenerator using UHT definitions.
 * It only includes UPROPERTYs and UFUNCTIONs. Do not modify it!
 * In order to add more definitions, create or edit a type with the same name/package, but with an `_Extra` suffix
**/
package haxeunittests;

@:umodule("HaxeUnitTests")
@:glueCppIncludes("Playground.h")
@:uextern @:uclass extern class AReplicationTests extends unreal.AActor {
  @:uproperty public var delTest : haxeunittests.FInnerDelTest;
  @:uproperty public var something : unreal.Int32;
  @:uproperty public var intArray : unreal.TArray<unreal.FakeUInt32>;
  @:ufunction @:final public function OnRep_something() : Void;
  @:ufunction(BlueprintCallable) @:final public function TestDefault(f : unreal.Float32 = 0.100000) : Void;
  @:ufunction(NetMulticast) public function doSomething(str : unreal.FString) : Void;
  @:ufunction(NetMulticast) public function doSomething2(str : unreal.FString) : Void;
  @:ufunction(Server) public function Server_WithValidation_Reliable(str : unreal.FString) : Void;
  
}
