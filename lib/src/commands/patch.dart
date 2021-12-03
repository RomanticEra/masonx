// ignore_for_file: avoid_dynamic_calls

import 'package:mason/mason.dart';
import 'package:mason/src/commands/make.dart' show MakeCommand;
import 'package:romantic_common/romantic_common.dart';
import 'package:universal_io/io.dart';

import '../../masonx.dart';
import 'util/command/business/generator.dart';
import 'util/command/business/index.dart';
import 'util/index.dart';

// import 'package:universal_io/io.dart';

/// const String Example
const String exampleKey = 'Example: masonx p brick outdir';

/// {@template PatchCommand}
/// Get brick template from bundle or dart.
///
/// Example:
/// * masonx patch xxx/bundle.bundle -c
/// {@endtemplate}
class PatchCommand extends MasonCommandBase {
  /// {@macro PatchCommand}
  PatchCommand()
      : super(
          'p',
          exampleKey,
          'Get brick template from bundle or dart.',
          ['patch'],
          [MasonParseEnum.brickKey, MasonParseEnum.outputDir],
        );

  /// 1. Get ContentVar in Content
  /// 1.1. Switch ContentVar to NormalMap(or Config)
  /// 1.2. TopLevelVars
  ///
  /// 2. for handle no var exception, we need to a new brick,
  /// which's var is closure of TopLevelVars
  @override
  Future<int> handle() async {
    final make = MakeCommand();
    // final vars = <String, dynamic>{};

    // try {
    final brickMason = make.bricks.firstWhere(
      (e) => e.name == brickKey,
      orElse: () => throw ExException(
        'There is no brick.',
        "bricks list is: ${make.bricks.map((e) => e.name).join(' ')}",
      ),
    );

    final adapter = await ClosureVarBrickAdapter(
      brickMason: brickMason,
      configPath: configPath,
    ).switch2ClosureVarGenerator();

    final vars = await adapter.getConfigForGenerator();

    final target = DirectoryGeneratorTarget(
      Directory(outputDir),
      logger,
      FileConflictResolution.overwrite,
    );

    // final preGenScript = adapter.generatorMason!.hooks.preGen;
    // if (preGenScript != null) {
    //   final exitCode = await preGenScript.run(
    //     vars: vars,
    //     logger: logger,
    //     workingDirectory: outputDir,
    //   );
    //   if (exitCode != ExitCode.success.code) return exitCode;
    // }

    final fileCount =
        await adapter.generatorMason!.generate(target, vars: vars);

    // final postGenScript = adapter.generatorMason!.hooks.postGen;
    // if (postGenScript != null) {
    //   final exitCode = await postGenScript.run(
    //     vars: vars,
    //     logger: logger,
    //     workingDirectory: outputDir,
    //   );
    //   if (exitCode != ExitCode.success.code) return exitCode;
    // }
    logger
      ..info('Output Dir is: ${target.dir.path}')
      ..info(
        'You could check as: ${(vars['project_name'] ?? 'there') as String}',
      );
    return fileCount;
  }
}
