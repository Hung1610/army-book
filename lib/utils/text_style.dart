import 'package:flutter/material.dart';

import 'index.dart';

TextStyle kStyle({
  Color? color,
  double? size,
  bool italize: false,
}) {
  return TextStyle(
    fontFamily: 'Robito',
    color: color ?? textColor,
    fontWeight: FontWeight.w500,
    fontSize: size ?? 15,
    fontStyle: italize ? FontStyle.italic : FontStyle.normal,
  );
}
