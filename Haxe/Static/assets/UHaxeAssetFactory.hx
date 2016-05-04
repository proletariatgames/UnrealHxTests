package assets;

#if WITH_EDITOR
import unreal.*;
import unreal.editor.*;
import sys.FileSystem;
import sys.io.File;
using StringTools;

@:access(assets.UHaxeAsset)
@:uclass(HideCategories=Object)
class UHaxeAssetFactory extends UFactory {
  public function new(wrapped) {
    super(wrapped);
    this.bText = true;
    this.bEditorImport = true;
    this.Formats.Push('hxser;Haxe serialized format');
    this.SupportedClass = UHaxeAsset.StaticClass();
  }

  override function FactoryCanImport(fname:Const<PRef<FString>>):Bool {
    return fname.toString().endsWith('.hxser');
  }

  override function CanCreateNew():Bool {
    return true;
  }

  override function GetToolTip():FText {
    return 'Haxe serialized data';
  }

  override function FactoryCreateNew(inClass:UClass, inParent:UObject, name:FName, flags:EObjectFlags, context:UObject, warn:PPtr<FFeedbackContext>):UObject
  {
    var cur = UFactory.GetCurrentFilename().toString();
    if (cur.length > 0 && FileSystem.exists(cur)) {
      FEditorDelegates.OnAssetPreImport.Broadcast(this, inClass, inParent, name, 'hxser');
      var ret = UObject.NewObjectWithFlags(new TypeParam<UHaxeAsset>(), inParent, inClass, name, flags);
      ret.rawContents = sys.io.File.getContent(cur);
      FEditorDelegates.OnAssetPostImport.Broadcast(this, ret);
      return ret;
    } else {
      return null;
    }
  }
}
#end
