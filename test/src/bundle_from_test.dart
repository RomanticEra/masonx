import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util/index.dart';
import 'package:mocktail/mocktail.dart';
import 'package:romantic_common/romantic_common.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../helper/override_print.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  final runner = masonx;
  const bundlePath = 'example/core.json';
  const hookPath = 'example/hook.json';
  final _outdir = Directory.systemTemp.createTempSync();

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
      'run success',
      () async {
        final result = await runner.run(['bf', '-j$bundlePath', _outdir.path]);
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
            'bundle-path cloud not find.',
          );
        }
      }),
    );
    test(
      '[Wrong Input](masonx bf noExistFile outdir)',
      overridePrint(() async {
        try {
          await runner.run(['bf', 'a', _outdir.path]);
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
            'output-dir cloud not find.',
          );
        }
      }),
    );
  });
  group('[DecodeBundleCommand]', () {
    overridePrint(
      () => test(
        'decode from bundle[base64]',
        () async {
          printLogs = [];
          await runner.run(['db', hookPath]);
          expect(printLogs, [
            '''{"files":[{"path":"hooks.md","data":"Hi {{name}}!","type":"text"}],"hooks":[{"path":"post_gen.dart","data":"import 'dart:io';void main(){final file=File('.post_gen.txt');file.writeAsStringSync('post_gen: {{name}}');}","type":"text"},{"path":"pre_gen.dart","data":"import 'dart:io';void main(){final file=File('.pre_gen.txt');file.writeAsStringSync('pre_gen: {{name}}');}","type":"text"}],"name":"hooks","description":"A Hooks Example Template","vars":["name"]}'''
          ]);
        },
      ),
    );
  });
}
