import sys.FileSystem;
using StringTools;
class PassExpand {
  public static function run(path:String, pass:Int) {
    function recurse(dir:String) {
      for (file in FileSystem.readDirectory(dir)) {
        if (file.endsWith('.hx')) {
          expand(pass, '$dir/$file');
        } else if (FileSystem.isDirectory('$dir/$file')) {
          recurse('$dir/$file');
        }
      }
    }
    recurse(path);
  }

  public static function expand(pass:Int, file:String) {
    var contents = sys.io.File.getContent(file);
    var regex = ~/#(?:if|elseif) *\(pass *>= *(\d+)\)/;
    if (!regex.match(contents)) {
      return;
    }
    var changed = false;
    var buf = new StringBuf();
    do {
      buf.add(regex.matchedLeft());
      var passCheck = Std.parseInt(regex.matched(1));
      if (pass >= passCheck) {
        buf.add('#if true ');
        changed = true;
      } else {
        buf.add(regex.matched(0));
      }
      contents = regex.matchedRight();
    } while(regex.match(contents));
    buf.add(contents);

    var ret = buf.toString().trim();
    // if (!FileSystem.exists(dest) || sys.io.File.getContent(dest).trim() != ret) {
    // if (sys.io.File.getContent(dest).trim() != ret) {
    if (changed) {
      sys.io.File.saveContent(file, ret);
    }
  }
}