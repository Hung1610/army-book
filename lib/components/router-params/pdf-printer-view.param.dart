import 'dart:typed_data';

import 'package:army_book/models/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class PdfPrinterViewParam extends RouterParam {
  PdfPrinterViewParam({
    this.logBookId,
  });

  // final List<List>? logBookEntries;
  final int? logBookId;
}
