import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:momentum/momentum.dart';
import 'package:overflow_view/overflow_view.dart';

import 'package:log_book/components/index.dart';
import 'package:log_book/constants.dart';
import 'package:log_book/services/index.dart';
import 'package:log_book/utils/index.dart';
import 'package:log_book/widgets/index.dart';
import 'package:relative_scale/relative_scale.dart';

import 'index.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends MomentumState<HomeView> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late HomeViewController viewController;
  late DialogService dialogService;

  late TextEditingController todoController;
  late TextEditingController workDone;
  late TextEditingController logDate;

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

                    return model.loading!
                        ? Center(
                            // TODO: Add shimmer loader
                            child: customLoader(
                              heightFromTop: height * 0.3,
                              loaderType: 1,
                              loaderText: 'loading..',
                            ),
                          )
                        // TODO: Use slivers
                        : SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sy(13),
                                vertical: 5,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: model.sideBarSignal ==
                                            SideBarSignal.None
                                        ? 1
                                        : 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  await model.controller
                                                      .loadAll();
                                                },
                                                icon: Icon(
                                                    CupertinoIcons.refresh),
                                                label: Text(
                                                  'Refresh',
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
                                          thickness: 2,
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
                                            height: sy(200),
                                            child: Column(
                                              children: [
                                                TextField(
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
                                                TextEntryField(
                                                  title: 'Tìm từ ngày',
                                                  suffixIcon: InkWell(
                                                    onTap: () async {
                                                      final DateTime
                                                          selectedDate =
                                                          (await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime
                                                                .now()
                                                            .subtract(Duration(
                                                                days: 365)),
                                                        lastDate: DateTime.now()
                                                            .add(Duration(
                                                                days: 120)),
                                                      ))!;

                                                      model.update(
                                                          entryDate:
                                                              selectedDate);
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
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
                                                TextEntryField(
                                                  title: 'Đến ngày',
                                                  suffixIcon: InkWell(
                                                    onTap: () async {
                                                      final DateTime
                                                          selectedDate =
                                                          (await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime
                                                                .now()
                                                            .subtract(Duration(
                                                                days: 365)),
                                                        lastDate: DateTime.now()
                                                            .add(Duration(
                                                                days: 120)),
                                                      ))!;

                                                      model.update(
                                                          entryDate:
                                                              selectedDate);
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
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
                                              ],
                                            )),
                                        Row(children: []),
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
                                                icon:
                                                    CupertinoIcons.square_list,
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
                                                          SideBarSignal
                                                              .AddLogBook);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        model.logBooks!.isEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
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
                                                    decoration: BoxDecoration(
                                                      color: secondaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 20),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Center(
                                                            child: Icon(
                                                              CupertinoIcons
                                                                  .book,
                                                              color: textColor,
                                                              size: sy(40),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 30),
                                                        Center(
                                                          child: Text(
                                                            'Tạo tài liệu mới',
                                                            style: kStyle(
                                                              size: 15,
                                                              color: textColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : model.viewMode == ViewMode.List
                                                ? ListView.separated(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final _logEntry = model
                                                          .logBooks![index];

                                                      return SlideInUp(
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxHeight: sy(120),
                                                            minHeight: sy(80),
                                                          ),
                                                          child: Container(
                                                            padding: EdgeInsets.all(
                                                                defaultPadding),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  secondaryColor,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 2,
                                                                  offset: Offset(
                                                                      1,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    CustomButton(
                                                                        icon: CupertinoIcons
                                                                            .eye,
                                                                        tooltip:
                                                                            'view more details',
                                                                        onPressed:
                                                                            () {
                                                                          model
                                                                              .update(
                                                                            sideBarSignal:
                                                                                SideBarSignal.ViewLogBook,
                                                                            editLogBook:
                                                                                _logEntry,
                                                                          );
                                                                        }),
                                                                    SizedBox(
                                                                        width:
                                                                            15),
                                                                    CustomButton(
                                                                      icon: CupertinoIcons
                                                                          .pencil,
                                                                      tooltip:
                                                                          'edit and update entry',
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .update(
                                                                          sideBarSignal:
                                                                              SideBarSignal.EditLogBook,
                                                                          editLogBook:
                                                                              _logEntry,
                                                                        );
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            15),
                                                                    CustomButton(
                                                                      icon: CupertinoIcons
                                                                          .delete,
                                                                      tooltip:
                                                                          'delete logbook entry',
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .controller
                                                                            .sendLogDeleteSignal(index);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      radius:
                                                                          sy(30),
                                                                      child:
                                                                          Icon(
                                                                        CupertinoIcons
                                                                            .book_circle_fill,
                                                                        color:
                                                                            textColor,
                                                                        size: sy(
                                                                            30),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: sy(
                                                                            8)),
                                                                    AutoSizeText(
                                                                      _logEntry
                                                                          .workdone!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          15,
                                                                      maxFontSize:
                                                                          15,
                                                                      style:
                                                                          kStyle(
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      maxLines:
                                                                          4,
                                                                      softWrap:
                                                                          true,
                                                                      // overflowReplacement:Text('...'),
                                                                    ),
                                                                    Spacer(),
                                                                    Text(
                                                                      DateFormat(
                                                                              'dd-MMM-yyyy')
                                                                          .format(
                                                                        _logEntry
                                                                            .date!
                                                                            .toDateTime(),
                                                                      ),
                                                                      style:
                                                                          kStyle(
                                                                        size:
                                                                            13,
                                                                        color:
                                                                            textColor,
                                                                        italize:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (_, index) => SizedBox(
                                                            height: sy(25)),
                                                    itemCount:
                                                        model.logBooks!.length,
                                                  )
                                                : StaggeredGridView
                                                    .countBuilder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: sy(30),
                                                    mainAxisSpacing: sy(40),
                                                    itemCount:
                                                        model.logBooks!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final _logEntry = model
                                                          .logBooks![index];

                                                      return ZoomIn(
                                                        child: Container(
                                                          // height: sy(120),
                                                          // width: sy(180),
                                                          padding: EdgeInsets.all(
                                                              defaultPadding),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                secondaryColor,
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                    1,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                flex: 5,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          AutoSizeText(
                                                                        _logEntry
                                                                            .workdone!,
                                                                        // overflow: TextOverflow.ellipsis,
                                                                        minFontSize:
                                                                            15,
                                                                        maxFontSize:
                                                                            15,
                                                                        style:
                                                                            kStyle(
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        maxLines:
                                                                            8,
                                                                        softWrap:
                                                                            true,
                                                                        // overflowReplacement:Text('...'),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    Text(
                                                                      DateFormat(
                                                                              'dd-MMM-yyyy')
                                                                          .format(
                                                                        _logEntry
                                                                            .date!
                                                                            .toDateTime(),
                                                                      ),
                                                                      style:
                                                                          kStyle(
                                                                        size:
                                                                            13,
                                                                        color:
                                                                            textColor,
                                                                        italize:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 15),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    OverflowView(
                                                                  direction: Axis
                                                                      .vertical,
                                                                  spacing: 4,
                                                                  children: [
                                                                    CustomButton(
                                                                        icon: CupertinoIcons
                                                                            .eye,
                                                                        tooltip:
                                                                            'view more details',
                                                                        onPressed:
                                                                            () {
                                                                          model
                                                                              .update(
                                                                            sideBarSignal:
                                                                                SideBarSignal.ViewLogBook,
                                                                            editLogBook:
                                                                                _logEntry,
                                                                          );
                                                                        }),
                                                                    CustomButton(
                                                                      icon: CupertinoIcons
                                                                          .pencil,
                                                                      tooltip:
                                                                          'edit and update entry',
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .update(
                                                                          sideBarSignal:
                                                                              SideBarSignal.EditLogBook,
                                                                          editLogBook:
                                                                              _logEntry,
                                                                        );
                                                                      },
                                                                    ),
                                                                    CustomButton(
                                                                      icon: CupertinoIcons
                                                                          .delete,
                                                                      tooltip:
                                                                          'delete logbook entry',
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .controller
                                                                            .sendLogDeleteSignal(index);
                                                                      },
                                                                    ),
                                                                  ],
                                                                  builder: (context,
                                                                      remaining) {
                                                                    return CircleAvatar(
                                                                      child: Text(
                                                                          '+$remaining',
                                                                          style:
                                                                              kStyle(
                                                                            size:
                                                                                12,
                                                                          )),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      maxRadius:
                                                                          8,
                                                                      minRadius:
                                                                          8,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    staggeredTileBuilder:
                                                        (index) {
                                                      return StaggeredTile
                                                          .count(
                                                              1,
                                                              index.isEven
                                                                  ? 0.6
                                                                  : 0.65);
                                                    },
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
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          String filePath = result.files.single.path.toString();
                          File file = File(filePath);
                        } else {
                          // User canceled the picker
                        }
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text(
                        'Chèn file',
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
                                    .insertLogBook(workDone.text);
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
                        // controller: workDone,
                        maxLines: 13,
                        initialText: model.editLogBook!.workdone!,
                        autoFocus: true,
                        hintText: logHintText,
                        customOnChangeCallback: (editedEntry) {
                          setState(() {
                            workDone.text = editedEntry;
                          });
                        }),
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
                      onPressed: () {
                        MomentumRouter.goto(context, PdfGenView);
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text(
                        'Chèn file',
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
    logDate = TextEditingController();
  }

  void disposeControllers() {
    todoController.dispose();
    workDone.dispose();
    logDate.dispose();
  }

  void clearControllers() {
    todoController.clear();
    workDone.clear();
    logDate.clear();
  }
}
