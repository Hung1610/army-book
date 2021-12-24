import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:army_book/utils/index.dart';

class TextEntryField extends StatelessWidget {
  final String title;
  final String? initialText;
  final double fieldHeight;
  final int? maxLines;
  final Widget suffixIcon;
  final Widget? clearIcon;
  final VoidCallback? clearCallback;

  const TextEntryField({
    Key? key,
    required this.title,
    this.initialText,
    this.fieldHeight: 50,
    this.maxLines,
    this.suffixIcon: const SizedBox.shrink(),
    this.clearIcon: const SizedBox.shrink(),
    this.clearCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        const double _radius = 5.0;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                title,
                // overflow: TextOverflow.ellipsis,
                minFontSize: 15,
                maxFontSize: 35,
                style: kStyle(),
                maxLines: 1,
                softWrap: true,
                // overflowReplacement:Text('...'),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: fieldHeight,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            initialText ?? 'N/A',
                            style: kStyle(),
                            softWrap: true,
                            maxLines: maxLines,
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: initialText!.isNotEmpty
                            ? InkWell(
                                onTap: clearCallback,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.clear,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: suffixIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LogEntryField extends StatelessWidget {
  final String title;
  final String? initialText;
  final double? fieldHeight;
  final int? maxLines;

  const LogEntryField({
    Key? key,
    required this.title,
    required this.initialText,
    this.fieldHeight: 50,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        const double _radius = 5.0;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: kStyle(),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: fieldHeight,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 5,
                    right: 5,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: AutoSizeText(
                    initialText ?? 'N/A',
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 15,
                    maxFontSize: 15,
                    softWrap: true,
                    maxLines: maxLines,
                    style: kStyle(),

                    // overflowReplacement:Text('...'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
