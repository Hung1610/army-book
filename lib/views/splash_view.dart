import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:army_book/constants.dart';
import 'package:army_book/widgets/index.dart';

import 'index.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends MomentumState<SplashView> {
  _startTimer() {
    Duration duration = const Duration(milliseconds: 3000);
    return Timer(duration, _navigatorPage);
  }

  _navigatorPage() {
    MomentumRouter.clearHistoryWithContext(context);
    MomentumRouter.goto(context, HomeView);
  }

  @override
  void initMomentumState() {
    _startTimer();
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      child: Scaffold(
        body: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  SizedBox(height: height * 0.2),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          'Army',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          presetFontSizes: [
                            70,
                            65,
                            60,
                            55,
                            50,
                            45,
                            43,
                            40,
                            35,
                            30,
                            25,
                            20
                          ],
                        ),
                        Container(
                            child: new LimitedBox(
                                maxHeight: 150,
                                child: new Image(
                                    image: new AssetImage(
                                        'assets/images/app_icon.png'),
                                    fit: BoxFit.scaleDown))),
                        AutoSizeText(
                          'Book',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          presetFontSizes: [
                            70,
                            65,
                            60,
                            55,
                            50,
                            45,
                            43,
                            40,
                            35,
                            30,
                            25,
                            20
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sy(50)),
                  Center(
                    child: AutoSizeText(
                      '"Qu???n l?? c??ng v??n, gi??o tr??nh ????n gi???n, hi???u qu???"',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      presetFontSizes: [40, 35, 30, 25, 20, 17],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: customLoader(loaderType: 3, loaderText: ''),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, right: 30, left: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            '@2021',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            presetFontSizes: [15, 13, 11, 8],
                          ),
                          AutoSizeText(
                            '??H??ng ?????',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            presetFontSizes: [15, 13, 11, 8],
                          ),
                          AutoSizeText(
                            version,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            presetFontSizes: [15, 13, 11, 8],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
