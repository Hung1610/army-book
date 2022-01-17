import 'dart:io';

import 'package:momentum/momentum.dart';

import 'package:army_book/constants.dart';
import 'package:army_book/models/index.dart';

import 'index.dart';

class HomeViewModel extends MomentumModel<HomeViewController> {
  HomeViewModel(
    HomeViewController controller, {
    this.todos,
    this.logBooks,
    this.loading,
    this.sideBarLoading,
    this.sideBarSignal,
    this.entryDate,
    this.selectedFile,
    this.nameSearch,
    this.fromSearchDate,
    this.toSearchDate,
    this.viewMode,
    this.editLogBook,
    this.dropdownValue,
    this.searchType,
  }) : super(controller);

  final SideBarSignal? sideBarSignal;
  final List<Todo>? todos;
  final List<LogBook>? logBooks;
  final bool? loading;
  final DateTime? entryDate;
  final File? selectedFile;
  final String? nameSearch;
  final DateTime? fromSearchDate;
  final DateTime? toSearchDate;
  final bool? sideBarLoading;
  final LogBook? editLogBook;
  final ViewMode? viewMode;
  final String? dropdownValue;
  final String? searchType;

  @override
  void update({
    SideBarSignal? sideBarSignal,
    List<Todo>? todos,
    List<LogBook>? logBooks,
    bool? loading,
    DateTime? entryDate,
    File? selectedFile,
    String? nameSearch,
    DateTime? fromSearchDate,
    DateTime? toSearchDate,
    bool? sideBarLoading,
    LogBook? editLogBook,
    ViewMode? viewMode,
    String? dropdownValue,
    String? searchType,
    bool updateFromDateFilter: false,
    bool updateToDateFilter: false,
  }) {
    HomeViewModel(
      controller,
      viewMode: viewMode ?? this.viewMode,
      entryDate: entryDate ?? this.entryDate,
      selectedFile: selectedFile ?? this.selectedFile,
      nameSearch: nameSearch ?? this.nameSearch,
      fromSearchDate: updateFromDateFilter
          ? fromSearchDate
          : fromSearchDate ?? this.fromSearchDate,
      toSearchDate:
          updateToDateFilter ? toSearchDate : toSearchDate ?? this.toSearchDate,
      sideBarSignal: sideBarSignal ?? this.sideBarSignal,
      todos: todos ?? this.todos,
      logBooks: logBooks ?? this.logBooks,
      loading: loading ?? this.loading,
      searchType: searchType ?? this.searchType,
      dropdownValue: dropdownValue ?? this.dropdownValue,
      sideBarLoading: sideBarLoading ?? this.sideBarLoading,
      editLogBook: editLogBook ?? this.editLogBook,
    ).updateMomentum();
  }
}
