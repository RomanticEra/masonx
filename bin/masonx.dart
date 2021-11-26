import 'package:masonx/masonx.dart';
import 'package:masonx/src/commands/util.dart';

Future<void> main(List<String> args) async {
  try {
    await masonx.run(args);
  } catch (e) {
    logger.err(e.toString());
    rethrow;
  }
}
