// ignore_for_file: public_member_api_docs
// coverage:ignore-file
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

/// common util for [Command]
extension AddOptions on ArgParser {
  /// common util for [Command]
  void addOutputOptions() {
    addOption(
      'output-dir',
      abbr: 'o',
      help: 'Directory where to output the generated code.',
    );
  }

  /// common util for [Command]
  void addInputOptions() {
    addOption(
      'config-path',
      abbr: 'c',
      help: 'Path to config json file containing variables.',
      aliases: ['config'],
    );
    addOption(
      'brick-dir',
      abbr: 'b',
      help: 'Directory where to get brick the generated code.',
    );
    addOption(
      'brick-key',
      abbr: 'k',
      help: 'key about brick in list',
    );
    addOption(
      'bundle-path',
      abbr: 'j',
      help: 'File where to get bundle(json,bundle) the generated code.',
      aliases: ['json', 'json-path'],
    );
  }

  /// all options config
  void addOptions() {
    addInputOptions();
    addOutputOptions();
  }
}

enum MasonParseEnum {
  bundlePath,
  outputDir,
  configPath,
  // brickDir,
  brickKey,
}
