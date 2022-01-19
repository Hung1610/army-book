import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:army_book/utils/color_themes.dart';
import 'package:army_book/views/index.dart';

import 'package:army_book/widgets/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momentum/momentum.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;

  const CustomAppBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                      child: MoveWindow(
                          child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff2B3138),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.5),
                      //     spreadRadius: 5,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                  ))),
                  WindowButtons(),
                ],
              ),
            ),
            Expanded(
                child: Container(
              color: mainColor,
              child: CollapsibleSidebar(
                backgroundColor: Colors.transparent,
                unselectedTextColor: Colors.blueGrey,
                unselectedIconColor: Colors.red.shade900,
                selectedIconColor: Colors.red.shade400,
                borderRadius: 4,
                items: [
                  CollapsibleItem(
                    text: 'Văn bản',
                    icon: CupertinoIcons.doc_richtext,
                    onPressed: () => MomentumRouter.goto(context, HomeView),
                    isSelected: true,
                  ),
                  CollapsibleItem(
                    text: 'Cài đặt',
                    icon: CupertinoIcons.settings,
                    onPressed: () => MomentumRouter.goto(context, SettingView),
                  ),
                ],
                sidebarBoxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 100,
                    spreadRadius: 1,
                  ),
                ],
                titleBack: true,
                titleBackIcon: Icons.menu_book,
                // avatarImg: AssetImage('assets/images/app_icon.png'),
                onTitleTap: () {
                  //custom callback function called when title avatar or back icon is pressed
                  MomentumRouter.goto(context, SplashView);
                },
                topPadding: 20, //space between image avatar and icons
                title: 'ArmyBook',
                body: child,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
