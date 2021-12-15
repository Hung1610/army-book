import 'dart:typed_data';

import 'package:army_book/models/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class PdfPrinterViewModel extends MomentumModel<PdfPrinterViewController> {
  PdfPrinterViewModel(
    PdfPrinterViewController controller, {
    // this.logBookEntries,
    this.logBookId,
    this.logBook,
    this.loading,
    this.logBookData,
  }) : super(controller);

  // final List<List>? logBookEntries;
  final int? logBookId;
  final LogBook? logBook;
  final Uint8List? logBookData;
  final bool? loading;

  @override
  void update({
    int? logBookId,
    LogBook? logBook,
    bool? loading,
    Uint8List? logBookData,
  }) {
    PdfPrinterViewModel(
      controller,
      loading: loading ?? this.loading,
      logBook: logBook ?? this.logBook,
      logBookId: logBookId ?? this.logBookId,
      // logBookEntries: logBookEntries ?? this.logBookEntries,
      logBookData: logBookData ?? this.logBookData,
    ).updateMomentum();
  }
}
