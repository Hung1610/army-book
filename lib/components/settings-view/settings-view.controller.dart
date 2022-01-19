import 'dart:io';

import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:momentum/momentum.dart';

import 'package:path_provider/path_provider.dart';
import 'package:army_book/components/index.dart';
import 'package:army_book/constants.dart';
import 'package:army_book/models/index.dart';
import 'package:army_book/services/index.dart';
import 'package:sembast/timestamp.dart';

import 'index.dart';

class SettingsViewController extends MomentumController<SettingsViewModel> {
  @override
  SettingsViewModel init() {
    return SettingsViewModel(this);
  }

  Future<void> bootstrapAsync() async {}
}
