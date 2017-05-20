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

using unreal.CoreAPI;

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

typedef FDelHaxeUFun3 = unreal.DynamicMulticastDelegate<FDelHaxeUFun3, PRef<FSimpleUStruct>->Void>;
typedef FDelHaxeUFun3_RV = unreal.DynamicDelegate<FDelHaxeUFun3_RV, PRef<FSimpleUStruct>->Int>;
typedef FDelHaxeUFun4 = unreal.DynamicMulticastDelegate<FDelHaxeUFun4, Const<PRef<FSimpleUStruct>>->Void>;
typedef FDelHaxeUFun4_RV = unreal.DynamicDelegate<FDelHaxeUFun4_RV, Const<PRef<FSimpleUStruct>>->UUsesDelegate>;
typedef FDelHaxeUFun5 = unreal.DynamicDelegate<FDelHaxeUFun5, Float32->Float64->Int32->UInt32->FSimpleUStruct>;

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
  public var test1:DelIntInt;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test2:FDelHaxe2;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test3:FDelHaxe3;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test4:FDelHaxe4;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test5:FDelHaxe5;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test6:FDelHaxe6;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test7:FDelHaxe7;
  @:uproperty(BlueprintAssignable, Category=Game)
  public var test8:FDelHaxe8;

  @:uproperty
  public var testRV:FDelHaxe1_RV;

  public var testCRV:FDelHaxe0_RV;

  public var lastSimpleStruct:FSimpleUStruct;

  public var numCallbacks:Int = 0;
  @:ufunction public function ufun() : Void {
    numCallbacks++;
  }

  @:ufunction public function ufun2(i:Int) : Int {
    numCallbacks += i;
    return numCallbacks;
  }

  @:ufunction public function ufun3(someStruct:PRef<FSimpleUStruct>):Void {
    numCallbacks += 1;
    someStruct.d1 = someStruct.f1;
  }

  @:ufunction public function ufun3_ret(someStruct:PRef<FSimpleUStruct>):Int {
    numCallbacks += 1;
    someStruct.d1 = someStruct.f1;
    return someStruct.i32;
  }

  @:ufunction public function ufun4(someStruct:Const<PRef<FSimpleUStruct>>):Void {
    numCallbacks += 1;
    this.lastSimpleStruct = someStruct.copy();
  }

  @:ufunction public function ufun4_ret(someStruct:Const<PRef<FSimpleUStruct>>):UUsesDelegate {
    numCallbacks += 1;
    this.lastSimpleStruct = someStruct.copy();
    return this;
  }

  @:ufunction public function ufun5(f1:Float32, d1:Float64, i32:Int32, ui32:UInt32):FSimpleUStruct {
    numCallbacks += 1;
    return FSimpleUStruct.createWithArgs(f1, d1, i32, ui32);
  }
}

class TestDelegates extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Delegates', {
      cpp.vm.Gc.run(true);
      cpp.vm.Gc.run(true);
      var nDestructors = FSimpleUStruct.nDestructorCalled,
          nCreated = FSimpleUStruct.nConstructorCalled + FSimpleUStruct.nCopyConstructorCalled;
      inline function check(dif:Int, ?pos:haxe.PosInfos) {
        var difDestruct = FSimpleUStruct.nDestructorCalled - nDestructors,
            difCreated = FSimpleUStruct.nConstructorCalled + FSimpleUStruct.nCopyConstructorCalled - nCreated;
        (difCreated - difDestruct).should.be(dif);
        nDestructors = FSimpleUStruct.nDestructorCalled;
        nCreated = FSimpleUStruct.nConstructorCalled + FSimpleUStruct.nCopyConstructorCalled;
      }
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
#if (!cppia && !WITH_CPPIA)
        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.numCallbacks.should.be(0);
        del.AddUObject(obj, MethodPointer.fromMethod(obj.ufun));
        del.Broadcast();
        obj.numCallbacks.should.be(1);
#end

        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.numCallbacks.should.be(0);
        del.AddUFunction(obj.ufun);
        del.Broadcast();
        obj.numCallbacks.should.be(1);

        var del = FDelHaxe0.create();
        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.numCallbacks.should.be(0);
        del.AddDynamic(obj.ufun);
        del.Broadcast();
        obj.numCallbacks.should.be(1);

        var del = FDelHaxe1_RV.create();
        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        obj.numCallbacks.should.be(0);
        obj.ufun2(10);
        del.BindDynamic(obj.ufun2);
        del.IsBound().should.be(true);
        del.Execute(1).should.be(11);
        obj.numCallbacks.should.be(11);
        del.Execute(10).should.be(21);
        obj.numCallbacks.should.be(21);

        function run() {
          var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
          obj.numCallbacks.should.be(0);
          var del = new FDelHaxeUFun3();
          del.AddDynamic(obj.ufun3);
          var simple = FSimpleUStruct.create();
          simple.f1 = 10;
          simple.d1.should.be(0);
          del.Broadcast(simple);
          obj.numCallbacks.should.be(1);
          simple.d1.should.be(10);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(0); // the same amount of constructors and destructors are called

        function run() {
          var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
          obj.numCallbacks.should.be(0);
          var del = new FDelHaxeUFun3_RV();
          del.BindDynamic(obj.ufun3_ret);
          var simple = FSimpleUStruct.create();
          simple.f1 = 22.2;
          simple.i32 = 100;
          simple.d1.should.be(0);
          del.Execute(simple).should.be(100);
          obj.numCallbacks.should.be(1);
          simple.d1.should.beCloseTo(22.2);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(0); // the same amount of constructors and destructors are called

        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        function run() {
          obj.numCallbacks.should.be(0);
          var del = new FDelHaxeUFun4();
          del.AddDynamic(obj.ufun4);
          var simple = FSimpleUStruct.create();
          simple.f1 = 30;
          simple.d1 = 40;
          simple.i32 = 50;
          simple.ui32 = 60;
          del.Broadcast(simple);
          obj.numCallbacks.should.be(1);
          obj.lastSimpleStruct.f1.should.be(30);
          obj.lastSimpleStruct.d1.should.be(40);
          obj.lastSimpleStruct.i32.should.be(50);
          obj.lastSimpleStruct.ui32.should.be(60);
        }
        run();
        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(1);

        function run() {
          obj.lastSimpleStruct.f1.should.be(30);
          obj.lastSimpleStruct = null;
        }
        run();

        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(-1); // make it up for the last destructor

        var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
        function run() {
          obj.numCallbacks.should.be(0);
          var del = new FDelHaxeUFun4_RV();
          del.BindDynamic(obj.ufun4_ret);
          var simple = FSimpleUStruct.create();
          simple.f1 = 22.2;
          simple.i32 = 100;
          simple.d1.should.be(0);
          del.Execute(simple).should.be(obj);
          obj.numCallbacks.should.be(1);
        }
        run();
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(1);

        function run() {
          obj.lastSimpleStruct.f1.should.beCloseTo(22.2);
          obj.lastSimpleStruct = null;
        }
        run();

        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(-1); // make it up for the last destructor

        var simple = null;
        function run() {
          var obj = UObject.NewObject(new TypeParam<UUsesDelegate>());
          obj.numCallbacks.should.be(0);
          var del = new FDelHaxeUFun5();
          del.BindDynamic(obj.ufun5);
          simple = del.Execute(1.1, 2.2, 3, 4);
          obj.numCallbacks.should.be(1);
          simple.f1.should.beCloseTo(1.1);
          simple.d1.should.beCloseTo(2.2);
          simple.i32.should.beCloseTo(3);
          simple.ui32.should.beCloseTo(4);
        }
        run();
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(1);

        function run() {
          simple.f1.should.beCloseTo(1.1);
          simple.d1.should.beCloseTo(2.2);
          simple.i32.should.beCloseTo(3);
          simple.ui32.should.beCloseTo(4);
          simple = null;
        }
        run();

        // run twice to make sure that the finalizers run
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);

        check(-1); // make it up for the last destructor
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

