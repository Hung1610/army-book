import 'package:army_book/components/settings-view/index.dart';
import 'package:army_book/utils/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
                      return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.orange,
                                size: sy(50),
                              ),
                              AutoSizeText(
                                'Trang này đang trong quá trình phát triển',
                                style: kStyle(),
                                minFontSize: 16,
                              )
                            ]),
                      );
                    }),
              ),
            );
          },
        ),
      ),
    );
  }
}
