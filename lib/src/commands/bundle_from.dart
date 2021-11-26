import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:path/path.dart';
import 'package:universal_io/io.dart';

import 'util.dart';

/// {@template commandE}
/// The base class for all executable commands.
/// {@endtemplate}
abstract class CommandEIO extends Command<int> {
  @override
  Future<int> run() async {
    await prepareEntity();
    await prepare();

    return handle();
  }

  /// prepareEnity
  Future<void> prepareEntity();

  /// prepare
  Future prepare();

  /// rest of [run]
  Future<int> handle();

  /// example for help
  String get example;
}

/// mixin about path and file.
extension CommandIO on CommandEIO {
  /// [ArgResults] for the current command.
  ArgResults get results => argResults!;

  /// inputPath
  String get inputPath {
    try {
      return results.rest[0];
    } catch (e) {
      throw UsageException(
        '''Could not find a input path for "masonx bundleF".''',
        example,
      );
    }
  }

  /// output path
  String get outputPath {
    try {
      return results.rest[1];
    } catch (e) {
      throw UsageException(
        '''Could not find a output path for "masonx bundleF".''',
        example,
      );
    }
  }

  /// basename
  String get filename => basenameWithoutExtension(inputPath);
}

/// const String Example
const String exampleKey = 'Example: masonx bf example/core.json .';

/// {@template BrickFromCommand}
/// Get brick template from bundle or dart.
///
/// Example:
/// * masonx bf xxx/bundle.bundle
/// {@endtemplate}
class BrickFromCommand extends CommandEIO {
  /// {@macro BrickFromCommand}
  BrickFromCommand();

  @override
  List<String> get aliases => ['bf', 'bundle_from'];

  @override
  String get example => exampleKey;

  @override
  String get description => 'Get brick template from bundle or dart.\n'
      '$example';

  @override
  final String name = 'bundleF';

  /// prepareEntity
  @override
  Future<void> prepareEntity() async {
    /// for first test inputPath
    bundlePath;
    await brickWriteYamlFile.create(recursive: true);
    await projectDirectory.create(recursive: true);
  }

  @override
  Future<int> handle() async {
    final bundle = await this.bundle;
    final generator = await this.generator;
    brickWriteYamlFile.writeAsStringSync(
      json2yaml(
        bundle.toJson()
          ..remove('files')
          ..remove('hooks'),
      ),
    );

    final fileCount = await generator.generateBricks(
      DirectoryGeneratorTarget(projectDirectory, logger),
    );
    final hookCount = await generator.generateHooks(
      DirectoryGeneratorTarget(hookDirectory, logger),
    );

    return fileCount + hookCount;
  }

  @override
  Future prepare() async {}
}

/// Prepare for Command
extension PrepareModel on BrickFromCommand {
  /// rename inputPath as [bundlePath]
  String get bundlePath => inputPath;

  /// rename filename as [projectName]
  /// Get projectName, Example: bricks/brick_factory => brick_factory
  String get projectName => filename;

  /// factory for [bundle]
  Future<MasonBundle> get bundle async {
    return FromGenerator.getBundle(bundlePath);
  }

  /// factory for [generator]
  Future<MasonGenerator> get generator async =>
      MasonGenerator.fromBundle(await bundle);

  /// output1
  File get brickWriteYamlFile =>
      File([outputPath, projectName, 'brick.yaml'].join('/'));

  /// output dir
  Directory get projectDirectory =>
      Directory([outputPath, projectName, '__brick__'].join('/'));

  /// hook dir
  Directory get hookDirectory =>
      Directory([outputPath, projectName, 'hooks'].join('/'));
}
