package cases;
import cases.TestUObjectOverrides;
import NonUObject;
import UBasicTypesSub;
import unreal.*;

using buddy.Should;

class TestReflect extends buddy.BuddySuite {
  public function new() {
    describe('ReflectAPI extensions', {
      it('should be able to set normal fields', {
        function run() {
          var obj = UHaxeDerived1.create();
          // public var haxeType:{ i32:Int, d64:Float, arr:Array<Int>, arr2:Array<{ x:Int, y:Float }> };
          obj.haxeType.should.be(null);
          var val = { i32:1, d64:2, arr:[1,2,3,4,5], arr2:[{ x:1, y:1.1 }, { x:2, y:2.2 }] };

          ReflectAPI.extSetField(obj, 'haxeType', val);
          obj.haxeType.should.be(val);
          ReflectAPI.extSetField(obj, 'someString', 'testing');
          obj.someString.should.be('testing');
          ReflectAPI.extSetField(obj, 'someArray', obj.haxeType.arr2);
          for (i in 1...3) {
            obj.someArray[i-1].x.should.be(i);
            obj.someArray[i-1].y.should.be(i * 1.1);
          }

#if debug
          ReflectAPI.extSetField.bind(obj, 'someFieldThatDoesntExist', 'blablabla').should.throwType(String);
#end
        }
        run();
      });
      it('should be able to convert anonymous fields into structs', {
        function run() {
          var obj1 = UObject.NewObject(new TypeParam<UObjectReflect>());
          ReflectAPI.extSetField(obj1, 'basic', {
            f1: 1.1,
            d1: 2.2,
            i32: 33,
            ui32: 44
          });
          obj1.basic.f1.should.beCloseTo(1.1);
          obj1.basic.d1.should.beCloseTo(2.2);
          obj1.basic.i32.should.be(33);
          obj1.basic.ui32.should.be(44);

          ReflectAPI.extSetField(obj1, 'hasStruct', {
            simple: {
              f1: 1.11,
              d1: 2,
              i32: 333,
              ui32: 444
            },
            myEnum: SomeEnum.EMyEnum.SomeEnum2,
            myCppEnum: SomeEnum.EMyCppEnum.CppEnum3
          });
          obj1.hasStruct.simple.f1.should.beCloseTo(1.11);
          obj1.hasStruct.simple.d1.should.be(2);
          obj1.hasStruct.simple.i32.should.be(333);
          obj1.hasStruct.simple.ui32.should.be(444);
          obj1.hasStruct.myEnum.should.be(SomeEnum.EMyEnum.SomeEnum2);
          obj1.hasStruct.myCppEnum.should.be(SomeEnum.EMyCppEnum.CppEnum3);

          ReflectAPI.extSetField(obj1.hasStruct, 'simple', {
            f1: 1.1,
            d1: 2.2,
            i32: 33,
            ui32: 44
          });
          obj1.hasStruct.simple.f1.should.beCloseTo(1.1);
          obj1.hasStruct.simple.d1.should.beCloseTo(2.2);
          obj1.hasStruct.simple.i32.should.be(33);
          obj1.hasStruct.simple.ui32.should.be(44);
        }
        run();
      });
      it('should be able to transform String into FString, FText and FName', {
        function run() {
          var obj1 = UObject.NewObject(new TypeParam<UObjectReflect>());
          ReflectAPI.extSetField(obj1, 'name', 'hello');
          ReflectAPI.extSetField(obj1, 'str', 'hello, str');
          ReflectAPI.extSetField(obj1, 'text', 'hello, text');
          obj1.name.toString().should.be('hello');
          obj1.str.toString().should.be('hello, str');
          obj1.text.toString().should.be('hello, text');

          ReflectAPI.extSetField(obj1, 'struct1', {
            str: 'hello, str',
            fname: 'hello, fname',
            text: 'hello, text'
          });
          obj1.struct1.str.toString().should.be('hello, str');
          obj1.struct1.fname.toString().should.be('hello, fname');
          obj1.struct1.text.toString().should.be('hello, text');
        }
        run();
      });
      it('should be able to convert Array fields into TArray', {
        function run() {
          var obj1 = UObject.NewObject(new TypeParam<UObjectReflect>());
          ReflectAPI.extSetField(obj1, 'struct1Arr', [
            { str:"hello str", vec:{ X:1, Y:2, Z:3 }, vec2d: { X:10, Y:20 } },
            { fname:"hello fname", arr:[{ X:100, Y:200, Z:300 }, { X:111, Y:222, Z:333 }] }
          ]);

          obj1.struct1Arr.length.should.be(2);
          obj1.struct1Arr[0].str.toString().should.be('hello str');
          obj1.struct1Arr[0].vec.X.should.be(1);
          obj1.struct1Arr[0].vec.Y.should.be(2);
          obj1.struct1Arr[0].vec.Z.should.be(3);
          obj1.struct1Arr[0].vec2d.X.should.be(10);
          obj1.struct1Arr[0].vec2d.Y.should.be(20);

          obj1.struct1Arr[1].fname.toString().should.be('hello fname');
          obj1.struct1Arr[1].arr[0].X.should.be(100);
          obj1.struct1Arr[1].arr[0].Y.should.be(200);
          obj1.struct1Arr[1].arr[0].Z.should.be(300);
          obj1.struct1Arr[1].arr[1].X.should.be(111);
          obj1.struct1Arr[1].arr[1].Y.should.be(222);
          obj1.struct1Arr[1].arr[1].Z.should.be(333);
        }
        run();
      });
    });
  }
}


@:uclass
class UObjectReflect extends UObject {
  @:uexpose
  public var basic:FSimpleStruct;

  @:uexpose
  public var hasStruct:FHasStructMember1;

  @:uproperty
  public var name:FName;

  @:uproperty
  public var str:FString;

  @:uproperty
  public var text:FText;

  @:uproperty
  public var struct1:FHaxeReflectStruct1;

  @:uproperty
  public var struct1Arr:TArray<FHaxeReflectStruct1>;
}

@:ustruct()
class FHaxeReflectStruct1 extends unreal.UnrealStruct
{
  @:uproperty
  public var str:FString;
  @:uproperty
  public var text:FText;
  @:uproperty
  public var fname:FName;
  @:uproperty
  public var uobj:UHaxeDerived1;
  @:uproperty
  public var vec:FVector;
  @:uproperty
  public var vec2d:FVector2D;
  @:uproperty
  public var arr:TArray<FVector>;
}
