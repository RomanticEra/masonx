import 'dart:async';

import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:mason/mason.dart';

import 'util/command/business/add_options_extension.dart';
import 'util/command/business/bundle_to_brick_json.dart';
import 'util/command/business/index.dart';
import 'util/command/command_prop.dart';
import 'util/index.dart';

/// const String Example
const String exampleKey = 'Example: masonx bf example/core.json .';

/// {@template BrickFromCommand}
/// Get brick template from bundle or dart.
///
/// Example:
/// * masonx bf xxx/bundle.bundle
/// {@endtemplate}
class BrickFromCommand extends MasonCommandBase {
  /// construct throught [CommandAdapter]
  BrickFromCommand()
      : super(
          'bundleF',
          exampleKey,
          'Get brick template from bundle or dart.',
          ['bf', 'bundle_from'],
          [MasonParseEnum.bundlePath, MasonParseEnum.outputDir],
        );

  @override
  Future<int> handle() async {
    final bundle = await this.bundle;
    final generator = await this.generator;

    await brickWriteYamlFile.create(recursive: true);
    await projectDirectory.create(recursive: true);
    brickWriteYamlFile.writeAsStringSync(
      json2yaml(bundle.toBrickJson),
    );

    final fileCount = await generator.generateBricks(
      DirectoryGeneratorTarget(projectDirectory, logger),
    );
    final hookCount = await generator.generateHooks(
      DirectoryGeneratorTarget(hookDirectory, logger),
    );

    return fileCount + hookCount;
  }
}
