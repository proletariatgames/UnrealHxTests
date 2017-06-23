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
      { fstring: "Test", i:0 },
      { fstring: "Test2", i:2 }
    ];
  }
}
