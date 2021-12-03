// ignore_for_file: public_member_api_docs

import 'package:romantic_common/romantic_common.dart';

import '../../index.dart';
import '../index.dart';
import 'add_options_extension.dart';
import 'mason_prop_mixin.dart';

abstract class IMasonCommandBase extends CommandAdapter<int, MasonParseEnum>
    implements IArgument2Statistical<MasonParseEnum>, IExample<int> {
  IMasonCommandBase(
    String name,
    String example,
    String desc,
    List<String> aliases,
    List<MasonParseEnum> argParseConfigs,
  ) : super(name, example, desc, aliases, argParseConfigs);
}

class MasonCommandBase extends IMasonCommandBase
    with MasonPropMixin, MasonModelExt, RunMixin<int, MasonParseEnum> {
  MasonCommandBase(
    String name,
    String example,
    String desc,
    List<String> aliases,
    List<MasonParseEnum> argParseConfigs,
  ) : super(name, example, desc, aliases, argParseConfigs);
}
