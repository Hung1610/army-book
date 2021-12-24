// app global color
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

final ThemeData colorTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: bgColor,
  scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto',
  canvasColor: secondaryColor,
);

const priColor = Colors.black;
const secondaryColor = Colors.white;
const bgColor = Colors.white;

final textColor = Colors.black.withOpacity(0.6);

final whiteColor = Colors.white.withOpacity(0.9);
final mainColor = Colors.white;

const defaultPadding = 16.0;

final borderColor = mainColor;

final buttonColors = WindowButtonColors(
  iconNormal: priColor,
  mouseOver: secondaryColor,
  mouseDown: secondaryColor,
  iconMouseOver: Colors.white,
  iconMouseDown: secondaryColor,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: Color(0xFFD32F2F),
  mouseDown: Color(0xFFB71C1C),
  iconNormal: priColor,
  iconMouseOver: Colors.white,
);
