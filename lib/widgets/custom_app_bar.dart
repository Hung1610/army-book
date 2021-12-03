import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_avatar.dart';
import 'package:flutter/material.dart';
import 'package:log_book/views/index.dart';

import 'package:log_book/widgets/index.dart';
import 'package:momentum/momentum.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;

  const CustomAppBar({Key key, @required this.child}) : super(key: key);

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
                  Expanded(child: MoveWindow()),
                  WindowButtons(),
                ],
              ),
            ),
            Expanded(
              child: CollapsibleSidebar(
                borderRadius: 5,
                items: [
                  CollapsibleItem(
                    text: 'Văn bản',
                    icon: Icons.assessment,
                    onPressed: () => {},
                    isSelected: true,
                  ),
                  CollapsibleItem(
                    text: 'Nhân sự',
                    icon: Icons.person,
                    onPressed: () => {},
                  ),
                  CollapsibleItem(
                    text: 'Cài đặt',
                    icon: Icons.settings,
                    onPressed: () => {},
                  ),
                ],
                sidebarBoxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    spreadRadius: 0.1,
                  ),
                ],
                titleBack: true,
                titleBackIcon: Icons.menu_book,
                // avatarImg: Container(
                //     child: new LimitedBox(
                //         maxHeight: 150,
                //         child: new Image(
                //             image: new AssetImage('assets/images/app_icon.png'),
                //             fit: BoxFit.scaleDown))),
                onTitleTap: () {
                  //custom callback function called when title avatar or back icon is pressed
                  MomentumRouter.goto(context, SplashView);
                },
                topPadding: 20, //space between image avatar and icons
                title: 'ArmyBook',
                body: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
