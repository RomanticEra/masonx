import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util/index.dart';
import 'package:mocktail/mocktail.dart';
import 'package:romantic_common/romantic_common.dart';
import 'package:romantic_fake/romantic_fake.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  final runner = masonx;
  const bundlePath = 'example/core.json';
  const hookPath = 'example/hook.json';
  final _outdir = Directory.systemTemp.createTempSync();

  group('[ClosureVarBrickAdapter`', () {
    test(
      '[throw a error][with split]',
      () async {
        try {
          await runner.run([
            'patch',
            'hello_split',
            'example',
            // '-c',
            // 'example/hello_config.json',
          ]);
        } on ExException catch (e) {
          expect(e.message, 'Please use no . var');
        }

        // await runner.run(['patch', '-h', bundlePath, hookPath, _outdir.path]);
      },
    );
    test(
      '[throw a error][no brick]',
      () async {
        try {
          await runner.run([
            'patch',
            'hook',

            /// correct is hooks
            'example',
            // '-c',
            // 'example/hook_config.json',
          ]);
        } on ExException catch (e) {
          expect(e.message, 'There is no brick.');
        }
        // await runner.run(['patch', '-h', bundlePath, hookPath, _outdir.path]);
      },
    );
    test(
      '[getConfigForGenerator][with configPath]',
      () async {
        await runner.run([
          'patch',
          'hooks',
          'example',
          '-c',
          'example/hook_config.json',
        ]);

        // await runner.run(['patch', '-h', bundlePath, hookPath, _outdir.path]);
      },
    );
    test(
      '[getConfigForGenerator][with prompt]',
      () async {
        final _logger = logger;
        logger = MockLogger();
        when(() => logger.prompt('name: ')).thenReturn('Hooks');

        await runner.run([
          'patch',
          'hooks',
          outdir.path,
        ]);
        logger = _logger;
        expect(
          File('${outdir.path}/hooks.md').readAsStringSync(),
          'Hi Hooks!',
        );
      },
    );
    // test(
    //   '[getConfigForGenerator][with configPath]',
    //   () async {
    //     final result = await runner.run([
    //       'patch',
    //       'hello',
    //       'example',
    //       // '-c',
    //       // 'example/hello_config.json',
    //     ]);
    //     expect(result, 1);

    //     // await runner.run(['patch', '-h', bundlePath, hookPath, _outdir.path]);
    //   },
    // );
  });
  group('[Usually Command Run] `mason bf bundlePath outdir`', () {
    //   test(
    //     '[description]',
    //     () async {
    //       await ''.getFileWithJson;
    //       // await runner.run(['patch', '-h', bundlePath, hookPath, _outdir.path]);
    //     },
    //   );
    // });

    // test('[generator.generateBricks]', () async {
    //   final bundle = await FromGenerator.getBundle(hookPath);
    //   final generator = await MasonGenerator.fromBundle(bundle);
    //   // final target = DirectoryGeneratorTarget(_outdir, MockLogger());
    //   // final fileCount = await generator.generateBricks(target);
    //   final vars = generator.getVars();
    //   // print(vars);
    //   // final a = Map.fromIterables(
    //   //   vars.map((e) => e.substring(2, e.length - 2)),
    //   //   vars,
    //   // );
    //   // print(json.encode(a));

    //   expect(1, 1);
    // });
    // test('[generator.generateBricks]', () async {
    //   final result = await runner.run(['patch', 'hello', 'example']);
    // });
  });
}
