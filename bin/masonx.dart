import 'package:mason/src/command_runner.dart' show MasonCommandRunner;
import 'package:masonx/masonx.dart';

Future<void> main(List<String> args) async {
  try {
    await masonx.run(args);
  } catch (e) {
    await MasonCommandRunner().run(args);
  }
}
