package repl;
import unreal.*;
import haxeunittests.*;
import NonUObject;

using unreal.CoreAPI;

#if (pass >= 7)
typedef AReplicationTest = ADynamicReplicationTest;

// force this replication
@:uclass class ADynamicReplicationTest extends AActor {
#else
@:uclass class AReplicationTest extends AActor {
#end
  @:uproperty(Transient) @:ureplicate(InitialOnly)
  public var initialOnRep:Int32;

  @:uproperty @:ureplicate
  public var i32:Int32;

  @:uproperty @:ureplicate
  public var fstring:FString;

  @:uproperty(Transient) @:ureplicate(InitialOnly)
  public var ftextInitialOnly:FText;

  @:uproperty @:ureplicate(i32ShouldRep)
  public var i32RepFunc:Int32;

  @:uproperty @:ureplicate(i32ShouldRep2)
  public var i32RepFunc2:Int32;

  @:uproperty @:ureplicate
  public var ustruct:FPODStruct;

#if (pass <= 5)
  @:uproperty @:ureplicate
  public var someArray:TArray<FText>;
#end

  @:uproperty
#if (pass >= 6)
  @:ureplicate(hotReload1ShouldRep)
#else
  @:ureplicate
#end
  public var hotReload1:Int64;

  public var fn_i32:Void->Void;
  public var fn_fstring:FString->Void;
  public var fn_ustruct:Void->Void;
  public var fn_someArray:Void->Void;
  public var fn_startTest:Void->Void;
#if (pass >= 5)
  public var fn_hotReload1:Void->Void;
#end

  public var fn_i32ShouldRep:Void->Bool;
  public var fn_i32ShouldRep2:Void->Bool;
#if (pass >= 6)
  public var fn_hotReload1ShouldRep:Void->Bool;
#end

  public function new(wrapped) {
    super(wrapped);
    this.RootComponent = CreateDefaultSubobject(new TypeParam<USceneComponent>(), "Root", USceneComponent.StaticClass());
    this.SetReplicates(true);
    this.bNetLoadOnClient = true;
    bAlwaysRelevant = true;
  }

  override public function BeginPlay() {
    super.BeginPlay();

    if (this.Role == ROLE_Authority) {
      this.initialOnRep = 0xD0D0D0D0;
      this.ftextInitialOnly = "FText Initial Property";
    }
  }

  @:ufunction
  dynamic public function onRep_initialOnRep() : Void {
  }

  @:ufunction
  dynamic public function onRep_ftextInitialOnly() : Void {
  }

  @:ufunction
  function onRep_i32() : Void {
    this.fn_i32();
  }

  @:ufunction
  function onRep_fstring(str:FString) : Void {
    this.fn_fstring(str);
  }

  @:ufunction
  public dynamic function onRep_i32RepFunc() {
    throw 'Not replaced';
  }

  @:ufunction
  public dynamic function onRep_i32RepFunc2() {
    throw 'Not replaced';
  }

  @:ufunction
  function onRep_ustruct() {
    this.fn_ustruct();
  }

#if (pass <= 5)
  @:ufunction
  function onRep_someArray() {
    this.fn_someArray();
  }
#end

#if (pass >= 5)
  @:ufunction
  function onRep_hotReload1() {
    this.fn_hotReload1();
  }
#end

  function i32ShouldRep() : Bool {
    // TODO should we really call this every network event, even if nothing has changed?
    if (this.fn_i32ShouldRep != null) {
      return this.fn_i32ShouldRep();
    } else {
      return false;
    }
  }

  function i32ShouldRep2() : Bool {
    if (this.fn_i32ShouldRep2 != null) {
      return this.fn_i32ShouldRep2();
    } else {
      return false;
    }
  }

#if (pass >= 6)
  function hotReload1ShouldRep() : Bool {
    if (this.fn_hotReload1ShouldRep != null) {
      return this.fn_hotReload1ShouldRep();
    } else {
      return false;
    }
  }
#end

  @:ufunction(NetMulticast, Reliable)
  public function startTest();

  function startTest_Implementation() {
    fn_startTest();
  }
}

@:uclass class AReplPlayerController extends APlayerController {
  @:uproperty @:ureplicate
  public var canCallServerFn:Bool;

  public var validateCalled:Bool;

  public var fn_onServerCall:TArray<FPODStruct>->Void;
  public var fn_onClientCalled:String->String->Void;

  @:ufunction(Server,Reliable,WithValidation)
  public function clientReady();
  function clientReady_Implementation() {
    var mode = this.GetWorld().GetAuthGameMode().as(AReplGameMode);
    if (mode == null) {
      trace('Fatal', 'Invalid game mode (${this.GetWorld().GetAuthGameMode()})');
    }

    mode.numReadyPlayers++;
    if (mode.onPlayerReady != null) {
      mode.onPlayerReady(this);
    }
  }
  function clientReady_Validate() {
    return true;
  }

  @:ufunction(Server, Reliable, WithValidation)
  public function Server_Reliable_WithValidation(arr:Const<PRef<TArray<FPODStruct>>>);

  function Server_Reliable_WithValidation_Implementation(arr:Const<PRef<TArray<FPODStruct>>>) {
    this.fn_onServerCall(arr);
  }

  function Server_Reliable_WithValidation_Validate(arr:Const<PRef<TArray<FPODStruct>>>) {
    this.validateCalled = true;
    return canCallServerFn && (arr.length == 0 || arr[0].i32 != 0xf00);
  }

  @:ufunction(Client, Reliable)
  public function Client_Reliable(str:Const<PRef<FString>>, name:Const<PRef<FName>>) : Void;

  function Client_Reliable_Implementation(str:Const<PRef<FString>>, name:Const<PRef<FName>>) {
    this.fn_onClientCalled(str.toString(), name.toString());
  }
}

#if (pass >= 5)
@:uclass class ADynamicReplActor extends AActor {
  @:uproperty @:ureplicate(stringShouldRep)
  public var fstringRepl:FString;

  public var shouldRep:Bool;

  function stringShouldRep():Bool {
    return shouldRep;
  }

  dynamic public function onRep_fstringRepl() {
    throw 'Not replaced';
  }

  @:ufunction(NetMulticast, Reliable)
  public function multicast():Void;

  dynamic public function multicast_Implementation() {
    throw 'Not replaced';
  }
}
#end

@:uclass class AReplGameMode extends AGameMode {
  public var onPlayerReady:APlayerController->Void;
  public var numReadyPlayers = 0;
}
