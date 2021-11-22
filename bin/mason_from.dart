import 'package:args/command_runner.dart';
import 'package:mason_from/src/commands/generator_no_substitution.dart';
// import 'package:universal_io/io.dart';
// import 'package:very_good_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  // await _flushThenExit(
  final runner =
      CommandRunner<int>('mason_from', 'Create mason template from bundle')
        ..addCommand(CreateCommand());
  // await _flushThenExit(
  await runner.run(args);
  // );
  // .run(args);
  // );
}

/// Flushes the stdout and stderr streams, then exits the program with the given
/// status code.
///
/// This returns a Future that will never complete, since the program will have
/// exited already. This is useful to prevent Future chains from proceeding
/// after you've decided to exit.
// Future _flushThenExit(int status) {
//   return Future.wait<void>([stdout.close(), stderr.close()])
//       .then<void>((_) => exit(status));
// }
