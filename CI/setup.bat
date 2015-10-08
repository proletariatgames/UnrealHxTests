REM setup haxelib

if not exist haxelib mkdir haxelib

REM install all needed libraries
haxelib install hxcpp || exit 1
haxelib install hxcs || exit 1
haxelib install buddy || exit 1

REM build the build scripts
cd Plugins/UE4Haxe
haxe init-plugin.hxml || exit 1
