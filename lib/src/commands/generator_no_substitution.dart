import 'dart:async';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

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
  /// override [generate]
  Future<int> generateBricks(DirectoryGeneratorTarget target) async {
    final nfiles = files.map((e) => FileProxy(e.path, e.content));
    await Future.forEach<FileProxy>(nfiles, (file) async {
      await target.createFile(file.path, file.content);
    });
    return files.length;
  }

  /// Get bundle
  static Future<MasonBundle> getBundle(String bundlePath) async {
    final jsonFile = File(bundlePath);
    final jsonStr = await jsonFile.readAsString();
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return MasonBundle.fromJson(json);
  }
}

/// Create
class CreateCommand extends Command<int> {
  /// construct of [CreateCommand]
  CreateCommand() {
    argParser.addOption(
      'bundle',
      abbr: 'b',
      help: 'The location of the bundle',
      defaultsTo: 'example/core.json',
    );
  }

  @override
  String get description => 'Create mason template from bundle';

  @override
  String get name => 'create';

  ArgResults get _argResults => argResults!;

  @override
  Future<int> run() async {
    if (_argResults.rest.isEmpty) {
      throw UsageException('Output Path is empty.', usage);
    }

    try {
      final bundle = await FromGenerator.getBundle(bundlePath);
      final generator = await MasonGenerator.fromBundle(bundle);

      final fileCount = await generator
          .generateBricks(DirectoryGeneratorTarget(_outputDirectory, Logger()));
      return fileCount;
    } catch (e) {
      throw UsageException(
        'Example: mason_from create -b example/core.json .',
        usage,
      );
    }
  }

  Directory get _outputDirectory {
    final rest = argResults!.rest;

    return Directory(rest.first);
  }

  /// Get bundlePath
  String get bundlePath {
    return argResults!['bundle'] as String;
  }
}
