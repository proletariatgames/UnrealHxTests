package cases;
import unreal.*;
import NonUObject;
import helpers.TestHelper;
import UBasicTypesSub;

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
        var obj = UObject.NewObject(new TypeParam<UTestTArray>());
        obj.array.Push("Hello from Haxe!");
        obj.array.length.should.be(1);
        obj.array[0].toString().should.be("Hello from Haxe!");
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
