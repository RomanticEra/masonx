import 'package:mason/src/command_runner.dart' show MasonCommandRunner;
import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util/util.dart';
import 'package:romantic_common/romantic_common.dart';

Future<void> main(List<String> args) async {
  try {
    await masonx.run(args);
    // ignore: nullable_type_in_catch_clause
  } on ExException catch (e) {
    logger.err('Masonx catch ${e.toString()}');
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    logger.err('Masonx no catch ${e.toString()}');
    // rethrow;
    await MasonCommandRunner().run(args);
  }
}
