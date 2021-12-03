import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mason/src/brick_yaml.dart';
import 'package:romantic_common/romantic_common.dart';
import 'package:universal_io/io.dart';

import '../../../bundle_from.dart';
import '../../index.dart';
import '../command_prop.dart';

/// Extension
extension FromGenerator on MasonGenerator {
  /// logger for [MasonGenerator]
  void Function([String? update]) get generateDone =>
      logger.progress('Doing $id');

  /// override [generate] for [hooks]
  Future<int> generateHooks(DirectoryGeneratorTarget target) async {
    final nfiles = [
      if (hooks.preGen != null)
        FileProxy(hooks.preGen!.path, hooks.preGen!.content),
      if (hooks.postGen != null)
        FileProxy(hooks.postGen!.path, hooks.postGen!.content)
    ];
    return writeWithBundleFileProxy(nfiles, target);
  }

  /// override [generate] for [files]
  Future<int> generateBricks(DirectoryGeneratorTarget target) async {
    final nfiles = files.map((e) => FileProxy(e.path, e.content)).toList();

    return writeWithBundleFileProxy(nfiles, target);
  }

  /// Get bundle
  static Future<MasonBundle> getBundle(String bundlePath) async {
    try {
      return MasonBundle.fromJson(await bundlePath.getFileWithJson);
    } on FileSystemException catch (e) {
      if ('Cannot open file' == e.message) {
        throw ExException(
          '''Could not find a input file for "masonx bundleF".''',
          exampleKey,
        );
      }
      rethrow;
    }
  }

  /// template for write Local with Bundle [FileProxy]
  Future<int> writeWithBundleFileProxy(
    List<FileProxy> nfiles,
    DirectoryGeneratorTarget target,
  ) async {
    await Future.forEach<FileProxy>(nfiles, (file) async {
      generateDone(file.path);
      await target.createFile(file.path, file.content);
    });
    generateDone('${nfiles.length}');
    return nfiles.length;
  }
}

/// GenConfig
extension GenConfig on MasonGenerator {
  /// getAllContent
  String getAllContent() {
    final nHooks = [
      if (hooks.preGen != null)
        FileProxy(hooks.preGen!.path, hooks.preGen!.content),
      if (hooks.postGen != null)
        FileProxy(hooks.postGen!.path, hooks.postGen!.content)
    ];
    return files.map((e) => String.fromCharCodes(e.content)).join() +
        nHooks.map((e) => String.fromCharCodes(e.content)).join();
  }

  /// content=> Set{"secrets.CREDENTIAL_JSON",...}
  Set<String> getContentVars() {
    final _delimeterRegExp = RegExp('{{(.*?)}}');
    final matches = _delimeterRegExp.allMatches(getAllContent());
    return matches.map((match) => match.group(1)!.trim()).toSet();
  }

  /// Example:
  ///
  /// secrets.CREDENTIAL_JSON =>
  ///   {secrets}
  // ignore: avoid_positional_boolean_parameters
  Set<String> getTopVars([bool ignoreVars = false]) {
    final _delimeterRegExp = RegExp('{{(.*?)}}');
    final matches = _delimeterRegExp.allMatches(getAllContent());
    return matches
        .map(
          (match) => match.group(1)!.trim().split('.').first,
        )
        .toSet()
      ..removeAll(ignoreVars ? vars : <String>[]);
  }

  /// Example:
  ///
  /// secrets.CREDENTIAL_JSON =>
  ///   {secrets: {CREDENTIAL_JSON: {{secrets.CREDENTIAL_JSON}}}"
  // ignore: avoid_positional_boolean_parameters
  Map<String, dynamic> genConfig() {
    final contentVars = getContentVars();
    return contentVars.fold<Map<String, dynamic>>(
      <String, dynamic>{},
      (previousValue, element) =>
          <String, dynamic>{...previousValue, ...var2map(element)},
    );
  }
}

/// matrix os => os matrix => {"matrix":"{{matrix.os}}"}
Map<String, dynamic> var2map(String str) {
  final parts = str.split('.').reversed;
  final lastPart = parts.first;
  return parts.skip(1).fold<Map<String, dynamic>>(
    <String, dynamic>{lastPart: '{{$str}}'},
    (previousValue, element) => <String, dynamic>{element: previousValue},
  );
}

// ignore: public_member_api_docs
mixin MasonModelExt<T, S> on CommandAdapter<T, S> {
  // ignore: public_member_api_docs
  String get bundlePath;

  /// factory for [bundle]
  Future<MasonBundle> get bundle async => FromGenerator.getBundle(bundlePath);

  /// factory for [generator]
  Future<MasonGenerator> get generator async =>
      MasonGenerator.fromBundle(await bundle);
}

/// Adapter for ClosureVarBrick with [brickMason]
///
/// 1. [brickMason] would factory [generatorMason].
/// 2. get closureVarBrick
/// 3. get ConfigForGenerator
class ClosureVarBrickAdapter {
  /// construct for [ClosureVarBrickAdapter]
  ClosureVarBrickAdapter({
    required this.configPath,
    required this.brickMason,
    this.closureVarBrick,
    this.generatorMason,
  });

  /// origin brick
  /// Not only used by [switch2ClosureVarGenerator] as factory,
  /// it also need by [getConfigForGenerator]
  final BrickYaml brickMason;

  /// closure Var brick
  final BrickYaml? closureVarBrick;

  /// through [switch2ClosureVarGenerator] switch to ClosureVarGenerator
  MasonGenerator? generatorMason;

  /// config from Argument
  String? configPath;

  /// flag that is for throw if var split with '.'
  bool isBrickNotValid() => brickMason.vars.toString().contains('.');

  /// through [switch2ClosureVarGenerator] switch to ClosureVarGenerator
  Future<ClosureVarBrickAdapter> switch2ClosureVarGenerator() async {
    generatorMason ??= await MasonGenerator.fromBrickYaml(brickMason);
    if (isBrickNotValid()) {
      throw ExException(
        'Please use no . var',
        'Example:\nvar:\n  name ',
      );
    }
    final closureVarBrickJson = brickMason.toJson()
      ..['vars'] = generatorMason!.getTopVars().toList();

    final closureVarBrick = BrickYaml.fromJson(closureVarBrickJson);
    return ClosureVarBrickAdapter(
      brickMason: brickMason,
      closureVarBrick: closureVarBrick,
      generatorMason: await MasonGenerator.fromBrickYaml(closureVarBrick),
      configPath: configPath,
    );
  }

  /// through [getConfigForGenerator] set config for [generatorMason]
  Future<Map<String, dynamic>> getConfigForGenerator() async {
    assert(
      closureVarBrick != null,
      'usage is need closureVarBrick, get it by [switch2ClosureVarGenerator]',
    );
    final hiddenVar = await closureVarBrick!.genConfig();
    final vars = hiddenVar
      ..removeWhere(
        // ignore: avoid_annotating_with_dynamic
        (key, dynamic value) => brickMason.vars.contains(key),
      );
    await vars.addConfig(
      [rootDir().path, '.config.json'].join('/'),
    );
    if (configPath != null) {
      await vars.addConfig(
        configPath!,
      );
    }
    for (final variable in closureVarBrick!.vars) {
      if (vars.containsKey(variable)) continue;
      vars.addAll(<String, dynamic>{variable: logger.prompt('$variable: ')});
    }
    return vars;
  }
}

extension on Map<String, dynamic> {
  Future<void> addConfig(String path) async {
    try {
      addAll(await path.getFileWithJson);
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }
}

/// facade from [MasonGenerator] genConfig.
extension GenConfigOnBrick on BrickYaml {
  /// facade from [MasonGenerator] genConfig.
  Future<Map<String, dynamic>> genConfig() async {
    final generator = await MasonGenerator.fromBrickYaml(this);
    return generator.genConfig();
  }
}
