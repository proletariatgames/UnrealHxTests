package cases;
import unreal.*;

/**
  Testing case when a base class which defines a function which takes a haxe-only type (TAnonymous to unreal), is overridden by a child class.
**/
class TestOverride extends buddy.BuddySuite {

    public function new() {
    }
  }

@:uclass 
class UOverrideTestBaseClass extends UObject { 
    function test(input:String):{output:String} { 
      return {output:input+"42"};
    }
}

@:uclass 
class UOverrideTestChildClass extends UOverrideTestBaseClass { 
    override function test(input:String):{output:String} { 
      return {output:input+"3"};
    }
}