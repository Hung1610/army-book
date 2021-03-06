import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:army_book/components/router-params/pdf-printer-view.param.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/default_styles.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:momentum/momentum.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:army_book/components/index.dart';
import 'package:army_book/constants.dart';
import 'package:army_book/services/index.dart';
import 'package:army_book/utils/index.dart';
import 'package:army_book/widgets/index.dart';

class PdfGenView extends StatefulWidget {
  @override
  _PdfGenViewState createState() => _PdfGenViewState();
}

class _PdfGenViewState extends MomentumState<PdfGenView> {
  late PdfPrinterViewController viewController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initMomentumState() {
    viewController = Momentum.controller<PdfPrinterViewController>(context);

    final param = MomentumRouter.getParam<PdfPrinterViewParam>(context);
    if (param != null) viewController.model.update(logBookId: param.logBookId);

    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    final model = viewController.model;

    var defaultTextStyle =
        DefaultTextStyle.of(context).style.copyWith(fontFamily: 'Roboto');

    final initialDocument = model.logBook != null
        ? model.logBook!.jsonContent != null
            ? fq.Document.fromJson(jsonDecode(model.logBook!.jsonContent!))
            : fq.Document()
        : fq.Document();

    QuillController _quillController = QuillController(
        document: initialDocument,
        selection: TextSelection.collapsed(offset: 0));

    return SafeArea(
      child: CustomAppBar(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text('N???i dung'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => MomentumRouter.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  tooltip: 'L??u n???i dung ra .docx',
                  icon: Icon(FontAwesomeIcons.solidFileWord),
                  onPressed: () {
                    final dialogService =
                        Momentum.service<DialogService>(context);
                    final bytes =
                        Momentum.controller<PdfPrinterViewController>(context)
                            .model
                            .logBookData;

                    if (bytes != null) {
                      Momentum.service<AppService>(context)
                          .savePdfToDisk(bytes)
                          .then((value) {
                        switch (value.action) {
                          case ResponseAction.Success:
                            dialogService.showFlashInfoDialog(
                              context,
                              value.message!,
                              'LogBook',
                            );

                            break;
                          default:
                            dialogService.showFlashInfoDialog(
                              context,
                              value.message!,
                              'LogBook',
                            );
                        }
                      });
                    }

                    // show prompt
                    else {
                      dialogService.showFlashBar(
                        context,
                        'no generated log book data found for saving',
                        'LogBook',
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  tooltip: 'L??u n???i dung',
                  // hoverColor: secondaryColor,
                  icon: Icon(CupertinoIcons.pen),
                  onPressed: () {
                    final dialogService =
                        Momentum.service<DialogService>(context);

                    var json = jsonEncode(
                        _quillController.document.toDelta().toJson());

                    var entry = model.logBook;
                    entry!.jsonContent = json;

                    viewController.updateLogBook(entry).then((value) {
                      switch (value.action) {
                        case ResponseAction.Success:
                          dialogService.showFlashBar(
                            context,
                            value.message!,
                            'LogBook',
                          );

                          break;
                        default:
                          dialogService.showFlashBar(
                            context,
                            value.message!,
                            'LogBook',
                          );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          body: RelativeBuilder(builder: (context, height, width, sy, sx) {
            return MomentumBuilder(
                controllers: [PdfPrinterViewController],
                builder: (context, snapshot) {
                  QuillEditor quillEditor = QuillEditor(
                      controller: _quillController,
                      focusNode: _focusNode,
                      scrollController: ScrollController(),
                      scrollable: true,
                      autoFocus: false,
                      readOnly: false,
                      placeholder: 'Th??m n???i dung',
                      expands: false,
                      padding: EdgeInsets.zero,
                      customStyles: DefaultStyles(
                          paragraph: DefaultTextBlockStyle(
                              defaultTextStyle.copyWith(
                                  fontSize: 16,
                                  height: 1.3,
                                  color: Colors.black),
                              const Tuple2(0, 0),
                              const Tuple2(0, 0),
                              null),
                          h1: DefaultTextBlockStyle(
                              defaultTextStyle.copyWith(
                                fontSize: 34,
                                color: Colors.black.withOpacity(0.70),
                                height: 1.15,
                                fontWeight: FontWeight.w300,
                              ),
                              const Tuple2(16, 0),
                              const Tuple2(0, 0),
                              null),
                          h2: DefaultTextBlockStyle(
                              defaultTextStyle.copyWith(
                                fontSize: 24,
                                color: Colors.black.withOpacity(0.70),
                                height: 1.15,
                                fontWeight: FontWeight.normal,
                              ),
                              const Tuple2(8, 0),
                              const Tuple2(0, 0),
                              null),
                          h3: DefaultTextBlockStyle(
                              defaultTextStyle.copyWith(
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.70),
                                height: 1.25,
                                fontWeight: FontWeight.w500,
                              ),
                              const Tuple2(8, 0),
                              const Tuple2(0, 0),
                              null),
                          color: Colors.black));

                  return model.loading!
                      ? Center(
                          child: customLoader(
                            heightFromTop: height * 0.3,
                            loaderType: 2,
                            loaderText: 'loading log book preview..',
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 15,
                                child: Container(
                                  color: Colors.white,
                                  child: quillEditor,
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: QuillToolbar.basic(
                                    controller: _quillController,
                                    showAlignmentButtons: true,
                                  ))
                            ],
                          ),
                        );
                });
          }),
        ),
      ),
    );
  }
}
