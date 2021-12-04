/// To get a brickbrick from bundlebundle
// library masonx;

import 'package:args/command_runner.dart';
// ignore: implementation_imports
import 'package:mason/src/command_runner.dart' show MasonCommandRunner;

import 'commands/bundle_from.dart';
import 'commands/decode_bundle.dart';
import 'commands/gen_config.dart';
import 'commands/patch.dart';

/// origin software
final mason = MasonCommandRunner();
final String _usage = mason.usage.split('\n').skip(2).join('\n');

/// public for share, entrypoint of command masonx
final masonx = CommandRunner<int>(
  'masonx',
  'Ext Cli of Mason,\n'
      '-----------------------------------------------\n'
      '$_usage\n'
      '-----------------------------------------------\n',
)
  ..addCommand(BrickFromCommand())
  ..addCommand(GenConfigCommand())
  ..addCommand(DecodeBundleCommand())
  ..addCommand(PatchCommand());
