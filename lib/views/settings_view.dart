import 'package:army_book/components/settings-view/index.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import 'package:army_book/widgets/index.dart';
import 'package:relative_scale/relative_scale.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends MomentumState<SettingView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initMomentumState() {
    super.initMomentumState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      child: SafeArea(
        child: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return CustomAppBar(
              child: Scaffold(
                body: MomentumBuilder(
                    controllers: [SettingsViewController],
                    builder: (context, snapshot) {
                      return Text('Trang này đang trong quá trình phát triển');
                    }),
              ),
            );
          },
        ),
      ),
    );
  }
}
