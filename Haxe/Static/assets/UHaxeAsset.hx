package assets;
import unreal.*;

/**
  Tests the implementation of a custom asset
 **/
@:uclass(BlueprintType, HideCategories=[Object])
class UHaxeAsset extends UObject {
  @:uproperty(BlueprintReadOnly, Category="HaxeAsset")
  private var rawContents:FString;

  @:isVar public var data(get,set):Dynamic;

  public function new(wrapped) {
    super(wrapped);
  }

  private function get_data() {
    if (this.data == null && !this.rawContents.IsEmpty()) {
      this.data = haxe.Unserializer.run(this.rawContents.toString());
    }
    return this.data;
  }

  private function set_data(val:Dynamic):Dynamic {
    this.rawContents = haxe.Serializer.run(val);
    return this.data = val;
  }
}
