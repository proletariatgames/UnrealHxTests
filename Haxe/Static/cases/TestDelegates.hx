package cases;
using buddy.Should;
import NonUObject;
import Delegates;
import helpers.TestHelper;
import unreal.*;

typedef FDelHaxe0 = unreal.DynamicMulticastDelegate<FDelHaxe0, Void->Void>;
typedef FDelHaxe1 = unreal.MulticastDelegate<FDelHaxe1, PRef<Int>->Void>;
typedef FDelHaxe1_2 = unreal.MulticastDelegate<FDelHaxe1_2, PRef<FString>->Void>;
typedef FDelHaxe2 = unreal.DynamicMulticastDelegate<FDelHaxe2, Int->Int->Void>;
@:ueParamName("FirstArg") @:ueParamName("SecondArg") @:ueParamName("ThirdArg")
typedef FDelHaxe3 = unreal.DynamicMulticastDelegate<FDelHaxe3, Int->Int->Int->Void>;
typedef FDelHaxe4 = unreal.DynamicMulticastDelegate<FDelHaxe4, Int->Int->Int->Int->Void>;
typedef FDelHaxe5 = unreal.DynamicMulticastDelegate<FDelHaxe5, Int->Int->Int->Int->Int->Void>;
typedef FDelHaxe6 = unreal.DynamicMulticastDelegate<FDelHaxe6, Int->Int->Int->Int->Int->Int->Void>;
typedef FDelHaxe7 = unreal.DynamicMulticastDelegate<FDelHaxe7, Int->Int->Int->Int->Int->Int->Int->Void>;
typedef FDelHaxe8 = unreal.DynamicMulticastDelegate<FDelHaxe8, Int->UUsesDelegate->Int->Int->Int->Int->Int->Int->Void>;

typedef FDelHaxe0_RV = unreal.Delegate<FDelHaxe0_RV, Void->Int>;
typedef FDelHaxe1_RV = unreal.DynamicDelegate<FDelHaxe1_RV, Int->Int>;
typedef FDelHaxeStrInt = unreal.Delegate<FDelHaxeStrInt, FString->Int>;
typedef FDelHaxeStr_Multi = unreal.MulticastDelegate<FDelHaxeStr_Multi, FString->Void>;
typedef FDelHaxe_Multi = unreal.MulticastDelegate<FDelHaxe_Multi, Void->Void>;

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

  public var numCallbacks:Int = 0;
  @:ufunction public function ufun() : Void {
    numCallbacks++;
  }
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
        // x.IsBound().should.be(false);
        x.Broadcast(1, 2, 3);
      });
      it('should be able to register delegates from Haxe code', {
        var del1 = FDelHaxe1.create();
        var value = 0;
        del1.AddLambda(function(i) value = i);
        del1.Broadcast(255);
        value.should.be(255);

        var del1_2 = FDelHaxe1_2.create();
        var value = null;
        del1_2.AddLambda(function(i) value = i);
        del1_2.Broadcast("Hello, World!");
        value.toString().should.be("Hello, World!");
      });
      it('should be able to bind to uobject functions', {
        var del = FDelHaxe_Multi.create();
        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.numCallbacks.should.be(0);
        del.AddUObject(obj, MethodPointer.fromMethod(obj.ufun));
        del.Broadcast();
        obj.numCallbacks.should.be(1);
      });
      it('should be able to unregister delegates from Haxe code', {
        var called = 0;
        function cb(name:FString) : Void {
          name.toString().should.be("hello");
          ++called;
        }
        var del = FDelHaxeStr_Multi.create();
        var handle = del.AddLambda(cb);
        del.Broadcast("hello");
        called.should.be(1);
        del.Remove(handle);
        del.Broadcast("world");
        called.should.be(1);
      });
      it('should be able to create new UCLASS types that use delegates', {
        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.test0.Broadcast();
      });
      it('should be able to declare new delegate types', {
        FDelHaxe0.create();
        FDelHaxe1.create();
        FDelHaxe2.create();
        FDelHaxe3.create();
        FDelHaxe4.create();
        FDelHaxe5.create();
        FDelHaxe6.create();
        FDelHaxe7.create();
        FDelHaxe8.create();
      });
      // Delegate examples from SeekPlayerState.h
      //
      // DECLARE_DYNAMIC_MULTICAST_DELEGATE(FLootEvent);
      // DECLARE_DYNAMIC_MULTICAST_DELEGATE_ThreeParams(FDeathEvent, ASeekPlayerState*, PlayerState, ASeekPlayerState*, Killer, const FVector&, Location);
      //
    });
  }
}

