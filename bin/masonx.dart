import 'package:mason/src/command_runner.dart' show MasonCommandRunner;
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util.dart';

Future<void> main(List<String> args) async {
  try {
    await masonx.run(args);
  } on ExException catch (e) {
    logger.err(e.toString());
  } catch (e) {
    await MasonCommandRunner().run(args);
  }
}
