// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'package:mason/mason.dart';
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util/index.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  final runner = masonx;
  const hookPath = 'example/hook.json';

  group('[Usually Command Run] `mason bf bundlePath outdir`', () {
    test('[generator.getAllContent][hook]', () async {
      final bundle = await FromGenerator.getBundle(hookPath);
      final generator = await MasonGenerator.fromBundle(bundle);

      final allConent = generator.getAllContent();

      expect(
        allConent,
        'Hi {{name}}!'
        "import 'dart:io';"
        "void main(){final file=File('.pre_gen.txt');"
        "file.writeAsStringSync('pre_gen: {{name}}');}"
        "import 'dart:io';void main(){final file=File('.post_gen.txt');"
        "file.writeAsStringSync('post_gen: {{name}}');}",
      );
    });
    test('[generator.genConfig][hook]', () async {
      // final bundle = await FromGenerator.getBundle(bundlePath);
      // final generator = await MasonGenerator.fromBundle(bundle);

      // final config = generator.getConfig;

      // expect(config, config);
      await runner.run([
        'gc',
        'example/dart_cli_factory.bundle',
      ]);
      expect(
        File('./dart_cli_factory-config-example.json').readAsStringSync(),
        '{"username":"{{username}}","project_name":"{{project_name}}","# pascalCase":"{{# pascalCase}}","/ pascalCase":"{{/ pascalCase}}","description":"{{description}}","matrix":{"os":"{{matrix.os}}"},"secrets":{"CREDENTIAL_JSON":"{{secrets.CREDENTIAL_JSON}}"}}',
      );
    });
  });
}
