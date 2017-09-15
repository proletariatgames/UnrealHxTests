using StringTools;
class Caller {
  public static function main() {
    var args = Sys.args();
    // var cmd = args.shift();

    args = [for (arg in args) arg.replace("\\","\\\\").replace("\"","\\\"")];

    Sys.exit(murrayju.processextensions.ProcessExtensions.StartProcessAsCurrentUser(null, '"${args.join('" "')}"', null, false));
  }
}