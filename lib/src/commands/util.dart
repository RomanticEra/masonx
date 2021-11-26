import 'dart:async';
import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

import 'bundle_from.dart';
export 'package:mason/mason.dart';

/// to split Exception between mason and masonx
class ExException extends UsageException {
  // ignore: public_member_api_docs
  ExException(String message, String usage) : super(message, usage);
}

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

/// Extension
extension FromGenerator on MasonGenerator {
  /// logger for [MasonGenerator]
  void Function([String? update]) get generateDone =>
      logger.progress('Doing $id');

  /// override [generate] for [hooks]
  Future<int> generateHooks(DirectoryGeneratorTarget target) async {
    final nfiles = [
      if (hooks.preGen != null)
        FileProxy(hooks.preGen!.path, hooks.preGen!.content),
      if (hooks.postGen != null)
        FileProxy(hooks.postGen!.path, hooks.postGen!.content)
    ];
    return writeWithBundleFileProxy(nfiles, target);
  }

  /// override [generate] for [files]
  Future<int> generateBricks(DirectoryGeneratorTarget target) async {
    final nfiles = files.map((e) => FileProxy(e.path, e.content)).toList();

    return writeWithBundleFileProxy(nfiles, target);
  }

  /// Get bundle
  static Future<MasonBundle> getBundle(String bundlePath) async {
    try {
      final jsonFile = File(bundlePath);
      final jsonStr = await jsonFile.readAsString();
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return MasonBundle.fromJson(json);
    } on FileSystemException catch (e) {
      if ('Cannot open file' == e.message) {
        throw ExException(
          '''Could not find a input file for "masonx bundleF".''',
          exampleKey,
        );
      }
      rethrow;
    }
  }

  /// template for write Local with Bundle [FileProxy]
  Future<int> writeWithBundleFileProxy(
    List<FileProxy> nfiles,
    DirectoryGeneratorTarget target,
  ) async {
    await Future.forEach<FileProxy>(nfiles, (file) async {
      generateDone(file.path);
      await target.createFile(file.path, file.content);
    });
    generateDone('${nfiles.length}');
    return nfiles.length;
  }
}
