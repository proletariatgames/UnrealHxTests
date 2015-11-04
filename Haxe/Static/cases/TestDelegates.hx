package cases;
using buddy.Should;
import NonUObject;
import Delegates;
import helpers.TestHelper;
import unreal.*;

class FDelHaxe0 extends unreal.DynamicMulticastDelegate<Void->Void> {}
class FDelHaxe1 extends unreal.DynamicMulticastDelegate<Int->Void> {}
class FDelHaxe2 extends unreal.DynamicMulticastDelegate<Int->Int->Void> {}
@:ueParamName("FirstArg") @:ueParamName("SecondArg") @:ueParamName("ThirdArg")
class FDelHaxe3 extends unreal.DynamicMulticastDelegate<Int->Int->Int->Void> {}
class FDelHaxe4 extends unreal.DynamicMulticastDelegate<Int->Int->Int->Int->Void> {}
class FDelHaxe5 extends unreal.DynamicMulticastDelegate<Int->Int->Int->Int->Int->Void> {}
class FDelHaxe6 extends unreal.DynamicMulticastDelegate<Int->Int->Int->Int->Int->Int->Void> {}
class FDelHaxe7 extends unreal.DynamicMulticastDelegate<Int->Int->Int->Int->Int->Int->Int->Void> {}
class FDelHaxe8 extends unreal.DynamicMulticastDelegate<Int->UUsesDelegate->Int->Int->Int->Int->Int->Int->Void> {}

class FDelHaxe0_RV extends unreal.Delegate<Void->Int> {}
class FDelHaxe1_RV extends unreal.DynamicDelegate<Int->Int> {}

@:uclass class UUsesDelegate extends unreal.UObject {
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test0:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test1:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test2:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test3:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test4:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test5:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test6:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test7:FDelHaxe0;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test8:FDelHaxe0;

  @:uproperty
  public var testRV:FDelHaxe1_RV;

  public var testCRV:FDelHaxe0_RV;
}

class TestDelegates extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Delegates', {
      it('should be able to call delegates', {
        var x = DelIntInt.create();
        x.IsBound().should.be(false);
      });
      it('should be able to declare delegates', {
        var x = FDelHaxe3.create();
        x.IsBound().should.be(false);
        x.Broadcast(1, 2, 3);
      });
      it('should be able to register delegates from Haxe code');
      it('should be able to unregister delegates from Haxe code');
      it('should be able to create new UCLASS types that use delegates', {
        var obj = UObject.NewObject(new TypeParam<PStruct<UUsesDelegate>>());
        obj.test0.IsBound().should.be(false);
      });
      it('should be able to declare new delegate types');
      // Delegate examples from SeekPlayerState.h
      //
      // DECLARE_DYNAMIC_MULTICAST_DELEGATE(FLootEvent);
      // DECLARE_DYNAMIC_MULTICAST_DELEGATE_ThreeParams(FDeathEvent, ASeekPlayerState*, PlayerState, ASeekPlayerState*, Killer, const FVector&, Location);
      //
    });
  }
}

