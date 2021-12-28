import 'dart:io';

import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:momentum/momentum.dart';

import 'package:path_provider/path_provider.dart';
import 'package:army_book/components/index.dart';
import 'package:army_book/constants.dart';
import 'package:army_book/models/index.dart';
import 'package:army_book/services/index.dart';
import 'package:sembast/timestamp.dart';

import 'index.dart';

class HomeViewController extends MomentumController<HomeViewModel> {
  @override
  HomeViewModel init() {
    return HomeViewModel(
      this,
      sideBarSignal: SideBarSignal.None,
      loading: false,
      sideBarLoading: false,
      todos: [],
      logBooks: [],
      selectedFile: null,
      entryDate: DateTime.now(),
      viewMode: ViewMode.List,
    );
  }

  Future<void> bootstrapAsync() async {
    model.update(
        nameSearch: '',
        toSearchDate: null,
        fromSearchDate: null,
        updateToDateFilter: true,
        updateFromDateFilter: true,
        sideBarSignal: SideBarSignal.None);
    // await loadTodos();
    await loadLogBooks();
  }

  Future<void> filterDocs() async {
    model.update(sideBarSignal: SideBarSignal.None);
    // await loadTodos();
    await loadLogBooks(
        name: model.nameSearch,
        from: model.fromSearchDate,
        to: model.toSearchDate);
  }

  /// load all todos
  Future<void> loadTodos() async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final response = await _service.getTodos();

    switch (response.action) {
      case ResponseAction.Success:
        // update model
        List<Todo> todos = response.data;
        var _todos = List<Todo>.from(model.todos!);

        _todos.addAll(todos);

        model.update(todos: _todos);

        break;

      case ResponseAction.Error:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Error,
            message: response.message,
            title: 'ToDo',
          ),
        );
        break;

      default:
    }

    model.update(loading: false);
  }

  /// load all logbooks
  /// TODO: Use streams
  Future<void> loadLogBooks(
      {String? name: null, DateTime? from: null, DateTime? to: null}) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);
    await Future.delayed(Duration(seconds: 1));

    final response = await _service.getLogBooks(name: name, from: from, to: to);

    switch (response.action) {
      case ResponseAction.Success:
        // update model
        List<LogBook> logbooks = response.data;
        // var _logbooks = List<LogBook>.from(model.logBooks!);

        // _logbooks.addAll(logbooks);

        model.update(logBooks: logbooks);

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

    model.update(loading: false);
  }

  /// update logbook
  Future<void> updateLogBook(LogBook logBook) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    String? filePath;

    if (model.selectedFile != null && model.selectedFile!.path.isNotEmpty) {
      final format = DateFormat('dd-M-yyyy_HH.mm.ss', 'en_US');

      String _time = format.format(DateTime.now());

      final appDocumentDir = await getApplicationDocumentsDirectory();

      final String fileName = '$_time _${basename(model.selectedFile!.path)}';
      final String _subDir = 'LogBook';
      final String _logBkDir = join(appDocumentDir.path, _subDir);

      await new File(_logBkDir).create(recursive: true);

      File newFile = await model.selectedFile!.copy(_logBkDir);
      await newFile.rename(fileName);

      filePath = join(_logBkDir, fileName);
    }

    logBook.filePath = filePath;

    final response = await _service.updateLogBook(logBook);

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

    model.update(loading: false);
  }

  void sendTodoDeleteSignal(int index) {
    sendEvent(
      AppEvent(
        action: ResponseEventAction.DeleteTodo,
        message: 'Are you sure you want to delete this todo?',
        title: 'Delete Todo',
        data: index,
      ),
    );
  }

  void sendLogDeleteSignal(int index) {
    sendEvent(
      AppEvent(
        action: ResponseEventAction.DeleteLogEntry,
        message: 'Are you sure you want to delete this log book entry?',
        title: 'Delete Log Book Entry',
        data: index,
      ),
    );
  }

  /// delete logbook
  Future<void> deleteLogBook(int index) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final logBook = model.logBooks!.elementAt(index);

    final response = await _service.deleteLogBook(logBook);

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

    model.update(loading: false);
  }

  /// add logbook
  Future<void> insertLogBook(String workdone, String name) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    String? filePath;

    if (model.selectedFile != null && model.selectedFile!.path.isNotEmpty) {
      final format = DateFormat('dd-M-yyyy_HH.mm.ss', 'en_US');

      String _time = format.format(DateTime.now());

      final appDocumentDir = await getApplicationDocumentsDirectory();

      final String fileName = '$_time _${basename(model.selectedFile!.path)}';
      final String _subDir = 'LogBook';
      final String _logBkDir = join(appDocumentDir.path, _subDir);

      await new File(_logBkDir).create(recursive: true);

      File newFile = await model.selectedFile!.copy(_logBkDir);
      await newFile.rename(fileName);

      filePath = join(_logBkDir, fileName);
    }

    final logBook = LogBook(
      workdone: workdone.trim(),
      name: name.trim(),
      date: Timestamp.fromDateTime(model.entryDate!),
      filePath: filePath,
    );

    final response = await _service.addLogBook(logBook);

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

    model.update(loading: false);
  }

  /// delete todo
  Future<void> deleteTodo(int index) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final todo = model.todos!.elementAt(index);

    final response = await _service.deleteTodo(todo);

    switch (response.action) {
      case ResponseAction.Success:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Success,
            message: response.message,
            title: 'Todo',
          ),
        );
        break;

      case ResponseAction.Error:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Error,
            message: response.message,
            title: 'Todo',
          ),
        );
        break;

      default:
    }

    model.update(loading: false);
  }

  /// add todo
  Future<void> addTodo(String newTodo) async {
    // service DI
    final _service = service<AppService>();

    model.update(loading: true);

    final todo = Todo(
      todo: newTodo.trim(),
      createdOn: Timestamp.now(),
    );

    final response = await _service.addTodo(todo);

    switch (response.action) {
      case ResponseAction.Success:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Success,
            message: response.message,
            title: 'Todo',
          ),
        );
        break;

      case ResponseAction.Error:
        sendEvent(
          AppEvent(
            action: ResponseEventAction.Error,
            message: response.message,
            title: 'Todo',
          ),
        );
        break;

      default:
    }

    model.update(loading: false);
  }
}
