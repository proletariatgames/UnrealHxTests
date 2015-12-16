package commandlets;

#if WITH_EDITOR
import unreal.*;
import unreal.editor.*;
import assets.*;

@:uclass
class UUpdateAssetCommandlet extends UCommandlet {
  override public function Main(params:Const<PRef<FString>>):Int32 {
    var args = parseArgs(params.toString());
    Sys.println(params);
    Sys.println(args);
    var contentPath = FPaths.ConvertRelativePathToFull(FPaths.GameContentDir());
    var ret = UObject.LoadObject(new TypeParam<UHaxeAsset>(), UHaxeAsset.StaticClass(), '/Game/SomeAsset', '/Game/SomeAsset', 0, null);
    if (ret == null) {
      var pack = UObject.CreatePackage(null, '/Game/SomeAsset');
      ret = UObject.NewObjectWithFlags(new TypeParam<UHaxeAsset>(), pack, UHaxeAsset.StaticClass(), 'SomeAsset', EObjectFlags.RF_Public | EObjectFlags.RF_Standalone);
    }
    var data = { stamp: args[1], someInt: 42 };
    ret.data = data;
    return UEditorEngine.GEditor.SavePackage(ret.GetOutermost(), null, EObjectFlags.RF_Standalone, '$contentPath/SomeAsset.uasset') ? 0 : 1;
  }

  static function parseArgs(arg:String):Array<String> {
    var ret = [];
    var len = arg.length;
    var i = -1;
    var didStart = false,
        inQuotes = false,
        inEscape = false;
    var buf = new StringBuf();
    while (++i < len) {
      var wasInEscape = inEscape;
      inEscape = false;
      switch(StringTools.fastCodeAt(arg, i)) {
        case '"'.code:
          if (!didStart) {
            didStart = true;
            inQuotes = true;
          } else if (inQuotes) {
            if (wasInEscape) {
              buf.addChar('"'.code);
            } else {
              inQuotes = false;
              didStart = false;
              ret.push(buf.toString());
              buf = new StringBuf();
            }
          } else {
            buf.addChar('"'.code);
          }
        case ' '.code if(!inQuotes):
          if (didStart) {
            didStart = false;
            inQuotes = false;
            ret.push(buf.toString());
            buf = new StringBuf();
          }
        case '\\'.code if(inQuotes):
          if (wasInEscape) {
            buf.addChar('\\'.code);
          } else {
            inEscape = true;
          }
        case chr:
          didStart = true;
          buf.addChar(chr);
      }
    }
    if (didStart) {
      ret.push(buf.toString());
    }
    return ret;
  }

  override public function CreateCustomEngine(params:Const<PRef<FString>>):Void {
    // setting them to null will make the caller create the default engine object
    UEngine.GEngine = null;
    UEditorEngine.GEditor = null;
  }
}
#end
