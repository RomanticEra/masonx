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

  group('[ClosureVarBrickAdapter', () {
    test(
      '[throw a error][with split]',
      () async {
        try {
          await runner.run([
            'patch',
            'hello_split',
            'example',
          ]);
        } on ExException catch (e) {
          expect(e.message, 'Please use no . var');
        }
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
  });
  group('[PatchCommand]', () {
    test(
      '[getConfigForGenerator][with prompt]',
      () async {
        final _logger = logger;
        logger = MockLogger();
        when(() => logger.prompt('project_name: ')).thenReturn('Hooks');

        await runner.run([
          'patch',
          'melos',
          outdir.path,
        ]);
        logger = _logger;
      },
    );
  });
}
