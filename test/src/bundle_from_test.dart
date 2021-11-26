import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../helper/override_print.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  final runner = masonx;
  const bundlePath = 'example/core.json';
  const hookPath = 'example/hook.json';
  var _outdir = Directory.systemTemp.createTempSync();
  setUpAll(() async {
    _outdir = Directory.systemTemp.createTempSync();
  });

  group('FromGenerator', () {
    late MasonBundle bundle;
    test('[FromGenerator.getBundle]', () async {
      bundle = await FromGenerator.getBundle(bundlePath);
      expect(bundle, isNotNull);
      expect(bundle.name, isNotNull);
    });
    test('[generator.generateBricks]', () async {
      bundle = await FromGenerator.getBundle(bundlePath);
      final generator = await MasonGenerator.fromBundle(bundle);
      final target = DirectoryGeneratorTarget(_outdir, MockLogger());
      final fileCount = await generator.generateBricks(target);

      expect(fileCount, 228);
    });
    test('[generateHooks]', () async {
      final jsonFile = File(hookPath);
      final jsonStr = await jsonFile.readAsString();
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      (json['hooks'] as List<dynamic>)
        ..removeAt(0)
        ..remove('hooks.preGen');
      bundle = MasonBundle.fromJson(json);

      final generator = await MasonGenerator.fromBundle(bundle);
      final target = DirectoryGeneratorTarget(_outdir, MockLogger());
      final fileCount = await generator.generateHooks(target);

      expect(fileCount, 1);
    });
  });

  group('[Usually Command Run] `mason bf bundlePath outdir`', () {
    test(
      '[description]',
      overridePrint(() async {
        await runner.run(['bf', '-h']);
        expect(
          printLogs[0].split('\n')[0],
          'Get brick template from bundle or dart.',
        );
      }),
    );
    test(
      'run success',
      () async {
        final result = await runner.run(['bf', bundlePath, _outdir.path]);
        expect(result, 228);
      },
    );
    test(
      'run with hook',
      () async {
        final result = await runner.run(['bf', hookPath, _outdir.path]);
        expect(result, 3);
      },
    );
  });
  group('[Command Arg](input error)', () {
    test(
      '[No Input](masonx bf)',
      overridePrint(() async {
        try {
          await runner.run(['bf']);
        } on ExException catch (e) {
          expect(
            e.message,
            'Could not find a input path for "masonx bundleF".',
          );
        }
      }),
    );
    test(
      '[Wrong Input](masonx bf noExistFile outdir)',
      overridePrint(() async {
        try {
          await runner.run(['bf', 'a', '.']);
        } on ExException catch (e) {
          expect(
            e.message,
            '''Could not find a input file for "masonx bundleF".''',
          );
        }
      }),
    );
  });
  group('[Command Arg]output', () {
    test(
      '(loss output path)',
      overridePrint(() async {
        try {
          await runner.run(['bf', bundlePath]);
        } on ExException catch (e) {
          expect(
            e.message,
            'Could not find a output path for "masonx bundleF".',
          );
        }
      }),
    );
  });
}
