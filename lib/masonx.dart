/// To get a brickbrick from bundlebundle
library masonx;

import 'package:args/command_runner.dart';
// ignore: implementation_imports
import 'package:mason/src/command_runner.dart' show MasonCommandRunner;

import 'src/commands/bundle_from.dart';

final _mason = MasonCommandRunner();
final String _usage = _mason.usage.split('\n').skip(2).join('\n');

/// public for share, entrypoint of command masonx
final masonx = CommandRunner<int>(
  'masonx',
  'Ext Cli of Mason,\n'
      '-----------------------------------------------\n'
      '$_usage\n'
      '-----------------------------------------------\n',
)..addCommand(BrickFromCommand());
