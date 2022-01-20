import 'dart:typed_data';

import 'package:army_book/models/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class CommonViewParam extends RouterParam {
  CommonViewParam({
    this.pageIndex,
  });

  // final List<List>? logBookEntries;
  final int? pageIndex;
}
