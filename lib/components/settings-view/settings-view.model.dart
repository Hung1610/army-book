import 'dart:io';

import 'package:momentum/momentum.dart';

import 'package:army_book/constants.dart';
import 'package:army_book/models/index.dart';

import 'index.dart';

class SettingsViewModel extends MomentumModel<SettingsViewController> {
  SettingsViewModel(SettingsViewController controller) : super(controller);

  @override
  void update() {
    SettingsViewModel(
      controller,
    ).updateMomentum();
  }
}
