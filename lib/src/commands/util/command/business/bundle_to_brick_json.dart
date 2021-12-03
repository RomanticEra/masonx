import 'package:mason/mason.dart';

/// toBrickJson
extension ToBrickJson on MasonBundle {
  /// ```dart
  /// brickWriteYamlFile.writeAsStringSync(
  ///   json2yaml(bundle.toBrickJson),
  /// );
  /// ```
  Map<String, dynamic> get toBrickJson => toJson()
    ..remove('files')
    ..remove('hooks');
}
