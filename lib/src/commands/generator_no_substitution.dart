import 'dart:async';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';
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
  /// override [generate] for [hooks]
  Future<int> generateHooks(DirectoryGeneratorTarget target) async {
    final nfiles = [
      if (hooks.preGen != null)
        FileProxy(hooks.preGen!.path, hooks.preGen!.content),
      if (hooks.postGen != null)
        FileProxy(hooks.postGen!.path, hooks.postGen!.content)
    ];
    await Future.forEach<FileProxy>(nfiles, (file) async {
      await target.createFile(file.path, file.content);
    });
    return files.length;
  }

  /// override [generate] for [files]
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

      // handle brick.yaml gen
      final brickYamlFile =
          File([_outputPath, projectName, 'brick.yaml'].join('/'));
      await brickYamlFile.create(recursive: true);

      brickYamlFile.writeAsStringSync(
        json2yaml(
          bundle.toJson()
            ..remove('files')
            ..remove('hooks'),
        ),
      );
      // handle __brick__ gen
      await projectDirectory.create(recursive: true);

      final fileCount = await generator
          .generateBricks(DirectoryGeneratorTarget(projectDirectory, Logger()));
      final hookCount = await generator
          .generateHooks(DirectoryGeneratorTarget(hookDirectory, Logger()));
      return fileCount + hookCount;
    } catch (e) {
      throw UsageException(
        'Example: mason_from create -b example/core.json .',
        usage,
      );
    }
  }

  String get _outputPath => argResults!.rest.first;
  // Directory get _outputDirectory {
  //   return Directory(_outputPath);
  // }

  /// where is __brick__ at. Example: [_outputPath]/brick_factory/__brick__
  Directory get projectDirectory {
    return Directory([_outputPath, projectName, '__brick__'].join('/'));
  }

  /// where is __brick__ at. Example: [_outputPath]/brick_factory/hooks
  Directory get hookDirectory {
    return Directory([_outputPath, projectName, 'hooks'].join('/'));
  }

  /// Get bundlePath
  String get bundlePath {
    return argResults!['bundle'] as String;
  }

  /// Get projectName, Example: bricks/brick_factory => brick_factory
  String get projectName => basenameWithoutExtension(bundlePath);
}
