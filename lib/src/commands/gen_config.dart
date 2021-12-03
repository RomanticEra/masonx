import 'dart:convert';

// ignore: prefer_relative_imports
import 'package:masonx/masonx.dart';
import 'package:universal_io/io.dart';

import 'util/command/business/index.dart';
import 'util/index.dart';
// import 'package:universal_io/io.dart';

/// const String Example
const String exampleKey = 'Example: masonx gen_config xxx/bundle.bundle .';

/// GenConfigCommand
class GenConfigCommand extends MasonCommandBase {
  /// {@macro PatchCommand}
  GenConfigCommand()
      : super(
          'gc',
          exampleKey,
          'Get brick config from bundle.',
          ['gen_config'],
          [MasonParseEnum.bundlePath],
        );
  @override
  Future<int> handle() async {
    final generator = await this.generator;
    final file = File(['.', '$projectName-config-example.json'].join('/'));
    await file.create(recursive: true);
    file.writeAsStringSync(
      json.encode(
        generator.genConfig(),
      ),
    );
    logger.info('config output is: ${file.path}');
    return 0;
  }
}
