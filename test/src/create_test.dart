import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:mason_from/src/commands/generator_no_substitution.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../helper/override_print.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  late CommandRunner<int> runner;
  const bundlePath = 'example/core.json';
  final _outdir = Directory.systemTemp.createTempSync();
  setUpAll(() async {
    runner =
        CommandRunner<int>('mason_from', 'Create mason template from bundle')
          ..addCommand(CreateCommand());
  });
  group('FromGenerator', () {
    late MasonBundle bundle;
    test('[getBundle] creates a bundle from bundlePath (json)', () async {
      // final target = Directory.systemTemp.createTempSync();
      // final target2 = Directory.current;

      bundle = await FromGenerator.getBundle(bundlePath);
      expect(bundle, isNotNull);
      expect(bundle.name, isNotNull);
    });
    test('[generateBricks] can pass', () async {
      bundle = await FromGenerator.getBundle(bundlePath);
      final generator = await MasonGenerator.fromBundle(bundle);
      final target = DirectoryGeneratorTarget(_outdir, MockLogger());
      final fileCount = await generator.generateBricks(target);

      expect(fileCount, 228);
    });
  });

  group('CreateCommand args', () {
    test(
      '[description]',
      overridePrint(() async {
        await runner.run(['create', '-h']);
        expect(
          printLogs[0].split('\n')[0],
          'Create mason template from bundle',
        );
      }),
    );
    test(
      'run success',
      overridePrint(() async {
        final result =
            await runner.run(['create', '-b', bundlePath, _outdir.path]);
        expect(result, 228);
      }),
    );
  });
  group('error handle', () {
    test(
      '[description]',
      overridePrint(() async {
        try {
          await runner.run(['create']);
        } on UsageException catch (e) {
          expect(e.message, 'Output Path is empty.');
        }
      }),
    );
    test(
      '[usage error]',
      overridePrint(() async {
        try {
          await runner.run(['create', '-b', 'a', '.']);
        } on UsageException catch (e) {
          expect(
            e.message,
            'Example: mason_from create -b example/core.json .',
          );
        }
      }),
    );
  });
}
