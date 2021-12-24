import 'package:momentum/momentum.dart';

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

    final logBook = LogBook(
      workdone: workdone.trim(),
      name: name.trim(),
      date: Timestamp.fromDateTime(model.entryDate!),
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
