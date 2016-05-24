package cases;
using buddy.Should;
import NonUObject;
import UBasicTypesSub;
import Delegates;
import helpers.TestHelper;
import cases.TestUObjectOverrides;
import cases.TestUEnum;
import SomeEnum;
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

typedef FDelTest1 = unreal.Delegate<FDelTest1, IBasicType2->Int>;
typedef FDelTest2 = unreal.Delegate<FDelTest2, FString->ETestHxEnumClass>;
typedef FDelTest3 = unreal.Delegate<FDelTest3, TWeakObjectPtr<UBasicTypesSub1>->EMyEnum>;
typedef FDelTest4 = unreal.Delegate<FDelTest4, Const<PRef<TWeakObjectPtr<UHaxeDerived2>>>->Int>;
typedef FDelTest5 = unreal.Delegate<FDelTest5, TSubclassOf<UHaxeDerived1>->Int>;

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
      it('should be able to use different kinds of types as arguments', {
        var t1 = FDelTest1.create();
        var didRun = false;
        t1.BindLambda(function(iface:IBasicType2) {
          iface.getSomeInt().should.be(0xf00ba5);
          iface.doSomething().getSomeInt().should.be(0xf00ba5);
          didRun = true;
          return iface.getSomeInt();
        });
        var derived = UObject.NewObject(new TypeParam<UHaxeDerived2>());
        t1.Execute(derived).should.be(0xf00ba5);
        didRun.should.be(true);
        didRun = false;

        t1.Unbind();
        t1.BindLambda(function(iface:IBasicType2) {
          iface.getSomeInt().should.be(0xf00);
          iface.doSomething().getSomeInt().should.be(0xf00);
          didRun = true;
          return iface.getSomeInt();
        });
        var basic = UObject.NewObject(new TypeParam<UBasicTypesSub2>());
        t1.Execute(basic).should.be(0xf00);
        didRun.should.be(true);
        didRun = false;

        var t2 = FDelTest2.create();
        t2.BindLambda(function(str:FString) {
          str.toString().should.be('hello');
          didRun = true;
          return E_2nd;
        });
        t2.Execute('hello').should.be(E_2nd);
        didRun.should.be(true);
        didRun = false;
        var basic = UBasicTypesUObject.CreateFromCpp();
        basic.stringNonProp = 'hello';
        t2.Execute(basic.stringNonProp).should.be(E_2nd);
        didRun.should.be(true);
        didRun = false;

        var t3 = FDelTest3.create();
        t3.BindLambda(function(sub1:TWeakObjectPtr<UBasicTypesSub1>) {
          didRun = true;
          if(sub1 == null) return SomeEnum2;
          (sub1.stringNonProp.toString() == 'Works').should.be(true);
          return SomeEnum1;
        });
        var basic2 = UObject.NewObject(new TypeParam<UBasicTypesSub1>());
        basic2.stringNonProp = 'Works';
        t3.Execute(basic2).should.be(SomeEnum1);
        didRun.should.be(true);
        didRun = false;
        t3.Execute(null).should.be(SomeEnum2);
        didRun.should.be(true);
        didRun = false;

        var t4 = FDelTest4.create();
        t4.BindLambda(function(d:TWeakObjectPtr<UHaxeDerived2>) {
          didRun = true;
          if(d == null) return 1;
          d.getSomeInt().should.be(0xf00ba5);
          (d.stringNonProp.equals(basic2.stringNonProp).should.be(true));
          (d.stringNonProp.toString() == 'Works').should.be(true);
          return 2;
        });
        derived.stringNonProp = 'Works';
        t4.Execute(derived).should.be(2);
        didRun.should.be(true);
        didRun = false;
        t4.Execute(null).should.be(1);
        didRun.should.be(true);
        didRun = false;

        var t5 = FDelTest5.create();
        t5.BindLambda(function(sub:TSubclassOf<UHaxeDerived1>) {
          didRun = true;
          return sub == null ? 1 : 2;
        });
        t5.Execute(UHaxeDerived1.StaticClass()).should.be(2);
        didRun.should.be(true);
        didRun = false;
        t5.Execute(UBasicTypesSub1.StaticClass()).should.be(1);
        didRun.should.be(true);
        didRun = false;
        t5.Execute(null).should.be(1);
        didRun.should.be(true);
        didRun = false;
      });
    });
  }
}

