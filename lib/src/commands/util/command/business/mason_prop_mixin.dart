// ignore_for_file: public_member_api_docs

import 'package:path/path.dart';
import 'package:romantic_common/romantic_common.dart';
import 'package:universal_io/io.dart';
import 'add_options_extension.dart';

mixin MasonPropMixin on IArgument2Statistical<MasonParseEnum> {
  String get bundlePath => statistical.enumParse(MasonParseEnum.bundlePath);
  String get outputDir => statistical.enumParse(MasonParseEnum.outputDir);
  String? get configPath {
    try {
      return statistical.enumParse(MasonParseEnum.configPath);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return null;
    }
  }

  // String get brickDir => statistical.enumParse(MasonParseEnum.brickDir);
  String get brickKey => statistical.enumParse(MasonParseEnum.brickKey);

  /// rename filename as [projectName]
  /// Get projectName, Example: bricks/brick_factory => brick_factory
  String get projectName => basenameWithoutExtension(bundlePath);

  /// output1
  /// should call behind input check
  File get brickWriteYamlFile =>
      File([outputDir, projectName, 'brick.yaml'].join('/'));

  /// output dir
  Directory get projectDirectory =>
      Directory([outputDir, projectName, '__brick__'].join('/'));

  /// hook dir
  Directory get hookDirectory =>
      Directory([outputDir, projectName, 'hooks'].join('/'));
}
