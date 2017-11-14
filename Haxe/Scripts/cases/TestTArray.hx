package cases;
import unreal.*;
import cases.TestUEnum;
import cases.TestUObjectOverrides;
import NonUObject;
import helpers.TestHelper;
import cases.TestUObjectOverrides;
import haxeunittests.EMyCppEnum;
import haxeunittests.EMyEnum;
import haxeunittests.EMyNamespacedEnum;
import haxeunittests.*;

using buddy.Should;

class TestTArray extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - TArray', {
      it('should be able to use TArray of basic types',{
        var arr:TArray<Int32> = TArrayImpl.create();
        for (i in 0...10) {
          arr.push(i+1);
        }
        for (i in 0...10) {
          arr[i].should.be(i+1);
        }
        var count = 0;

        for (i in arr) {
          i.should.be(++count);
        }

        arr.sort(function(a,b) return b - a);
        for (i in 0...10) {
          arr[i].should.be(10-i);
        }

        arr[0] = 77;
        arr[0].should.be(77);
        arr.length.should.be(10);

        var arr = TArray.fromIterable([6,3,4,4,7,8,1,1,5,4]);
        arr.sort(Reflect.compare);
        var shouldBe = [1,1,3,4,4,4,5,6,7,8];
        for (i in 0...shouldBe.length) {
          arr[i].should.be(shouldBe[i]);
        }
        arr.length.should.be(shouldBe.length);

        var arr:TArray<Float64> = TArrayImpl.create();
        for (i in 0...10) {
          arr.push(i+1 + (i+1) / 10);
        }
        for (i in 0...10) {
          arr[i].should.be(i+1 + (i + 1) / 10);
        }

        var arr:TArray<Float32> = TArrayImpl.create();
        for (i in 0...10) {
          arr.push(i+1 + (i+1) / 10);
        }
        for (i in 0...10) {
          arr[i].should.beCloseTo(i+1 + (i + 1) / 10);
        }
      });
      it('should be able to use TArray of uclass types', {
        var arr = TArray.fromIterable([ for (i in 0...10) UBasicTypesUObject.CreateFromCpp() ]);
        for (i in 0...10) {
          arr[i].i32Prop = 9 - i;
        }
        for (i in 0...10) {
          arr[i].i32Prop.should.be(9 - i);
        }
        arr.sort(function(s1,s2) return s1.i32Prop - s2.i32Prop);
        for (i in 0...10) {
          arr[i].i32Prop.should.be(i);
        }
        arr.sort(function(s1,s2) return s1.i32Prop - s2.i32Prop);
        for (i in 0...10) {
          arr[i].i32Prop.should.be(i);
        }
        arr.sort(function(s1,s2) return Std.random(2) - 1);
        arr.sort(function(s1,s2) return s2.i32Prop - s1.i32Prop);
        for (i in 0...10) {
          arr[i].i32Prop.should.be(9 - i);
        }

        var arr = TArray.fromIterable([ for (i in 0...3) UHaxeDerived2.create() ]);
        arr[0].intProp = 0;
        arr[0].stringProp = 'db';
        arr[1].intProp = 123;
        arr[1].stringProp = 'p';
        arr[2].intProp = 0;
        arr[2].stringProp = 'dy';
        arr.sort(function(a,b) {
          if (a.intProp != b.intProp) {
            return b.intProp - a.intProp;
          }
          // return Reflect.compare(a.stringProp.toString(), b.stringProp.toString());
          var compare = b.stringProp.toString() > a.stringProp.toString() ? -1 : 1;
          return compare;
        });
        arr[0].stringProp.toString().should.be('p');
        arr[1].stringProp.toString().should.be('db');
        arr[2].stringProp.toString().should.be('dy');
      });
      it('should be able to use TArray of structs', {
        function run() {
          var arr = TArray.create(new TypeParam<FSimpleStruct>());
          for (i in 0...4) {
            var val = FSimpleStruct.create();
            val.i32 = 3 - i;
            arr.push(val);
          }
          for (i in 0...4) {
            var val = arr[i];
            val.i32.should.be(3-i);
          }

          arr.sort(function(s1, s2) return s1.i32 - s2.i32);
          for (i in 0...4) {
            arr[i].i32.should.be(i);
          }

          var arr = TArray.fromIterable([for (i in 0...5) FSimpleStruct.create()]);
          for (i in 0...4) {
            arr[i].i32 = 3 - i;
          }
          for (i in 0...4) {
            var val = arr[i];
            val.i32.should.be(3-i);
          }

          var arr = TArray.fromIterable(new TypeParam<FSimpleStruct>(), [for (i in 0...5) FSimpleStruct.create()]);
          for (i in 0...4) {
            arr[i].i32 = 3 - i;
          }
          for (i in 0...4) {
            var val = arr[i];
            val.i32.should.be(3-i);
          }
        }
        run();
        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);
      });
      it('should be able to use TArray as member of extern uclass types');
      it('should be able to use TArray as member of declared uclass types (UPROPERTY)', {
        var str:FString;
        function run() {
          var obj = UObject.NewObject(new TypeParam<UTestTArray>(), UObject.GetTransientPackage(), UTestTArray.StaticClass());
          obj.array.Push("Hello from Haxe!");
          obj.array.length.should.be(1);
          obj.array[0].toString().should.be("Hello from Haxe!");
          obj.array.indexOf("Hello from Haxe!").should.be(0);
          obj.array.indexOf("").should.be(-1);
          str = obj.array.Pop(false);
          obj.array.length.should.be(0);
          obj.array.Push("Test");
          obj.array.length.should.be(1);

          var obj = UObject.NewObject(new TypeParam<UTestTArray2>(), UObject.GetTransientPackage(), UTestTArray2.StaticClass());
          obj.enumArray1.push(CppEnum2);
          obj.enumArray1[0].should.be(CppEnum2);
          obj.enumArray1.push(CppEnum3);
          obj.enumArray1[0].should.be(CppEnum2);
          obj.enumArray1[1].should.be(CppEnum3);
          UTestTArray2.setArrayInCpp(obj.enumArray1, CppEnum1);
          UTestTArray2.setArrayInCpp(obj.enumArray1, CppEnum3);
          obj.enumArray1[2].should.be(CppEnum1);
          obj.enumArray1[3].should.be(CppEnum3);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 0).should.be(CppEnum2);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 1).should.be(CppEnum3);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 2).should.be(CppEnum1);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 3).should.be(CppEnum3);
          obj.enumArray1.pop().should.be(CppEnum3);
          obj.enumArray1.pop().should.be(CppEnum1);

          obj.enumArray2.push(E_2nd);
          obj.enumArray2[0].should.be(E_2nd);
          obj.enumArray2.push(E_3rd);
          obj.enumArray2[0].should.be(E_2nd);
          obj.enumArray2[1].should.be(E_3rd);
          UTestTArray2.setArrayInCpp2(obj.enumArray2, E_1st);
          UTestTArray2.setArrayInCpp2(obj.enumArray2, E_3rd);
          obj.enumArray2[2].should.be(E_1st);
          obj.enumArray2[3].should.be(E_3rd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 0).should.be(E_2nd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 1).should.be(E_3rd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 2).should.be(E_1st);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 3).should.be(E_3rd);
          obj.enumArray2.pop().should.be(E_3rd);
          obj.enumArray2.pop().should.be(E_1st);

          var basicType =  UBasicTypesUObject.CreateFromCpp();
          obj.objArray1.push(basicType);
          Std.is(obj.objArray1[0], UBasicTypesUObject).should.be(true);
          (obj.objArray1[0].getSelf() == basicType).should.be(true);
          obj.objArray1[0].getSomeNumber().should.be(42);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.objArray1.push(sub1);
          Std.is(obj.objArray1[1], UBasicTypesSub1).should.be(true);
          (obj.objArray1[1].getSelf() == sub1).should.be(true);
          obj.objArray1[1].getSomeNumber().should.be(43);

          var derived = UHaxeDerived1.create();
          obj.objArray1.push(derived);
          (obj.objArray1[2].getSelf() == derived).should.be(true);
          obj.objArray1[2].i32Prop = 22;
          obj.objArray1[2].getSomeNumber().should.be(220);
          obj.objArray1.pop().getSomeNumber().should.be(220);
          derived.getSomeNumber().should.be(220);

          var derived = UHaxeDerived1.create();
          obj.objArray2.push(derived);
          (obj.objArray2[0].getSelf() == derived).should.be(true);
          obj.objArray2[0].i32Prop = 23;
          obj.objArray2[0].getSomeNumber().should.be(230);
          obj.objArray2.pop().getSomeNumber().should.be(230);

          #if (pass >= 2)
          var obj = UObject.NewObject(new TypeParam<UTestScriptTArray2>(), UObject.GetTransientPackage(), UTestScriptTArray2.StaticClass());
          obj.enumArray1.push(CppEnum2);
          obj.enumArray1[0].should.be(CppEnum2);
          obj.enumArray1.push(CppEnum3);
          obj.enumArray1[0].should.be(CppEnum2);
          obj.enumArray1[1].should.be(CppEnum3);
          UTestTArray2.setArrayInCpp(obj.enumArray1, CppEnum1);
          UTestTArray2.setArrayInCpp(obj.enumArray1, CppEnum3);
          obj.enumArray1[2].should.be(CppEnum1);
          obj.enumArray1[3].should.be(CppEnum3);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 0).should.be(CppEnum2);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 1).should.be(CppEnum3);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 2).should.be(CppEnum1);
          UTestTArray2.getArrayInCpp(obj.enumArray1, 3).should.be(CppEnum3);
          obj.enumArray1.pop().should.be(CppEnum3);
          obj.enumArray1.pop().should.be(CppEnum1);

          obj.enumArray2.push(E_2nd);
          obj.enumArray2[0].should.be(E_2nd);
          obj.enumArray2.push(E_3rd);
          obj.enumArray2[0].should.be(E_2nd);
          obj.enumArray2[1].should.be(E_3rd);
          UTestTArray2.setArrayInCpp2(obj.enumArray2, E_1st);
          UTestTArray2.setArrayInCpp2(obj.enumArray2, E_3rd);
          obj.enumArray2[2].should.be(E_1st);
          obj.enumArray2[3].should.be(E_3rd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 0).should.be(E_2nd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 1).should.be(E_3rd);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 2).should.be(E_1st);
          UTestTArray2.getArrayInCpp2(obj.enumArray2, 3).should.be(E_3rd);
          obj.enumArray2.pop().should.be(E_3rd);
          obj.enumArray2.pop().should.be(E_1st);

          var basicType =  UBasicTypesUObject.CreateFromCpp();
          obj.objArray1.push(basicType);
          Std.is(obj.objArray1[0], UBasicTypesUObject).should.be(true);
          (obj.objArray1[0].getSelf() == basicType).should.be(true);
          obj.objArray1[0].getSomeNumber().should.be(42);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.objArray1.push(sub1);
          Std.is(obj.objArray1[1], UBasicTypesSub1).should.be(true);
          (obj.objArray1[1].getSelf() == sub1).should.be(true);
          obj.objArray1[1].getSomeNumber().should.be(43);

          var derived = UHaxeDerived1.create();
          obj.objArray1.push(derived);
          (obj.objArray1[2].getSelf() == derived).should.be(true);
          obj.objArray1[2].i32Prop = 22;
          obj.objArray1[2].getSomeNumber().should.be(220);
          derived.getSomeNumber().should.be(220);

          obj.objArray2.push(derived);
          (obj.objArray2[0].getSelf() == derived).should.be(true);
          obj.objArray2[0].i32Prop = 23;
          obj.objArray2[0].getSomeNumber().should.be(230);
          obj.objArray2.pop().getSomeNumber().should.be(230);
          #end
        }
        run();

        cpp.vm.Gc.run(true);
        cpp.vm.Gc.run(true);
        // str.toString().should.be("Hello from Haxe!");
      });
      it('should be able to use indexOf structs', {
        var basic = UBasicTypesUObject.CreateFromCpp();
        var arr = TArray.create(new TypeParam<FString>());
        // fstring has == defined
        arr.Push("Hello, World!");
        basic.stringNonProp = "Testing";
        arr.Push(basic.stringNonProp);
        arr[0].toString().should.be('Hello, World!');
        arr[1].toString().should.be('Testing');
        arr.indexOf('?').should.be(-1);
        arr.indexOf('Hello, World!').should.be(0);
        arr.indexOf(basic.stringNonProp).should.be(1);
        arr.indexOf('Testing').should.be(1);

        arr.sort(function(s1,s2) return -Reflect.compare(s1.toString(), s2.toString()));
        arr[0].toString().should.be('Testing');
        arr[1].toString().should.be('Hello, World!');
        arr.indexOf(basic.stringNonProp).should.be(0);
        arr.indexOf('Testing').should.be(0);

        var arr = TArray.create(new TypeParam<Int>());
        arr.Push(11);
        arr.Push(42);
        arr.indexOf(0).should.be(-1);
        arr.indexOf(11).should.be(0);
        arr.indexOf(42).should.be(1);
      });
      it('should be able to use TArray on structs');
    });
  }
}

@:uclass
class UTestTArray extends UObject {
  @:uproperty
  public var array:TArray<FString>;
}

@:uclass class UTestTArray2 extends UObject {
  @:uproperty
  public var enumArray1:TArray<EMyCppEnum>;
  @:uproperty
  public var enumArray2:TArray<ETestHxEnumClass>;

  @:uexpose public static function setArrayInCpp(arr:TArray<EMyCppEnum>, val:EMyCppEnum) {
    arr.push(val);
  }

  @:uexpose public static function getArrayInCpp(arr:TArray<EMyCppEnum>, idx:Int):EMyCppEnum {
    return arr[idx];
  }

  @:uexpose public static function setArrayInCpp2(arr:TArray<ETestHxEnumClass>, val:ETestHxEnumClass) {
    arr.Push(val);
  }

  @:uexpose public static function getArrayInCpp2(arr:TArray<ETestHxEnumClass>, idx:Int):ETestHxEnumClass {
    return arr[idx];
  }

  @:uproperty
  public var objArray1:TArray<UBasicTypesUObject>;

  @:uproperty
  public var objArray2:TArray<UHaxeDerived1>;
}

#if (pass >= 2)
@:uclass class UTestScriptTArray2 extends UObject {
  @:uproperty
  public var enumArray1:TArray<EMyCppEnum>;
  @:uproperty
  public var enumArray2:TArray<ETestHxEnumClass>;

  @:uproperty
  public var objArray1:TArray<UBasicTypesUObject>;

  @:uproperty
  public var objArray2:TArray<UHaxeDerived1>;
}
#end