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
    describe('Haxe - TArray / TMap / TSet', {
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
          obj.enumArray1[0].should.equal(CppEnum2);
          obj.enumArray1.push(CppEnum3);
          obj.enumArray1[0].should.equal(CppEnum2);
          obj.enumArray1[1].should.equal(CppEnum3);
          UTestTArray2.setArray(obj.enumArray1, CppEnum1);
          UTestTArray2.setArray(obj.enumArray1, CppEnum3);
          obj.enumArray1[2].should.equal(CppEnum1);
          obj.enumArray1[3].should.equal(CppEnum3);
          UTestTArray2.getArray(obj.enumArray1, 0).should.equal(CppEnum2);
          UTestTArray2.getArray(obj.enumArray1, 1).should.equal(CppEnum3);
          UTestTArray2.getArray(obj.enumArray1, 2).should.equal(CppEnum1);
          UTestTArray2.getArray(obj.enumArray1, 3).should.equal(CppEnum3);
          obj.enumArray1.pop().should.equal(CppEnum3);
          obj.enumArray1.pop().should.equal(CppEnum1);

          obj.enumArray2.push(E_2nd);
          obj.enumArray2[0].should.equal(E_2nd);
          obj.enumArray2.push(E_3rd);
          obj.enumArray2[0].should.equal(E_2nd);
          obj.enumArray2[1].should.equal(E_3rd);
          UTestTArray2.setArray2(obj.enumArray2, E_1st);
          UTestTArray2.setArray2(obj.enumArray2, E_3rd);
          obj.enumArray2[2].should.equal(E_1st);
          obj.enumArray2[3].should.equal(E_3rd);
          UTestTArray2.getArray2(obj.enumArray2, 0).should.equal(E_2nd);
          UTestTArray2.getArray2(obj.enumArray2, 1).should.equal(E_3rd);
          UTestTArray2.getArray2(obj.enumArray2, 2).should.equal(E_1st);
          UTestTArray2.getArray2(obj.enumArray2, 3).should.equal(E_3rd);
          obj.enumArray2.pop().should.equal(E_3rd);
          obj.enumArray2.pop().should.equal(E_1st);

          var basicType =  UBasicTypesUObject.CreateFromCpp();
          obj.objArray1.push(basicType);
          Std.is(obj.objArray1[0], UBasicTypesUObject).should.be(true);
          (obj.objArray1[0].getSelf() == basicType).should.be(true);
          obj.objArray1[0].getSomeNumber().should.be(42);

          obj.weakArray.push(basicType);
          Std.is(obj.weakArray[0], UBasicTypesUObject).should.be(true);
          (obj.weakArray[0].getSelf() == basicType).should.be(true);
          obj.weakArray[0].getSomeNumber().should.be(42);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.objArray1.push(sub1);
          Std.is(obj.objArray1[1], UBasicTypesSub1).should.be(true);
          (obj.objArray1[1].getSelf() == sub1).should.be(true);
          obj.objArray1[1].getSomeNumber().should.be(43);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.weakArray.push(sub1);
          Std.is(obj.weakArray[1], UBasicTypesSub1).should.be(true);
          (obj.weakArray[1].getSelf() == sub1).should.be(true);
          obj.weakArray[1].getSomeNumber().should.be(43);

          var derived = UHaxeDerived1.create();
          obj.objArray1.push(derived);
          (obj.objArray1[2].getSelf() == derived).should.be(true);
          obj.objArray1[2].i32Prop = 22;
          obj.objArray1[2].getSomeNumber().should.be(220);
          obj.objArray1.pop().getSomeNumber().should.be(220);
          derived.getSomeNumber().should.be(220);

          var derived = UHaxeDerived1.create();
          obj.weakArray.push(derived);
          (obj.weakArray[2].getSelf() == derived).should.be(true);
          obj.weakArray[2].i32Prop = 22;
          obj.weakArray[2].getSomeNumber().should.be(220);
          obj.weakArray.pop().getSomeNumber().should.be(220);
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
          obj.enumArray1[0].should.equal(CppEnum2);
          obj.enumArray1.push(CppEnum3);
          obj.enumArray1[0].should.equal(CppEnum2);
          obj.enumArray1[1].should.equal(CppEnum3);
          UTestTArray2.setArray(obj.enumArray1, CppEnum1);
          UTestTArray2.setArray(obj.enumArray1, CppEnum3);
          obj.enumArray1[2].should.equal(CppEnum1);
          obj.enumArray1[3].should.equal(CppEnum3);
          UTestTArray2.getArray(obj.enumArray1, 0).should.equal(CppEnum2);
          UTestTArray2.getArray(obj.enumArray1, 1).should.equal(CppEnum3);
          UTestTArray2.getArray(obj.enumArray1, 2).should.equal(CppEnum1);
          UTestTArray2.getArray(obj.enumArray1, 3).should.equal(CppEnum3);
          obj.enumArray1.pop().should.equal(CppEnum3);
          obj.enumArray1.pop().should.equal(CppEnum1);

          obj.enumArray2.push(E_2nd);
          obj.enumArray2[0].should.equal(E_2nd);
          obj.enumArray2.push(E_3rd);
          obj.enumArray2[0].should.equal(E_2nd);
          obj.enumArray2[1].should.equal(E_3rd);
          UTestTArray2.setArray2(obj.enumArray2, E_1st);
          UTestTArray2.setArray2(obj.enumArray2, E_3rd);
          obj.enumArray2[2].should.equal(E_1st);
          obj.enumArray2[3].should.equal(E_3rd);
          UTestTArray2.getArray2(obj.enumArray2, 0).should.equal(E_2nd);
          UTestTArray2.getArray2(obj.enumArray2, 1).should.equal(E_3rd);
          UTestTArray2.getArray2(obj.enumArray2, 2).should.equal(E_1st);
          UTestTArray2.getArray2(obj.enumArray2, 3).should.equal(E_3rd);
          obj.enumArray2.pop().should.equal(E_3rd);
          obj.enumArray2.pop().should.equal(E_1st);

          var basicType =  UBasicTypesUObject.CreateFromCpp();
          obj.objArray1.push(basicType);
          Std.is(obj.objArray1[0], UBasicTypesUObject).should.be(true);
          (obj.objArray1[0].getSelf() == basicType).should.be(true);
          obj.objArray1[0].getSomeNumber().should.be(42);

          var basicType =  UBasicTypesUObject.CreateFromCpp();
          obj.weakArray.push(basicType);
          Std.is(obj.weakArray[0], UBasicTypesUObject).should.be(true);
          (obj.weakArray[0].getSelf() == basicType).should.be(true);
          obj.weakArray[0].getSomeNumber().should.be(42);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.objArray1.push(sub1);
          Std.is(obj.objArray1[1], UBasicTypesSub1).should.be(true);
          (obj.objArray1[1].getSelf() == sub1).should.be(true);
          obj.objArray1[1].getSomeNumber().should.be(43);

          var sub1 = UBasicTypesSub1.CreateFromCpp();
          obj.weakArray.push(sub1);
          Std.is(obj.weakArray[1], UBasicTypesSub1).should.be(true);
          (obj.weakArray[1].getSelf() == sub1).should.be(true);
          obj.weakArray[1].getSomeNumber().should.be(43);

          var derived = UHaxeDerived1.create();
          obj.objArray1.push(derived);
          (obj.objArray1[2].getSelf() == derived).should.be(true);
          obj.objArray1[2].i32Prop = 22;
          obj.objArray1[2].getSomeNumber().should.be(220);
          derived.getSomeNumber().should.be(220);

          var derived = UHaxeDerived1.create();
          obj.weakArray.push(derived);
          (obj.weakArray[2].getSelf() == derived).should.be(true);
          obj.weakArray[2].i32Prop = 22;
          obj.weakArray[2].getSomeNumber().should.be(220);
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
      it('should be able to use sort and indexOf in structs', {
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
      it('should be able to access TSet types', {
        var obj = UObject.NewObject(new TypeParam<UTestTArray>(), UObject.GetTransientPackage(), UTestTArray.StaticClass());
#if (pass >= 2)
        var obj2 = UObject.NewObject(new TypeParam<UTestScriptTArray2>(), UObject.GetTransientPackage(), UTestScriptTArray2.StaticClass());
#else
        var obj2 = UObject.NewObject(new TypeParam<UTestTArray>(), UObject.GetTransientPackage(), UTestTArray.StaticClass());
#end
        for (s in [obj.set, ReflectAPI.callMethod(obj, "ufuncGet_set", []), obj2.set, ReflectAPI.callMethod(obj2, "ufuncGet_set", []), TSet.create(new TypeParam<FString>())]) {
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);
          var t1 = s.Add("Test");
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
          var scpy = s.copy();
          var t2 = s.Add("Test2");
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(true);
          s.Remove(t1);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(true);
          s.Remove(t2);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);

          scpy.Contains("Test").should.be(true);
          scpy.Contains("Test2").should.be(false);
          s.assign(scpy);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
        }
        for (s in [obj.set2, ReflectAPI.callMethod(obj, "ufuncGet_set2", []), obj2.set2, ReflectAPI.callMethod(obj2, "ufuncGet_set2", []), TSet.create(new TypeParam<Int>())]) {
          s.Contains(42).should.be(false);
          s.Contains(101).should.be(false);
          var t1 = s.Add(42);
          s.Contains(42).should.be(true);
          s.Contains(101).should.be(false);
          var scpy = s.copy();
          var t2 = s.Add(101);
          s.Contains(42).should.be(true);
          s.Contains(101).should.be(true);
          s.Remove(t1);
          s.Contains(42).should.be(false);
          s.Contains(101).should.be(true);
          s.Remove(t2);
          s.Contains(42).should.be(false);
          s.Contains(101).should.be(false);

          scpy.Contains(42).should.be(true);
          scpy.Contains(101).should.be(false);
          s.assign(scpy);
          s.Contains(42).should.be(true);
          s.Contains(101).should.be(false);
        }

        var obj = UObject.NewObject(new TypeParam<UTestTArray2>(), UObject.GetTransientPackage(), UTestTArray2.StaticClass());
#if (pass >= 2)
        var obj2 = UObject.NewObject(new TypeParam<UTestScriptTArray2>(), UObject.GetTransientPackage(), UTestScriptTArray2.StaticClass());
#else
        var obj2 = UObject.NewObject(new TypeParam<UTestTArray2>(), UObject.GetTransientPackage(), UTestTArray2.StaticClass());
#end

       var i = 0;
       for (s in [obj.enumSet1, ReflectAPI.callMethod(obj, "ufuncGet_enumSet1", []), obj2.enumSet1, ReflectAPI.callMethod(obj2, "ufuncGet_enumSet1", []), TSet.create(new TypeParam<EMyCppEnum>())]) {
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum3).should.be(false);
          var t1 = s.Add(CppEnum2);
          s.Contains(CppEnum2).should.be(true);
          s.Contains(CppEnum3).should.be(false);
          var scpy = s.copy();
          var t2 = s.Add(CppEnum3);
          s.Contains(CppEnum2).should.be(true);
          s.Contains(CppEnum3).should.be(true);
          s.Remove(t1);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum3).should.be(true);
          s.Remove(t2);
          var t3 = s.Add(CppEnum1);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum3).should.be(false);
          s.Contains(CppEnum1).should.be(true);
          s.Remove(t3);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum3).should.be(false);
          s.Contains(CppEnum1).should.be(false);

          scpy.Contains(CppEnum2).should.be(true);
          scpy.Contains(CppEnum3).should.be(false);
          s.assign(scpy);
          s.Contains(CppEnum2).should.be(true);
          s.Contains(CppEnum3).should.be(false);
       }

       for (s in [obj.enumSet2, ReflectAPI.callMethod(obj, "ufuncGet_enumSet2", []), obj2.enumSet2, ReflectAPI.callMethod(obj2, "ufuncGet_enumSet2", []), TSet.create(new TypeParam<ETestHxEnumClass>())]) {
          s.Contains(E_1st).should.be(false);
          s.Contains(E_3rd).should.be(false);
          var t1 = s.Add(E_1st);
          s.Contains(E_1st).should.be(true);
          s.Contains(E_3rd).should.be(false);
          var scpy = s.copy();
          var t2 = s.Add(E_3rd);
          s.Contains(E_1st).should.be(true);
          s.Contains(E_3rd).should.be(true);
          s.Remove(t1);
          s.Contains(E_1st).should.be(false);
          s.Contains(E_3rd).should.be(true);
          s.Remove(t2);
          var t3 = s.Add(E_2nd);
          s.Contains(E_1st).should.be(false);
          s.Contains(E_3rd).should.be(false);
          s.Contains(E_2nd).should.be(true);
          s.Remove(t3);
          s.Contains(E_1st).should.be(false);
          s.Contains(E_3rd).should.be(false);
          s.Contains(E_2nd).should.be(false);

          scpy.Contains(E_1st).should.be(true);
          scpy.Contains(E_3rd).should.be(false);
          s.assign(scpy);
          s.Contains(E_1st).should.be(true);
          s.Contains(E_3rd).should.be(false);
       }

       for (s in [obj.objSet1, ReflectAPI.callMethod(obj, "ufuncGet_objSet1", []), obj2.objSet1, ReflectAPI.callMethod(obj2, "ufuncGet_objSet1", []), TSet.create(new TypeParam<UBasicTypesUObject>())]) {
          var obj1 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());
          var obj2 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());
          var obj3 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());

          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          var t1 = s.Add(obj1);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(false);
          var scpy = s.copy();
          var t2 = s.Add(obj2);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(true);
          s.Remove(t1);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(true);
          s.Remove(t2);
          var t3 = s.Add(obj3);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          s.Contains(obj3).should.be(true);
          s.Remove(t3);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          s.Contains(obj3).should.be(false);

          scpy.Contains(obj1).should.be(true);
          scpy.Contains(obj2).should.be(false);
          s.assign(scpy);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(false);
       }

       for (s in [obj.objSet2, ReflectAPI.callMethod(obj, "ufuncGet_objSet2", []), obj2.objSet2, ReflectAPI.callMethod(obj2, "ufuncGet_objSet2", []), TSet.create(new TypeParam<UHaxeDerived1>())]) {
          var obj1 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());
          var obj2 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());
          var obj3 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());

          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          var t1 = s.Add(obj1);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(false);
          var scpy = s.copy();
          var t2 = s.Add(obj2);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(true);
          s.Remove(t1);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(true);
          s.Remove(t2);
          var t3 = s.Add(obj3);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          s.Contains(obj3).should.be(true);
          s.Remove(t3);
          s.Contains(obj1).should.be(false);
          s.Contains(obj2).should.be(false);
          s.Contains(obj3).should.be(false);

          scpy.Contains(obj1).should.be(true);
          scpy.Contains(obj2).should.be(false);
          s.assign(scpy);
          s.Contains(obj1).should.be(true);
          s.Contains(obj2).should.be(false);
       }
      });
      it('should be able to access TMap types', {
        var obj = UObject.NewObject(new TypeParam<UTestTArray>(), UObject.GetTransientPackage(), UTestTArray.StaticClass());
#if (pass >= 2)
        var obj2 = UObject.NewObject(new TypeParam<UTestScriptTArray2>(), UObject.GetTransientPackage(), UTestScriptTArray2.StaticClass());
#else
        var obj2 = UObject.NewObject(new TypeParam<UTestTArray>(), UObject.GetTransientPackage(), UTestTArray.StaticClass());
#end
        for (s in [obj.map, ReflectAPI.callMethod(obj, "ufuncGet_map", []), obj2.map, ReflectAPI.callMethod(obj2, "ufuncGet_map", []), TMap.create(new TypeParam<FString>(), new TypeParam<FString>())]) {
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);
          s.Add("Test", "10");
          s.Contains("Test").should.be(true);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains("Test2").should.be(false);
          s["Test"].toString().should.be("10");
          var scpy = s.copy();
          s.Add("Test2", '3');
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10", "3"]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(true);
          s["Test"] = "22";
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["22", "3"]);
          [ for (key in s.GenerateKeyArray()) s[key].toString() ].should.containExactly(["22", "3"]);
          s.Remove("Test");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test2"]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["3"]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(true);
          s.Remove("Test2");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in scpy.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          scpy.Contains("Test").should.be(true);
          scpy.Contains("Test2").should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
        }

        for (s in [obj.map2, ReflectAPI.callMethod(obj, "ufuncGet_map2", []), obj2.map2, ReflectAPI.callMethod(obj2, "ufuncGet_map2", []), TMap.create(new TypeParam<Int>(), new TypeParam<FString>())]) {
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(25).should.be(false);
          s.Contains(5).should.be(false);
          s.Add(25, "10");
          s.Contains(25).should.be(true);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([25]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(5).should.be(false);
          s[25].toString().should.be("10");
          var scpy = s.copy();
          s.Add(5, '3');
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([25, 5]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10", "3"]);
          s.Contains(25).should.be(true);
          s.Contains(5).should.be(true);
          s[25] = "22";
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([25, 5]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["22", "3"]);
          [ for (key in s.GenerateKeyArray()) s[key].toString() ].should.containExactly(["22", "3"]);
          s.Remove(25);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([5]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["3"]);
          s.Contains(25).should.be(false);
          s.Contains(5).should.be(true);
          s.Remove(5);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(25).should.be(false);
          s.Contains(5).should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key ].should.containExactly([25]);
          [ for (val in scpy.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          scpy.Contains(25).should.be(true);
          scpy.Contains(5).should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([25]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(25).should.be(true);
          s.Contains(5).should.be(false);
        }

        for (s in [obj.map3, ReflectAPI.callMethod(obj, "ufuncGet_map3", []), obj2.map3, ReflectAPI.callMethod(obj2, "ufuncGet_map3", []), TMap.create(new TypeParam<FString>(), new TypeParam<Int>())]) {
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);
          s.Add("Test", 10);
          s.Contains("Test").should.be(true);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([10]);
          s.Contains("Test2").should.be(false);
          s["Test"].should.be(10);
          var scpy = s.copy();
          s.Add("Test2", 3);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([10, 3]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(true);
          s["Test"] = 22;
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([22, 3]);
          [ for (key in s.GenerateKeyArray()) s[key] ].should.containExactly([22, 3]);
          s.Remove("Test");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([3]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(true);
          s.Remove("Test2");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in scpy.GenerateValueArray()) val ].should.containExactly([10]);
          scpy.Contains("Test").should.be(true);
          scpy.Contains("Test2").should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([10]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
        }

        var obj = UObject.NewObject(new TypeParam<UTestTArray2>(), UObject.GetTransientPackage(), UTestTArray2.StaticClass());
#if (pass >= 2)
        var obj2 = UObject.NewObject(new TypeParam<UTestScriptTArray2>(), UObject.GetTransientPackage(), UTestScriptTArray2.StaticClass());
#else
        var obj2 = UObject.NewObject(new TypeParam<UTestTArray2>(), UObject.GetTransientPackage(), UTestTArray2.StaticClass());
#end

       for (s in [obj.enumMap, ReflectAPI.callMethod(obj, "ufuncGet_enumMap", []), obj2.enumMap, ReflectAPI.callMethod(obj2, "ufuncGet_enumMap", []), TMap.create(new TypeParam<EMyCppEnum>(), new TypeParam<FString>())]) {
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum1).should.be(false);
          s.Add(CppEnum2, "10");
          s.Contains(CppEnum2).should.be(true);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([CppEnum2]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(CppEnum1).should.be(false);
          s[CppEnum2].toString().should.be("10");
          var scpy = s.copy();
          s.Add(CppEnum1, '3');
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([CppEnum2, CppEnum1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10", "3"]);
          s.Contains(CppEnum2).should.be(true);
          s.Contains(CppEnum1).should.be(true);
          s[CppEnum2] = "22";
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([CppEnum2, CppEnum1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["22", "3"]);
          [ for (key in s.GenerateKeyArray()) s[key].toString() ].should.containExactly(["22", "3"]);
          s.Remove(CppEnum2);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([CppEnum1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["3"]);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum1).should.be(true);
          s.Remove(CppEnum1);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(CppEnum2).should.be(false);
          s.Contains(CppEnum1).should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key ].should.containExactly([CppEnum2]);
          [ for (val in scpy.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          scpy.Contains(CppEnum2).should.be(true);
          scpy.Contains(CppEnum1).should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([CppEnum2]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(CppEnum2).should.be(true);
          s.Contains(CppEnum1).should.be(false);
       }

       for (s in [obj.enumMap2, ReflectAPI.callMethod(obj, "ufuncGet_enumMap2", []), obj2.enumMap2, ReflectAPI.callMethod(obj2, "ufuncGet_enumMap2", []), TMap.create(new TypeParam<FString>(), new TypeParam<ETestHxEnumClass>())]) {
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);
          s.Add("Test", E_2nd);
          s.Contains("Test").should.be(true);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([E_2nd]);
          s.Contains("Test2").should.be(false);
          s["Test"].should.be(E_2nd);
          var scpy = s.copy();
          s.Add("Test2", E_1st);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([E_2nd, E_1st]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(true);
          s["Test"] = E_3rd;
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([E_3rd, E_1st]);
          [ for (key in s.GenerateKeyArray()) s[key] ].should.containExactly([E_3rd, E_1st]);
          s.Remove("Test");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([E_1st]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(true);
          s.Remove("Test2");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in scpy.GenerateValueArray()) val ].should.containExactly([E_2nd]);
          scpy.Contains("Test").should.be(true);
          scpy.Contains("Test2").should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([E_2nd]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
       }

       for (s in [obj.objMap, ReflectAPI.callMethod(obj, "ufuncGet_objMap", []), obj2.objMap, ReflectAPI.callMethod(obj2, "ufuncGet_objMap", []), TMap.create(new TypeParam<UBasicTypesUObject>(), new TypeParam<FString>())]) {
          var obj1 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());
          var obj2 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());
          var obj3 = UObject.NewObject(new TypeParam<UBasicTypesUObject>(), UObject.GetTransientPackage(), UBasicTypesUObject.StaticClass());

          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(obj2).should.be(false);
          s.Contains(obj1).should.be(false);
          s.Add(obj2, "10");
          s.Contains(obj2).should.be(true);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([obj2]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(obj1).should.be(false);
          s[obj2].toString().should.be("10");
          var scpy = s.copy();
          s.Add(obj1, '3');
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([obj2, obj1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10", "3"]);
          s.Contains(obj2).should.be(true);
          s.Contains(obj1).should.be(true);
          s[obj2] = "22";
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([obj2, obj1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["22", "3"]);
          [ for (key in s.GenerateKeyArray()) s[key].toString() ].should.containExactly(["22", "3"]);
          s.Remove(obj2);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([obj1]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["3"]);
          s.Contains(obj2).should.be(false);
          s.Contains(obj1).should.be(true);
          s.Remove(obj1);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly([]);
          s.Contains(obj2).should.be(false);
          s.Contains(obj1).should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key ].should.containExactly([obj2]);
          [ for (val in scpy.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          scpy.Contains(obj2).should.be(true);
          scpy.Contains(obj1).should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key ].should.containExactly([obj2]);
          [ for (val in s.GenerateValueArray()) val.toString() ].should.containExactly(["10"]);
          s.Contains(obj2).should.be(true);
          s.Contains(obj1).should.be(false);
       }

       for (s in [obj.objMap2, ReflectAPI.callMethod(obj, "ufuncGet_objMap2", []), obj2.objMap2, ReflectAPI.callMethod(obj2, "ufuncGet_objMap2", []), TMap.create(new TypeParam<FString>(), new TypeParam<UHaxeDerived1>())]) {
          var obj1 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());
          var obj2 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());
          var obj3 = UObject.NewObject(new TypeParam<UHaxeDerived1>(), UObject.GetTransientPackage(), UHaxeDerived1.StaticClass());

          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);
          s.Add("Test", obj2);
          s.Contains("Test").should.be(true);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([obj2]);
          s.Contains("Test2").should.be(false);
          s["Test"].should.be(obj2);
          var scpy = s.copy();
          s.Add("Test2", obj1);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([obj2, obj1]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(true);
          s["Test"] = obj3;
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test", "Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([obj3, obj1]);
          [ for (key in s.GenerateKeyArray()) s[key] ].should.containExactly([obj3, obj1]);
          s.Remove("Test");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test2"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([obj1]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(true);
          s.Remove("Test2");
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly([]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([]);
          s.Contains("Test").should.be(false);
          s.Contains("Test2").should.be(false);

          [ for (key in scpy.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in scpy.GenerateValueArray()) val ].should.containExactly([obj2]);
          scpy.Contains("Test").should.be(true);
          scpy.Contains("Test2").should.be(false);
          s.assign(scpy);
          [ for (key in s.GenerateKeyArray()) key.toString() ].should.containExactly(["Test"]);
          [ for (val in s.GenerateValueArray()) val ].should.containExactly([obj2]);
          s.Contains("Test").should.be(true);
          s.Contains("Test2").should.be(false);
       }
      });
    });
  }
}

@:uclass
class UTestTArray extends UObject {
  @:uexpose @:uproperty
  public var array:TArray<FString>;

  @:uproperty
  public var set:TSet<FString>;

  @:ufunction public function ufuncGet_set():TSet<FString> {
    return  set;
  }

  @:uproperty
  public var set2:TSet<Int>;

  @:ufunction public function ufuncGet_set2():TSet<Int> {
    return  set2;
  }

  @:uexpose @:uproperty
  public var map:TMap<FString, FString>;

  @:uexpose @:ufunction
  public function ufuncGet_map():TMap<FString, FString> {
    return this.map;
  }

  @:uexpose @:ufunction
  public function ufuncGet_map2():TMap<Int, FString> {
    return this.map2;
  }

  @:uexpose @:uproperty
  public var map2:TMap<Int, FString>;

  @:uexpose @:ufunction
  public function ufuncGet_map3():TMap<FString, Int> {
    return this.map3;
  }

  @:uexpose @:uproperty
  public var map3:TMap<FString, Int>;
}

@:uclass class UTestTArray2 extends UObject {
  @:uexpose @:uproperty
  public var enumArray1:TArray<EMyCppEnum>;
  @:uexpose @:uproperty
  public var enumArray2:TArray<ETestHxEnumClass>;

  public static function setArray(arr:TArray<EMyCppEnum>, val:EMyCppEnum) {
    arr.push(val);
  }

  public static function getArray(arr:TArray<EMyCppEnum>, idx:Int):EMyCppEnum {
    return arr[idx];
  }

  public static function setArray2(arr:TArray<ETestHxEnumClass>, val:ETestHxEnumClass) {
    arr.Push(val);
  }

  public static function getArray2(arr:TArray<ETestHxEnumClass>, idx:Int):ETestHxEnumClass {
    return arr[idx];
  }

  @:uexpose @:ufunction
  public function ufuncGet_enumArray1():TArray<EMyCppEnum> {
    return enumArray1;
  }

  @:uexpose @:ufunction
  public function ufuncGet_enumArray2():TArray<ETestHxEnumClass> {
    return this.enumArray2;
  }

  @:uexpose @:uproperty
  public var weakArray:TArray<TWeakObjectPtr<UBasicTypesUObject>>;

  @:uexpose @:ufunction
  public function ufuncGet_weakArray():TArray<TWeakObjectPtr<UBasicTypesUObject>> {
    return weakArray;
  }

  @:uexpose @:uproperty
  public var objArray1:TArray<UBasicTypesUObject>;

  @:uexpose @:ufunction
  public function ufuncGet_objArray1():TArray<UBasicTypesUObject> {
    return objArray1;
  }

  @:uexpose @:uproperty
  public var objArray2:TArray<UHaxeDerived1>;

  @:uexpose @:ufunction public function ufuncGet_objArray2():TArray<UHaxeDerived1> {
    return objArray2;
  }

  @:uexpose @:uproperty
  public var enumSet1:TSet<EMyCppEnum>;

  @:uexpose @:ufunction public function ufuncGet_enumSet1():TSet<EMyCppEnum> {
    return enumSet1;
  }

  @:uexpose @:uproperty
  public var enumSet2:TSet<ETestHxEnumClass>;

  @:uexpose @:ufunction public function ufuncGet_enumSet2():TSet<ETestHxEnumClass> {
    return  enumSet2;
  }

  @:uexpose @:uproperty
  public var objSet1:TSet<UBasicTypesUObject>;

  @:uexpose @:ufunction public function ufuncGet_objSet1():TSet<UBasicTypesUObject> {
    return  objSet1;
  }

  @:uexpose @:uproperty
  public var objSet2:TSet<UHaxeDerived1>;

  @:uexpose @:ufunction public function ufuncGet_objSet2():TSet<UHaxeDerived1> {
    return  objSet2;
  }

  @:uexpose @:uproperty
  public var enumMap:TMap<EMyCppEnum, FString>;

  @:uexpose @:ufunction public function ufuncGet_enumMap():TMap<EMyCppEnum, FString> {
    return  enumMap;
  }

  @:uexpose @:uproperty
  public var enumMap2:TMap<FString, ETestHxEnumClass>;

  @:uexpose @:ufunction public function ufuncGet_enumMap2():TMap<FString, ETestHxEnumClass> {
    return enumMap2;
  }

  @:uexpose @:uproperty
  public var objMap:TMap<UBasicTypesUObject, FString>;

  @:uexpose @:ufunction public function ufuncGet_objMap():TMap<UBasicTypesUObject, FString> {
    return objMap;
  }

  @:uexpose @:uproperty
  public var objMap2:TMap<FString, UHaxeDerived1>;

  @:uexpose @:ufunction public function ufuncGet_objMap2():TMap<FString, UHaxeDerived1> {
    return objMap2;
  }
}

#if (pass >= 2)
@:uclass class UTestScriptTArray2 extends UObject {
  @:uproperty
  public var set:TSet<FString>;

  @:ufunction public function ufuncGet_set():TSet<FString> {
    return  set;
  }

  @:uproperty
  public var set2:TSet<Int>;

  @:ufunction public function ufuncGet_set2():TSet<Int> {
    return  set2;
  }

  @:uproperty
  public var map:TMap<FString, FString>;

  @:ufunction
  public function ufuncGet_map():TMap<FString, FString> {
    return this.map;
  }

  @:ufunction
  public function ufuncGet_map2():TMap<Int, FString> {
    return this.map2;
  }

  @:uproperty
  public var map2:TMap<Int, FString>;

  @:ufunction
  public function ufuncGet_map3():TMap<FString, Int> {
    return this.map3;
  }

  @:uproperty
  public var map3:TMap<FString, Int>;

  @:uproperty
  public var enumArray1:TArray<EMyCppEnum>;

  @:ufunction
  public function ufuncGet_enumArray1():TArray<EMyCppEnum> {
    return enumArray1;
  }

  @:uproperty
  public var enumArray2:TArray<ETestHxEnumClass>;

  @:ufunction
  public function ufuncGet_enumArray2():TArray<ETestHxEnumClass> {
    return this.enumArray2;
  }

  @:uproperty
  public var weakArray:TArray<TWeakObjectPtr<UBasicTypesUObject>>;

  @:ufunction
  public function ufuncGet_weakArray():TArray<TWeakObjectPtr<UBasicTypesUObject>> {
    return weakArray;
  }

  @:uproperty
  public var objArray1:TArray<UBasicTypesUObject>;

  @:ufunction
  public function ufuncGet_objArray1():TArray<UBasicTypesUObject> {
    return objArray1;
  }

  @:uproperty
  public var objArray2:TArray<UHaxeDerived1>;

  @:ufunction public function ufuncGet_objArray2():TArray<UHaxeDerived1> {
    return objArray2;
  }

  @:uproperty
  public var enumSet1:TSet<EMyCppEnum>;

  @:ufunction public function ufuncGet_enumSet1():TSet<EMyCppEnum> {
    return enumSet1;
  }

  @:uproperty
  public var enumSet2:TSet<ETestHxEnumClass>;

  @:ufunction public function ufuncGet_enumSet2():TSet<ETestHxEnumClass> {
    return  enumSet2;
  }

  @:uproperty
  public var objSet1:TSet<UBasicTypesUObject>;

  @:ufunction public function ufuncGet_objSet1():TSet<UBasicTypesUObject> {
    return  objSet1;
  }

  @:uproperty
  public var objSet2:TSet<UHaxeDerived1>;

  @:ufunction public function ufuncGet_objSet2():TSet<UHaxeDerived1> {
    return  objSet2;
  }

  @:uproperty
  public var enumMap:TMap<EMyCppEnum, FString>;

  @:ufunction public function ufuncGet_enumMap():TMap<EMyCppEnum, FString> {
    return  enumMap;
  }

  @:uproperty
  public var enumMap2:TMap<FString, ETestHxEnumClass>;

  @:ufunction public function ufuncGet_enumMap2():TMap<FString, ETestHxEnumClass> {
    return enumMap2;
  }

  @:uproperty
  public var objMap:TMap<UBasicTypesUObject, FString>;

  @:ufunction public function ufuncGet_objMap():TMap<UBasicTypesUObject, FString> {
    return objMap;
  }

  @:uproperty
  public var objMap2:TMap<FString, UHaxeDerived1>;

  @:ufunction public function ufuncGet_objMap2():TMap<FString, UHaxeDerived1> {
    return objMap2;
  }
}
#end