import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

import 'package:army_book/components/index.dart';
import 'package:army_book/services/index.dart';
import 'package:army_book/utils/index.dart';
import 'package:army_book/views/index.dart';
import 'package:army_book/widgets/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(momentum());

  doWhenWindowReady(() {
    final win = appWindow;

    final initialSize = Size(1200, 680);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Quản lý công văn";
    //win.maximize();
    win.show();
  });
}

Momentum momentum() => Momentum(
      key: UniqueKey(),
      restartCallback: main,
      child: MyApp(),
      appLoader:
          customLoader(loaderText: 'Initializing...', isInitLoader: true),
      controllers: [
        HomeViewController()..config(lazy: true),
        PdfPrinterViewController()..config(lazy: true),
      ],
      services: [
        DialogService(),
        AppService(),
        MomentumRouter(
          [
            SplashView(),
            HomeView(),
            PdfGenView(),
            SettingView(),
          ],
        ),
      ],
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quản lý công văn',
        theme: colorTheme,
        home: Scaffold(
          body: WindowBorder(
            color: borderColor,
            width: 3,
            child: MomentumRouter.getActivePage(context),
          ),
        ),
      );
}
