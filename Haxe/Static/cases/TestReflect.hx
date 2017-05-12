package cases;
import cases.TestUObjectOverrides;
import NonUObject;
import UBasicTypesSub;
import unreal.*;

using buddy.Should;

class TestReflect extends buddy.BuddySuite {
  public function new() {
    return;
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
          ReflectAPI.extSetField(obj1, 'struct1', {
            f1: 1.1,
            d1: 2.2,
            i32: 33,
            ui32: 44
          });
          obj1.struct1.f1.should.beCloseTo(1.1);
          obj1.struct1.d1.should.beCloseTo(2.2);
          obj1.struct1.i32.should.be(33);
          obj1.struct1.ui32.should.be(44);

          ReflectAPI.extSetField(obj1, 'struct2', {
            simple: {
              f1: 1.11,
              d1: 2,
              i32: 333,
              ui32: 444
            },
            myEnum: SomeEnum.EMyEnum.SomeEnum2,
            myCppEnum: SomeEnum.EMyCppEnum.CppEnum2
          });
          obj1.struct2.simple.f1.should.beCloseTo(1.11);
          obj1.struct2.simple.d1.should.be(2);
          obj1.struct2.simple.i32.should.be(333);
          obj1.struct2.simple.ui32.should.be(444);
          obj1.struct2.myEnum.should.be(SomeEnum.EMyEnum.SomeEnum2);
          obj1.struct2.myCppEnum.should.be(SomeEnum.EMyCppEnum.CppEnum2);
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
      it('should be able to set data on blueprint-only types', {
        var cls = ReflectAPI.getBlueprintClass('/Game/Blueprints/BPObjectReflect');
        cls.should.not.be(null);
        var obj:UObject = UObject.NewObjectByClass(new TypeParam<UObject>(), UObject.GetTransientPackage(), cls);
        obj.should.not.be(null);

        var val = {
          name:'TheName',
          str:'TheStr',
          struct1:{
            bool: true,
            byte: 122,
            int: 0xF0F0F0,
            float: 1.1,
            string: 'AStr',
            text: 'AText',
            vector: { X: 1, Y:2, Z:100 },
          },
          bool: false,
          byte: 166,
          int: -55,
          float: 2.2,
          vector: { X:10, Y:30, Z:200 }
        };

        for (field in Reflect.fields(val)) {
          ReflectAPI.extSetField(obj, field, Reflect.field(val, field));
        }

        ReflectAPI.bpGetField(obj, 'int').should.be(-55);
        (ReflectAPI.bpGetField(obj, 'float') : Float).should.beCloseTo(2.2);
        ReflectAPI.bpGetField(obj, 'byte').should.be(166);
        ReflectAPI.bpGetField(obj, 'bool').should.be(false);
        (ReflectAPI.bpGetField(obj, 'name') : FName).toString().should.be('TheName');
        (ReflectAPI.bpGetField(obj, 'str') : FString ).toString().should.be('TheStr');
      });
    });
  }
}


@:uclass
class UObjectReflect extends UObject {
  @:uproperty
  public var name:FName;

  @:uproperty
  public var str:FString;

  @:uproperty
  public var text:FText;

  @:uproperty
  public var struct1:FHaxeReflectStruct1;

  @:uproperty
  public var struct2:FHaxeReflectStruct2;

  @:uproperty
  public var struct1Arr:TArray<FHaxeReflectStruct1>;
}

@:ustruct()
typedef FHaxeReflectStruct1 = UnrealStruct<FHaxeReflectStruct1, [{
  @:uproperty
  var str:FString;
  @:uproperty
  var text:FText;
  @:uproperty
  var fname:FName;
  @:uproperty
  var uobj:UHaxeDerived1;
  @:uproperty
  var vec:FVector;
  @:uproperty
  var vec2d:FVector2D;
  @:uproperty
  var arr:TArray<FVector>;
  @:uproperty
  var f1:Float32;
  @:uproperty
  var d1:Float;
  @:uproperty
  var i32:Int;
  @:uproperty
  var ui32:FakeUInt32;
}]>;

@:ustruct()
typedef FHaxeReflectStruct2 = UnrealStruct<FHaxeReflectStruct2, [{
  @:uproperty
  var simple:FHaxeReflectStruct1;
  @:uproperty
  var myEnum:SomeEnum.EMyEnum;
  @:uproperty
  var myCppEnum:SomeEnum.EMyCppEnum;
}]>;
