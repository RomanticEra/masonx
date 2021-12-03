import 'package:mason/mason.dart';

/// a publish logger api
Logger logger = Logger();

/// A Proxy for TemplateFile
class FileProxy {
  /// Create a [FileProxy]
  FileProxy(this.path, this.content);

  /// prop path;
  final String path;

  /// prop path;
  final List<int> content;
}
