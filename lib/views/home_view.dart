import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:army_book/components/router-params/pdf-printer-view.param.dart';
import 'package:momentum/momentum.dart';
import 'package:overflow_view/overflow_view.dart';

import 'package:army_book/components/index.dart';
import 'package:army_book/constants.dart';
import 'package:army_book/services/index.dart';
import 'package:army_book/utils/index.dart';
import 'package:army_book/widgets/index.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:path/path.dart' as path;

import 'index.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends MomentumState<HomeView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late HomeViewController viewController;
  late DialogService dialogService;

  // Text Editing Controllers for edit/add
  late TextEditingController todoController;
  late TextEditingController workDone;
  late TextEditingController name;
  late TextEditingController logDate;

  // Text Editing Controllers for filtering
  late TextEditingController nameSearchController;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  @override
  void initMomentumState() {
    viewController = Momentum.controller<HomeViewController>(context);
    dialogService = Momentum.service<DialogService>(context);

    initControllers();

    viewController.listen<AppEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case ResponseEventAction.Success:
            dialogService.showFlashBar(context, event.message!, event.title!);
            clearControllers();

            // reload on success
            // TODO: use streams instead
            viewController.bootstrapAsync();
            break;

          case ResponseEventAction.DeleteTodo:
            dialogService
                .showFlashDialogConfirm(context, event.message!, event.title!)
                .then((answer) {
              if (answer!) {
                viewController.deleteTodo(event.data);
              }
            });
            clearControllers();
            break;

          case ResponseEventAction.DeleteLogEntry:
            dialogService
                .showFlashDialogConfirm(context, event.message!, event.title!)
                .then((answer) {
              if (answer!) {
                viewController.deleteLogBook(event.data);
              }
            });
            clearControllers();
            break;

          case ResponseEventAction.Error:
            dialogService.showFlashBar(context, event.message!, event.title!);
            clearControllers();
            break;

          default:
        }
      },
    );

    super.initMomentumState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      child: SafeArea(
        child: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return CustomAppBar(
              child: Scaffold(
                body: MomentumBuilder(
                  controllers: [HomeViewController],
                  builder: (context, snapshot) {
                    final model = snapshot<HomeViewModel>();

                    return SingleChildScrollView(
                      controller: ScrollController(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sy(13),
                          vertical: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: model.sideBarSignal == SideBarSignal.None
                                  ? 1
                                  : 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Kho công văn',
                                        style: kStyle(
                                          size: sy(25),
                                        ),
                                      ),
                                      Spacer(),
                                      SlideInDown(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.amber,
                                            minimumSize: Size(
                                              sy(80),
                                              sy(50),
                                            ),
                                          ),
                                          onPressed: () async {
                                            model.update(
                                                nameSearch:
                                                    nameSearchController.text);
                                            await model.controller.filterDocs();
                                          },
                                          icon: Icon(Icons.filter_alt),
                                          label: Text(
                                            'Lọc',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      // SlideInDown(
                                      //   child: ElevatedButton.icon(
                                      //     style: ElevatedButton.styleFrom(
                                      //       primary:
                                      //           model.logBooks.isEmpty
                                      //               ? Colors.grey
                                      //               : Colors.amber,
                                      //       minimumSize: Size(
                                      //         sy(80),
                                      //         sy(50),
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       if (model.logBooks.isEmpty) {
                                      //         // avoid printing
                                      //       }

                                      //       // else do it
                                      //       else {
                                      //         MomentumRouter.goto(
                                      //             context, PdfGenView);
                                      //       }
                                      //     },
                                      //     icon: Icon(Feather.printer),
                                      //     label: Text(
                                      //       'Print LogBook',
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 3,
                                  ),
                                  // SizedBox(height: sy(40)),
                                  Row(
                                    children: [
                                      Spacer(),
                                      // ZoomIn(
                                      //   child: ElevatedButton.icon(
                                      //     style: ElevatedButton.styleFrom(
                                      //       primary: Colors.amber,
                                      //       minimumSize: Size(
                                      //         sy(80),
                                      //         sy(40),
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       model.update(
                                      //           sideBarSignal:
                                      //               SideBarSignal
                                      //                   .AddTodo);
                                      //     },
                                      //     icon: Icon(AntDesign.addfile),
                                      //     label: Text(
                                      //       'New ToDo',
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                      child: Column(
                                    children: [
                                      Container(
                                        height: sy(50),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      nameSearchController,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                      Icons.search,
                                                      size: 20.0,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 5.0),
                                                    ),
                                                    hintText:
                                                        'Tìm theo tên tài liệu',
                                                  ),
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: sy(100),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 6,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextEntryField(
                                                        title:
                                                            'Tìm theo ngày tạo:',
                                                        initialText: model
                                                                    .fromSearchDate !=
                                                                null
                                                            ? DateFormat(
                                                                    'dd-MMM-yyyy')
                                                                .format(model
                                                                    .fromSearchDate!)
                                                            : '',
                                                        clearCallback: () => {
                                                          model.update(
                                                              updateFromDateFilter:
                                                                  true,
                                                              fromSearchDate:
                                                                  null)
                                                        },
                                                        suffixIcon: InkWell(
                                                          onTap: () async {
                                                            final DateTime?
                                                                selectedDate =
                                                                (await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate: DateTime
                                                                      .now()
                                                                  .subtract(
                                                                      Duration(
                                                                          days:
                                                                              365)),
                                                              lastDate: DateTime
                                                                      .now()
                                                                  .add(Duration(
                                                                      days:
                                                                          120)),
                                                            ));
                                                            model.update(
                                                                fromSearchDate:
                                                                    selectedDate);
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .calendar,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ])),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AutoSizeText(
                                                        'đến',
                                                        // overflow: TextOverflow.ellipsis,
                                                        minFontSize: 15,
                                                        maxFontSize: 35,
                                                        style: kStyle(),
                                                        maxLines: 1,
                                                        softWrap: true,
                                                        // overflowReplacement:Text('...'),
                                                      ),
                                                    ])),
                                            Expanded(
                                                flex: 6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextEntryField(
                                                      title: '',
                                                      initialText: model
                                                                  .toSearchDate !=
                                                              null
                                                          ? DateFormat(
                                                                  'dd-MMM-yyyy')
                                                              .format(model
                                                                  .toSearchDate!)
                                                          : '',
                                                      clearCallback: () => {
                                                        model.update(
                                                            updateToDateFilter:
                                                                true,
                                                            toSearchDate: null)
                                                      },
                                                      suffixIcon: InkWell(
                                                        onTap: () async {
                                                          final DateTime?
                                                              selectedDate =
                                                              (await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate: DateTime
                                                                    .now()
                                                                .subtract(
                                                                    Duration(
                                                                        days:
                                                                            365)),
                                                            lastDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 120)),
                                                          ));
                                                          model.update(
                                                              toSearchDate:
                                                                  selectedDate);
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              CupertinoIcons
                                                                  .calendar,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                  Row(
                                    children: [
                                      Text(
                                        'Tài liệu',
                                        style: kStyle(
                                          size: sy(25),
                                        ),
                                      ),
                                      Spacer(),
                                      SlideInLeft(
                                        child: CustomButton(
                                          constraints: 30,
                                          radius: 10,
                                          iconSize: 13,
                                          backgroundColor: secondaryColor,
                                          icon: CupertinoIcons.grid,
                                          tooltip:
                                              'show entries in staggered gridview mode',
                                          onPressed: () {
                                            // show staggered grid view
                                            model.update(
                                                viewMode: ViewMode.Grid);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: sy(25)),
                                      SlideInDown(
                                        child: CustomButton(
                                          constraints: 30,
                                          radius: 10,
                                          iconSize: 13,
                                          backgroundColor: secondaryColor,
                                          icon: CupertinoIcons.square_list,
                                          tooltip:
                                              'show entries in list view mode',
                                          onPressed: () {
                                            // show list view
                                            model.update(
                                                viewMode: ViewMode.List);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: sy(25)),
                                      SlideInRight(
                                        child: CustomButton(
                                          constraints: 30,
                                          radius: 10,
                                          iconSize: 13,
                                          backgroundColor: secondaryColor,
                                          icon: CupertinoIcons.plus,
                                          tooltip: 'add new entry',
                                          onPressed: () {
                                            model.update(
                                                sideBarSignal:
                                                    SideBarSignal.AddLogBook);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  ConstrainedBox(
                                    constraints: new BoxConstraints(
                                      minHeight: sy(0.0),
                                      maxHeight: sy(500.0),
                                    ),
                                    child: model.loading!
                                        ? Center(
                                            // TODO: Add shimmer loader
                                            child: customLoader(
                                              heightFromTop: sy(20),
                                              loaderType: 2,
                                              loaderText: 'loading..',
                                            ),
                                          )
                                        // TODO: Use slivers
                                        : Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: model.logBooks!.isEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: InkWell(
                                                      onTap: () {
                                                        model.update(
                                                            sideBarSignal:
                                                                SideBarSignal
                                                                    .AddLogBook);
                                                      },
                                                      child: Container(
                                                        height: sy(150),
                                                        width: sy(180),
                                                        padding: EdgeInsets.all(
                                                            defaultPadding),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: secondaryColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                height: 20),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Center(
                                                                child: Icon(
                                                                  CupertinoIcons
                                                                      .book,
                                                                  color:
                                                                      textColor,
                                                                  size: sy(40),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 30),
                                                            Center(
                                                              child: Text(
                                                                'Tạo tài liệu mới',
                                                                style: kStyle(
                                                                  size: 15,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    runSpacing: 20,
                                                    children: [
                                                        Expanded(
                                                          child: model.viewMode ==
                                                                  ViewMode.List
                                                              ? ListView
                                                                  .separated(
                                                                  controller:
                                                                      ScrollController(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final _logEntry =
                                                                        model.logBooks![
                                                                            index];

                                                                    return SlideInUp(
                                                                      child:
                                                                          ConstrainedBox(
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxHeight:
                                                                              sy(140),
                                                                          minHeight:
                                                                              sy(70),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(2),
                                                                          child:
                                                                              Material(
                                                                            elevation:
                                                                                2,
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5.0)),
                                                                            color:
                                                                                secondaryColor,
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.all(defaultPadding),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Column(
                                                                                        children: [
                                                                                          AutoSizeText(
                                                                                            _logEntry.name!,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            minFontSize: 16,
                                                                                            maxFontSize: 20,
                                                                                            style: kStyle(
                                                                                              size: 16,
                                                                                            ),
                                                                                            maxLines: 4,
                                                                                            softWrap: true,
                                                                                            // overflowReplacement:Text('...'),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              CustomButton(
                                                                                                  icon: CupertinoIcons.eye,
                                                                                                  tooltip: 'view more details',
                                                                                                  onPressed: () {
                                                                                                    model.update(
                                                                                                      sideBarSignal: SideBarSignal.ViewLogBook,
                                                                                                      editLogBook: _logEntry,
                                                                                                    );
                                                                                                  }),
                                                                                              CustomButton(
                                                                                                icon: CupertinoIcons.pencil,
                                                                                                tooltip: 'edit and update entry',
                                                                                                onPressed: () {
                                                                                                  name.text = _logEntry.name!;
                                                                                                  workDone.text = _logEntry.workdone!;

                                                                                                  model.update(
                                                                                                    sideBarSignal: SideBarSignal.EditLogBook,
                                                                                                    selectedFile: _logEntry.filePath == null ? null : File(_logEntry.filePath!),
                                                                                                    editLogBook: _logEntry,
                                                                                                  );
                                                                                                },
                                                                                              ),
                                                                                              CustomButton(
                                                                                                icon: CupertinoIcons.delete,
                                                                                                tooltip: 'delete logbook entry',
                                                                                                onPressed: () {
                                                                                                  model.controller.sendLogDeleteSignal(index);
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      CircleAvatar(
                                                                                        backgroundColor: Colors.transparent,
                                                                                        radius: sy(30),
                                                                                        child: Icon(
                                                                                          _logEntry.filePath == null || _logEntry.filePath!.isEmpty
                                                                                              ? CupertinoIcons.book_circle_fill
                                                                                              : path.extension(_logEntry.filePath!).endsWith('xlsx') || path.extension(_logEntry.filePath!).endsWith('xls')
                                                                                                  ? FontAwesomeIcons.solidFileExcel
                                                                                                  : path.extension(_logEntry.filePath!).endsWith('docx') || path.extension(_logEntry.filePath!).endsWith('doc')
                                                                                                      ? FontAwesomeIcons.solidFileWord
                                                                                                      : Icons.file_present,
                                                                                          color: textColor,
                                                                                          size: sy(30),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: sy(8)),
                                                                                      AutoSizeText(
                                                                                        _logEntry.workdone!,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        minFontSize: 14,
                                                                                        maxFontSize: 14,
                                                                                        style: kStyle(
                                                                                          size: 14,
                                                                                        ),
                                                                                        maxLines: 4,
                                                                                        softWrap: true,
                                                                                        // overflowReplacement:Text('...'),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        DateFormat('dd-MMM-yyyy').format(
                                                                                          _logEntry.date!.toDateTime(),
                                                                                        ),
                                                                                        style: kStyle(
                                                                                          size: 11,
                                                                                          color: textColor,
                                                                                          italize: true,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  separatorBuilder: (_,
                                                                          index) =>
                                                                      SizedBox(
                                                                          height:
                                                                              sy(25)),
                                                                  itemCount: model
                                                                      .logBooks!
                                                                      .length,
                                                                )
                                                              : StaggeredGridView
                                                                  .countBuilder(
                                                                  controller:
                                                                      ScrollController(),
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  crossAxisCount:
                                                                      3,
                                                                  crossAxisSpacing:
                                                                      sy(30),
                                                                  mainAxisSpacing:
                                                                      sy(40),
                                                                  itemCount: model
                                                                      .logBooks!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final _logEntry =
                                                                        model.logBooks![
                                                                            index];

                                                                    return ZoomIn(
                                                                      child:
                                                                          Material(
                                                                        elevation:
                                                                            2,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5.0)),
                                                                        color:
                                                                            secondaryColor,
                                                                        child:
                                                                            Container(
                                                                          // height: sy(120),
                                                                          // width: sy(180),
                                                                          padding:
                                                                              EdgeInsets.all(defaultPadding),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 5,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: AutoSizeText(
                                                                                        _logEntry.name!,
                                                                                        // overflow: TextOverflow.ellipsis,
                                                                                        minFontSize: 15,
                                                                                        maxFontSize: 15,
                                                                                        style: kStyle(
                                                                                          size: 15,
                                                                                        ),
                                                                                        maxLines: 8,
                                                                                        softWrap: true,
                                                                                        // overflowReplacement:Text('...'),
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Text(
                                                                                      DateFormat('dd-MMM-yyyy').format(
                                                                                        _logEntry.date!.toDateTime(),
                                                                                      ),
                                                                                      style: kStyle(
                                                                                        size: 13,
                                                                                        color: textColor,
                                                                                        italize: true,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 15),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: OverflowView(
                                                                                  direction: Axis.vertical,
                                                                                  spacing: 4,
                                                                                  children: [
                                                                                    CustomButton(
                                                                                        icon: CupertinoIcons.eye,
                                                                                        tooltip: 'view more details',
                                                                                        onPressed: () {
                                                                                          model.update(
                                                                                            sideBarSignal: SideBarSignal.ViewLogBook,
                                                                                            editLogBook: _logEntry,
                                                                                          );
                                                                                        }),
                                                                                    CustomButton(
                                                                                      icon: CupertinoIcons.pencil,
                                                                                      tooltip: 'edit and update entry',
                                                                                      onPressed: () {
                                                                                        model.update(
                                                                                          sideBarSignal: SideBarSignal.EditLogBook,
                                                                                          editLogBook: _logEntry,
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                    CustomButton(
                                                                                      icon: CupertinoIcons.delete,
                                                                                      tooltip: 'delete logbook entry',
                                                                                      onPressed: () {
                                                                                        model.controller.sendLogDeleteSignal(index);
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                  builder: (context, remaining) {
                                                                                    return CircleAvatar(
                                                                                      child: Text('+$remaining',
                                                                                          style: kStyle(
                                                                                            size: 12,
                                                                                          )),
                                                                                      backgroundColor: Colors.red,
                                                                                      maxRadius: 8,
                                                                                      minRadius: 8,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  staggeredTileBuilder:
                                                                      (index) {
                                                                    return StaggeredTile.count(
                                                                        1,
                                                                        index.isEven
                                                                            ? 0.6
                                                                            : 0.65);
                                                                  },
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                        ),
                                                        model.toSearchDate !=
                                                                    null ||
                                                                model.fromSearchDate !=
                                                                    null ||
                                                                (model.nameSearch !=
                                                                        null &&
                                                                    model
                                                                        .nameSearch!
                                                                        .isNotEmpty)
                                                            ? RawMaterialButton(
                                                                onPressed:
                                                                    () async {
                                                                  clearControllers();
                                                                  await viewController
                                                                      .bootstrapAsync();
                                                                },
                                                                elevation: 2.0,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                child: Icon(
                                                                  Icons
                                                                      .more_horiz,
                                                                  size: 20.0,
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15.0),
                                                                shape:
                                                                    CircleBorder(),
                                                              )
                                                            : SizedBox(
                                                                height: 0,
                                                              )
                                                      ])),
                                  ),
                                  SizedBox(height: sy(30)),
                                ],
                              ),
                            ),
                            model.sideBarSignal == SideBarSignal.None
                                ? SizedBox.shrink()
                                : SizedBox(width: 20),
                            model.sideBarSignal == SideBarSignal.None
                                ? SizedBox.shrink()
                                : Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        sidebarWidget(),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// determine sidebar widget to render based on signal
  Widget sidebarWidget() {
    Widget w = SizedBox.shrink();

    final model = viewController.model;

    switch (model.sideBarSignal) {
      case SideBarSignal.AddTodo:
        w = SlideInRight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'New ToDo',
                        style: kStyle(
                          size: 23,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    formEntryField(
                      title: 'Todo',
                      context: context,
                      controller: todoController,
                      maxLines: 5,
                      maxLength: 50,
                      enforceMaxLength: true,
                      validateError: 'a todo is required',
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await model.controller
                                    .addTodo(todoController.text);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: kStyle(
                                    size: 23,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              formKey.currentState?.reset();
                              clearControllers();
                              // reset sidebar
                              model.update(sideBarSignal: SideBarSignal.None);
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: kStyle(
                                    size: 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      case SideBarSignal.AddLogBook:
        w = SlideInRight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Tài liệu mới',
                        style: kStyle(
                          size: 23,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    formEntryField(
                      title: 'Tên tài liệu',
                      context: context,
                      controller: name,
                      maxLines: 1,
                      autoFocus: true,
                      validateError: 'Tài liệu cần có tên',
                    ),
                    TextEntryField(
                      title: 'Ngày tạo',
                      initialText: DateFormat('dd-MMM-yyyy')
                          .format(model.entryDate ?? DateTime.now()),
                      suffixIcon: InkWell(
                        onTap: () async {
                          final DateTime selectedDate = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 120)),
                          ))!;

                          model.update(entryDate: selectedDate);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.calendar,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    formEntryField(
                      title: 'Mô tả',
                      context: context,
                      controller: workDone,
                      maxLines: 13,
                      autoFocus: true,
                      hintText: logHintText,
                      validateError: 'Tài liệu cần có mô tả',
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: () {
                        MomentumRouter.goto(context, PdfGenView);
                      },
                      icon: Icon(CupertinoIcons.eye),
                      label: Text(
                        'Xem nội dung',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                allowedExtensions: ['xlxs', 'doc', 'docx']);

                        if (result != null) {
                          String filePath = result.files.single.path.toString();
                          File file = File(filePath);
                          model.update(selectedFile: file);
                        } else {
                          // User canceled the picker
                        }
                      },
                      icon: Icon(model.selectedFile == null ||
                              model.selectedFile!.path.isEmpty
                          ? Icons.file_upload
                          : FontAwesomeIcons.solidFileWord),
                      label: Text(
                        model.selectedFile == null ||
                                model.selectedFile!.path.isEmpty
                            ? 'Chèn file'
                            : path.basename(model.selectedFile!.path),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await model.controller
                                    .insertLogBook(workDone.text, name.text);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: kStyle(
                                    size: 23,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              formKey.currentState?.reset();
                              clearControllers();
                              // reset sidebar
                              model.update(
                                  sideBarSignal: SideBarSignal.None,
                                  entryDate: DateTime.now());
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: kStyle(
                                    size: 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      case SideBarSignal.EditLogBook:
        w = SlideInRight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Chỉnh sửa tài liệu',
                        style: kStyle(
                          size: 23,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    formEntryField(
                      title: 'Tên tài liệu',
                      context: context,
                      controller: name,
                      maxLines: 1,
                      // initialText: model.editLogBook!.name!,
                      autoFocus: true,
                      // hintText: logHintText,
                      // customOnChangeCallback: (editedEntry) {
                      //   setState(() {
                      //     name.text = editedEntry;
                      //   });
                      // }
                    ),
                    TextEntryField(
                      title: 'Ngày tạo',
                      initialText: DateFormat('dd-MMM-yyyy').format(
                          model.editLogBook != null ||
                                  model.editLogBook!.date != null
                              ? model.editLogBook!.date!.toDateTime()
                              : DateTime.now()),
                    ),
                    SizedBox(height: 30),
                    formEntryField(
                      title: 'Mô tả',
                      context: context,
                      controller: workDone,
                      maxLines: 13,
                      // initialText: model.editLogBook!.workdone!,
                      autoFocus: true,
                      hintText: logHintText,
                      // customOnChangeCallback: (editedEntry) {
                      //   setState(() {
                      //     workDone.text = editedEntry;
                      //   });
                      // }
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: () {
                        MomentumRouter.goto(context, PdfGenView,
                            params: PdfPrinterViewParam(
                                logBookId: model.editLogBook!.id));
                      },
                      icon: Icon(CupertinoIcons.eye),
                      label: Text(
                        'Xem nội dung',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                allowedExtensions: ['xlxs', 'doc', 'docx']);

                        if (result != null) {
                          String filePath = result.files.single.path.toString();
                          File file = File(filePath);
                          model.update(selectedFile: file);
                        } else {
                          // User canceled the picker
                        }
                      },
                      icon: Icon(model.selectedFile == null ||
                              model.selectedFile!.path.isEmpty
                          ? Icons.file_upload
                          : FontAwesomeIcons.solidFileWord),
                      label: Text(
                        model.selectedFile == null ||
                                model.selectedFile!.path.isEmpty
                            ? 'Chèn file'
                            : path.basename(model.selectedFile!.path),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                final _entry = model.editLogBook;
                                _entry!.workdone = workDone.text;
                                _entry.name = name.text;

                                await model.controller.updateLogBook(_entry);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: kStyle(
                                    size: 23,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              formKey.currentState?.reset();
                              clearControllers();
                              // reset sidebar
                              model.update(
                                sideBarSignal: SideBarSignal.None,
                                entryDate: DateTime.now(),
                                editLogBook: null,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: kStyle(
                                    size: 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      case SideBarSignal.ViewLogBook:
        w = SlideInRight(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Tài liệu',
                        style: kStyle(
                          size: 23,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    LogEntryField(
                      title: 'Tên tài liệu',
                      initialText: model.editLogBook!.name!,
                      fieldHeight: null,
                      maxLines: 1,
                    ),
                    TextEntryField(
                      title: 'Ngày tạo',
                      initialText: DateFormat('dd-MMM-yyyy').format(
                        model.editLogBook != null ||
                                model.editLogBook!.date != null
                            ? model.editLogBook!.date!.toDateTime()
                            : DateTime.now(),
                      ),
                    ),
                    SizedBox(height: 30),
                    LogEntryField(
                      title: 'Mô tả',
                      initialText: model.editLogBook!.workdone!,
                      fieldHeight: null,
                      maxLines: 13,
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        formKey.currentState?.reset();
                        clearControllers();
                        // reset sidebar
                        model.update(
                          sideBarSignal: SideBarSignal.None,
                          entryDate: DateTime.now(),
                          editLogBook: null,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: kStyle(
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      default:
        w = SlideInLeft(child: SizedBox.shrink());
    }

    return w;
  }

  void initControllers() {
    todoController = TextEditingController();
    workDone = TextEditingController();
    name = TextEditingController();
    logDate = TextEditingController();

    nameSearchController = TextEditingController();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
  }

  void disposeControllers() {
    todoController.dispose();
    workDone.dispose();
    name.dispose();
    logDate.dispose();

    nameSearchController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
  }

  void clearControllers() {
    todoController.clear();
    workDone.clear();
    name.clear();
    logDate.clear();

    nameSearchController.clear();
    fromDateController.clear();
    toDateController.clear();
  }
}
