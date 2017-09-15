using StringTools;
class Caller {
  public static function main() {
    var args = Sys.args();
    var cmd = args.shift();

    args = [for (arg in args) arg.replace("\\","\\\\").replace("\"","\\\"")];

    if (!murrayju.processextensions.ProcessExtensions.StartProcessAsCurrentUser(cmd, '"${args.join('" "')}"', null, true)) {
      Sys.exit(1);
    }
  }
}