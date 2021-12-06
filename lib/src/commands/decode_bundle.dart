import 'dart:convert';

// ignore: prefer_relative_imports
import 'package:masonx/masonx.dart';
import 'package:universal_io/io.dart';

import 'util/command/business/index.dart';
import 'util/index.dart';
// import 'package:universal_io/io.dart';

/// const String Example
const String exampleKey = 'Example: masonx db bundle.bundle .';

/// GenConfigCommand
class DecodeBundleCommand extends MasonCommandBase {
  /// {@macro PatchCommand}
  DecodeBundleCommand()
      : super(
          'db',
          exampleKey,
          'To Decode bundle from base64.',
          ['decode_bundle'],
          [MasonParseEnum.bundlePath, MasonParseEnum.outputDir],
        );
  @override
  Future<int> handle() async {
    final brickJson = (await bundle).toJson();
    (brickJson['hooks'] as List<Map<String, dynamic>>)
        .forEach(decodeBase64OnMason);
    (brickJson['files'] as List<Map<String, dynamic>>)
        .forEach(decodeBase64OnMason);
    try {
      final file = File([outputDir, '$projectName-decode.json'].join('/'));
      await file.create(recursive: true);
      file.writeAsStringSync(
        json.encode(brickJson),
      );
      logger.info('config output is: ${file.path}');
    } on FormatException catch (e) {
      if (e.message == 'output-dir cloud not find.') {
        logger.info(json.encode(brickJson));
        return 0;
      }
      rethrow;
    }
    return 0;
  }
}

/// DecodeBase64OnMason
void decodeBase64OnMason(Map<String, dynamic> _map) {
  _map['data'] = (_map['data']! as String).decodeBase64;
}

// /// DecodeBase64OnMason
// extension DecodeBase64OnMason on Map<String, String> {
//   /// DecodeBase64OnMason
//   void decodeBase64OnMason() {
//     this['data'] = this['data']!.decodeBase64;
//   }
// }

/// Decode Base64
extension DecodeBase64OnString on String {
  /// to normal string
  String get decodeBase64 => String.fromCharCodes(base64.decode(this));
}

/// Decode Base64
// extension DecodeBase64OnList<T> on List<T> {
//   /// to normal string
//   List<T> get decodeBase64OnValue => map<T>((e) {
//         if (e is String) return e.decodeBase64 as T;
//         if (e is Map<String, String>) return e.decodeBase64OnValue as T;
//         return e;
//       }).toList();
// }

// /// Decode Base64
// extension DecodeBase64OnMap on Map<String, dynamic> {
//   /// to normal map
//   Map<String, dynamic> get decodeBase64OnValue {
//     final _map = this;
//     return _map
//       // ignore: avoid_annotating_with_dynamic
//       ..forEach((key, dynamic value) {
//         if (value is Map<String, dynamic>) {
//           _map[key] = value.decodeBase64OnValue;
//         }
//         if (value is List<Map<String, dynamic>>) {
//           _map[key] = value.map((e) => e.decodeBase64OnValue).toList();
//         }
//         if (value is List<String>) {
//           _map[key] = value.decodeBase64OnValue;
//         }
//         if (value is String) {
//           _map[key] = value.decodeBase64;
//         }
//       });
//   }
// }
