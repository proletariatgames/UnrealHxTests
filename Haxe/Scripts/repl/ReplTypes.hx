package repl;
import unreal.*;
import NonUObject;

@:uclass class AReplicationTest extends AActor {
  @:uproperty(Transient) @:ureplicate(InitialOnly)
  public var initialOnRep:Int32;

  @:uproperty @:ureplicate
  public var i32:Int32;

  @:uproperty @:ureplicate(OwnerOnly)
  public var i32OwnerOnly:Int32;

  @:uproperty @:ureplicate
  public var fstring:FString;

  @:uproperty(Transient) @:ureplicate(InitialOnly)
  public var ftextInitialOnly:FText;

  @:uproperty @:ureplicate(i32ShouldRep)
  public var i32RepFunc:Int32;

  @:uproperty @:ureplicate
  public var ustruct:FSimpleUStruct;

  @:uproperty @:ureplicate
  public var someArray:TArray<FText>;

  @:uproperty
#if (pass >= 6)
  @:ureplicate(hotReload1ShouldRep)
#else
  @:ureplicate
#end
  public var hotReload1:Int64;

  public var fn_i32:Void->Void;
  public var fn_i32OwnerOnly:Int32->Void;
  public var fn_fstring:FString->Void;
  public var fn_ustruct:Void->Void;
  public var fn_someArray:Void->Void;
#if (pass >= 5)
  public var fn_hotReload1:Void->Void;
#end

  public var fn_i32ShouldRep:Void->Bool;
#if (pass >= 6)
  public var fn_hotReload1ShouldRep:Void->Bool;
#end

  public function new(wrapped) {
    super(wrapped);
    trace('hello');
    trace(GetNetMode());
    trace(this.Role);
    this.RootComponent = FObjectInitializer.Get().CreateDefaultSubobject(new TypeParam<USceneComponent>(), this, "Root", false);
    this.SetReplicates(true);
    bAlwaysRelevant = true;
  }

  override public function BeginPlay() {
    super.BeginPlay();

    if (this.Role == ROLE_Authority) {
      trace('dedicated server');
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
  function onRep_i32OwnerOnly(i32:Int32) {
    this.fn_i32OwnerOnly(i32);
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
  function onRep_ustruct() {
    this.fn_ustruct();
  }

  @:ufunction
  function onRep_someArray() {
    this.fn_someArray();
  }

#if (pass >= 5)
  @:ufunction
  function onRep_hotReload1() {
    this.fn_hotReload1();
  }
#end

  function i32ShouldRep() : Bool {
    return this.fn_i32ShouldRep();
  }

#if (pass >= 6)
  function hotReload1ShouldRep() : Bool {
    return this.fn_hotReload1ShouldRep();
  }
#end

  @:ufunction(NetMulticast, Reliable)
  public function startTest();

  function startTest_Implementation() {
  }
}

@:uclass class AReplPlayerController extends APlayerController {
  @:uproperty @:ureplicate
  public var canCallServerFn:Bool;

  public var validateCalled:Bool;

  public var fn_canCallServerFn:Void->Void;
  public var fn_onServerCall:TArray<FSimpleUStruct>->Void;
  public var fn_onClientCalled:String->String->Void;

  @:ufunction
  function onRep_canCallServerFn() {
    this.fn_canCallServerFn();
  }

  @:ufunction(Server, Reliable, WithValidation)
  public function Server_Reliable_WithValidation(arr:TArray<FSimpleUStruct>);

  function Server_Reliable_WithValidation_Implementation(arr:TArray<FSimpleUStruct>) {
    this.fn_onServerCall(arr);
  }

  function Server_Reliable_WithValidation_Validate(arr:TArray<FSimpleUStruct>) {
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
@:uclass ADynamicReplActor extends AActor {
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
