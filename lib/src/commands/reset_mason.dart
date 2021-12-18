// ignore: implementation_imports
import 'package:mason/src/command_runner.dart' show MasonCommandRunner;
// ignore: prefer_relative_imports
import 'package:masonx/src/commands/util/util.dart';
import 'package:path/path.dart';
import 'package:romantic_common/romantic_common.dart';
import 'package:universal_io/io.dart';
import 'package:yaml/yaml.dart';

import 'util/command/business/index.dart';

/// GenConfigCommand
class RestMasonCommand extends MasonCommandBase {
  /// {@macro PatchCommand}
  RestMasonCommand()
      : super(
          'reset',
          '',
          'rest .mason/bricks.json',
          ['r'],
          [],
        );
  @override
  Future<int> run() async {
    // print(Directory.current.path);
    // coverage:ignore-start
    final items = Directory.current.listSync().firstWhere(
          (event) =>
              basenameWithoutExtension(event.path) == 'mason' &&
              (['.yaml', '.yml'].contains(extension(event.path))),
          // orElse: () => throw Exception('There is no mason.yaml'),
        ) as File;
    // coverage:ignore-end
    if (File('.mason/bricks.json').existsSync()) {
      final oldBricksList = '.mason/bricks.json'
          .getFileWithJsonSync
          .values
          // ignore: avoid_annotating_with_dynamic
          .map((dynamic e) => e.toString())
          .toList();

      final doc = loadYaml(items.readAsStringSync()) as YamlMap;
      final configBricks = (doc['bricks'] as YamlMap).keys.toList();

      final flag = oldBricksList
          .map((e) => e.split('/').last)
          .every(configBricks.contains);
      if (flag) {
        ProcessResult result;
        result = await Process.run(
          'rm',
          ['.mason/bricks.json'],
          workingDirectory: '.',
        );
        logger.info(
          <dynamic>[result.stdout, result.stderr]
              // ignore: avoid_annotating_with_dynamic
              .map((dynamic e) => e.toString())
              .join(' '),
        );
      }
    }
    if (!File('.mason/bricks.json').existsSync()) {
      final result = await MasonCommandRunner().run(['get']);
      return result;
    }
    throw ExException('Flag is false', ''); // coverage:ignore-line
  }
}
