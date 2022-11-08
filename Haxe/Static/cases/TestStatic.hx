package cases;
import unreal.*;
import haxeunittests.*;

using buddy.Should;
using unreal.CoreAPI;

class TestStatic extends buddy.BuddySuite {
  public function new() {
    describe('Haxe: Statics', {
      it('should properly compile anonymous types with structs', {
        var arr = getStructArr();
        arr[0].fstring.toString().should.be("Test");
        arr[1].fstring.toString().should.be("Test2");
      });
    });
  }

  private static function getStructArr():Array<{ fstring:FString, i:Int }> {
    return [
      { fstring: ("Test" : FString), i:0 },
      { fstring: "Test2", i:2 }
    ];
  }
}

@:uclass
class UStaticClass extends UObject {
  @:ufunction public function doSomething(str:Const<PRef<FString>>):FString {
    return str.toString() + ' called by Static';
  }

  @:ufunction(BlueprintNativeEvent) public function test():Void;
  @:ufunction(BlueprintImplementableEvent) public function test2():Void;
  private function test_Implementation():Void {
  }
  //Test Single quotes on uproperty
  @:uproperty(EditDefaultsOnly, Category='Character')
  var CharacterClass:FString;
}
