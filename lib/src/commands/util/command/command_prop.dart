import 'dart:core';

import 'package:args/command_runner.dart';
import 'package:romantic_common/romantic_common.dart';

import 'business/add_options_extension.dart';

/// convert [CommandAdapter] to [Command]
class CommandAdapter<T, S> extends IExample<T> {
  /// adapter for command.
  CommandAdapter(
    this.name,
    this.example,
    this.desc,
    this.aliases,
    this.argParseConfigs,
  ) {
    argParser.addOptions();
  }
  @override
  final String name;

  @override
  final String example;

  @override
  final String desc;
  @override
  final List<String> aliases;

  /// Set the location with enum list for MasonParse
  final List<S> argParseConfigs;
}
