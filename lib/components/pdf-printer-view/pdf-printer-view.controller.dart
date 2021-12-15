import 'package:intl/intl.dart';
import 'package:army_book/components/router-params/pdf-printer-view.param.dart';
import 'package:army_book/constants.dart';
import 'package:army_book/models/app_response.dart';
import 'package:army_book/models/log_book.dart';
import 'package:momentum/momentum.dart';

import 'package:army_book/components/index.dart';
import 'package:army_book/services/index.dart';

import 'index.dart';

class PdfPrinterViewController extends MomentumController<PdfPrinterViewModel> {
  @override
  PdfPrinterViewModel init() {
    return PdfPrinterViewModel(
      this,
      loading: false,
    );
  }

  Future<void> bootstrapAsync() async {
    await getSingleLogbook(model.logBookId!);
  }

  /// get single logbook
  Future<void> getSingleLogbook(int index) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final response = await _service.getLogBookSingle(model.logBookId!);

    switch (response.action) {
      case ResponseAction.Success:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Success,
            message: response.message,
            title: 'Log Book',
          ),
        );
        break;

      case ResponseAction.Error:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Error,
            message: response.message,
            title: 'Log Book',
          ),
        );
        break;

      default:
    }

    model.update(loading: false, logBook: response.data);
    return;
  }

  /// update logbook
  Future<AppResponse> updateLogBook(LogBook logBook) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final response = await _service.updateLogBook(logBook);

    switch (response.action) {
      case ResponseAction.Success:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Success,
            message: response.message,
            title: 'Nội dung',
          ),
        );
        break;

      case ResponseAction.Error:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Error,
            message: response.message,
            title: 'Nội dung',
          ),
        );
        break;

      default:
    }

    model.update(loading: false);

    // write contents to pdf file
    return AppResponse(
      data: logBook,
      action: ResponseAction.Success,
      message: 'Nội dung đã lưu',
    );
  }

  // @override
  // Future<void> bootstrapAsync() async {
  //   await _processRecords();
  // }

  // /// translate logbook model to printable strings
  // Future<void> _processRecords() async {
  //   final _service = service<AppService>();
  //   model.update(loading: true);

  //   // final response = await _service.getLogBooks(descendSort: true);

  //   // // TODO: Got lazy to check response action here
  //   // final _logBooks = response.data;

  //   // List<List> _entries = [];

  //   // for (var entry in _logBooks) {
  //   //   List<String> innerList = [
  //   //     _formatDate(entry.date.toDateTime()),
  //   //     entry.workdone,
  //   //     '' // signature will be included manually by supervisor here when printed, for now
  //   //   ];

  //   //   _entries.add(innerList);
  //   // }

  //   // List<List> data = List<List>.from(model.logBookEntries!);
  //   // data.addAll(_entries);

  //   final data = MomentumRouter.getParam<PdfPrinterViewParam>(context);

  //   model.update(logBook: data, loading: false);
  // }

  String _formatDate(DateTime date) {
    final format = DateFormat('dd/M/yyyy', 'en_US');

    return format.format(date);
  }
}
