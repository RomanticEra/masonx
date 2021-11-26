/// To get a brickbrick from bundlebundle
library masonx;

import 'package:args/command_runner.dart';
import 'src/commands/bundle_from.dart';

/// public for share, entrypoint of command masonx
final masonx = CommandRunner<int>('masonx', 'Ext Cli of Mason')
  ..addCommand(BrickFromCommand())
  ..addCommand(BFCommand());
