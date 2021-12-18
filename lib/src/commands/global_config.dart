// coverage:ignore-file
import 'package:romantic_common/romantic_common.dart';
import 'package:universal_io/io.dart';

import 'util/command/business/index.dart';
import 'util/index.dart';

/// ConfigCommand
class ConfigCommand extends MasonCommandBase {
  /// {@macro PatchCommand}
  ConfigCommand()
      : super('config', '', 'show or init global config', ['c'], []) {
    argParser
      ..addFlag('list', abbr: 'l', help: 'show info of mason-cache.')
      ..addFlag('init', abbr: 'i', help: 'generate a global mason-cache.')
      ..addFlag('edit', abbr: 'e', help: 'edit global mason-cache.');
  }
  @override
  Future<int> handle() async {
    if (results['list'] as bool) {
      logger.info(
        [rootDir().path, '.config.json']
            .join('/')
            .getFileWithJsonSync
            .toString(),
      );
      return 0;
    }
    if (results['init'] as bool) {
      final file = File([rootDir().path, '.config.json'].join('/'));
      await file.create(recursive: true);
      if (file.existsSync()) {
        logger.err('InitConfig is existed, use config -l to check.');
      } else {
        file.writeAsStringSync('{}');
      }
      return 0;
    }
    if (results['edit'] as bool) {
      await Process.run('code', [
        [rootDir().path, '.config.json'].join('/')
      ]);
      return 0;
    }

    return -1;
  }
}
