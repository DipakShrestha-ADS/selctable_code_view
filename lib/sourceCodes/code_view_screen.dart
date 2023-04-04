import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'languages/index.dart';

class SelectableCodeView extends StatefulWidget {
  const SelectableCodeView({
    Key? key,
    required this.code,
    required this.language,
    this.languageTheme,
    this.withZoom = true,
    this.withLinesCount = true,
    this.fontSize = 12.0,
    this.expanded = false,
  }) : super(key: key);

  /// Code text
  final String code;

  /// Syntax/Langauge (Dart, C, C++...)
  final Language language;

  /// Enable/Disable zooming controlls (default: true)
  final bool withZoom;

  /// Enable/Disable line number in left (default: true)
  final bool withLinesCount;

  /// Theme of syntax view example SyntaxTheme.dracula() (default: SyntaxTheme.dracula())
  final LanguageTheme? languageTheme;

  /// Font Size with a default value of 12.0
  final double fontSize;

  /// Expansion which allows the SyntaxView to be used inside a Column or a ListView... (default: false)
  final bool expanded;

  @override
  State<StatefulWidget> createState() => SelectableCodeViewState();
}

class SelectableCodeViewState extends State<SelectableCodeView> {
  /// For Zooming Controls
  static const double MAX_FONT_SCALE_FACTOR = 3.0;
  static const double MIN_FONT_SCALE_FACTOR = 0.5;
  double _fontScaleFactor = 1.0;
  GlobalKey numberingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Container(
          padding: widget.withLinesCount ? const EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10) : const EdgeInsets.all(10),
          color: widget.languageTheme!.backgroundColor,
          constraints: widget.expanded ? const BoxConstraints.expand() : null,
          child: RawScrollbar(
            radius: const Radius.circular(5),
            controller: verticalScrollController,
            child: SingleChildScrollView(
              controller: verticalScrollController,
              physics: const BouncingScrollPhysics(),
              child: RawScrollbar(
                radius: const Radius.circular(5),
                controller: horizontalScrollController,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: widget.withLinesCount
                      ? buildCodeWithLinesCount(
                          child: buildCode(),
                        ) // Syntax view with line number to the left
                      : buildCode(), // Syntax view
                ),
              ),
            ),
          ),
        ),
        if (widget.withZoom) codeControls(),
      ],
    );
  }

  Widget buildCodeWithLinesCount({GlobalKey? key, Widget? child}) {
    final int numLines = '\n'.allMatches(widget.code).length + 1;
    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 1; i <= numLines; i++)
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: widget.fontSize,
                    color: widget.languageTheme!.linesCountColor,
                  ),
                  text: "$i.",
                ),
                textScaleFactor: _fontScaleFactor,
              ),
          ],
        ),
        child ?? const SizedBox.shrink(),
      ],
    );
  }

  // Code text
  Widget buildCode() {
    return SelectableText.rich(
      TextSpan(
        style: TextStyle(fontFamily: 'monospace', fontSize: widget.fontSize),
        children: <TextSpan>[getSyntax(widget.language, widget.languageTheme).format(widget.code)],
      ),
      textScaleFactor: _fontScaleFactor,
      showCursor: true,
      cursorWidth: 2,
      cursorColor: widget.languageTheme?.linesCountColor,
      cursorRadius: const Radius.circular(1),
      contextMenuBuilder: _buildSelectableContextMenuBuilder,
    );
  }

  //context menu builder when text is selected
  Widget _buildSelectableContextMenuBuilder(context, EditableTextState sState) {
    final adaptiveAnchors = sState.contextMenuAnchors;

    return AdaptiveTextSelectionToolbar(
      anchors: adaptiveAnchors,
      children: [
        Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.content_copy,
                ),
                tooltip: 'Copy selected.',
                onPressed: () async {
                  //removing context menu
                  ContextMenuController.removeAny();
                  //copied to clipboard action
                  await _copyCodeToClipboard(
                    msg: 'Copied to clipboard.',
                    data: _getSelectedText(sState),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                ),
                tooltip: 'Share selected.',
                onPressed: () async {
                  ContextMenuController.removeAny();
                  // getting selected text
                  final selectedText = _getSelectedText(sState);
                  await _shareSelectedText(selectedText);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //function to get selected text
  String _getSelectedText(EditableTextState state) {
    final start = state.currentTextEditingValue.selection.start;
    final end = state.currentTextEditingValue.selection.end;
    return state.currentTextEditingValue.text.substring(start, end);
  }

  ///function to share the selected text
  Future<void> _shareSelectedText(String selectedText) async {
    //finding the render box of current context
    final box = context.findRenderObject() as RenderBox?;
    try {
      //Sharing the selected text using share_plus
      final shareResult = await Share.shareWithResult(
        selectedText,
        subject: 'Shared from Malai Sodhnus.',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      print('share result: ${shareResult.raw}');
      if (shareResult.raw.isNotEmpty) {
        _showAlertSnackbar('Shared to ${shareResult.raw}.');
      }
    } catch (e) {
      // print('error in share: $e');
    }
  }

  ///Widget inside the code blocks
  Widget codeControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            splashColor: Colors.red,
            tooltip: 'Zoom In',
            icon: Icon(
              Icons.zoom_out,
              color: widget.languageTheme!.zoomIconColor,
            ),
            onPressed: () => setState(() {
                  _fontScaleFactor = math.max(MIN_FONT_SCALE_FACTOR, _fontScaleFactor - 0.1);
                })),
        IconButton(
            tooltip: 'Zoom Out',
            icon: Icon(
              Icons.zoom_in,
              color: widget.languageTheme!.zoomIconColor,
            ),
            onPressed: () => setState(() {
                  _fontScaleFactor = math.min(MAX_FONT_SCALE_FACTOR, _fontScaleFactor + 0.1);
                })),
        IconButton(
          tooltip: 'Copy The Code',
          icon: Icon(
            Icons.copy,
            color: widget.languageTheme!.zoomIconColor,
          ),
          onPressed: () async => await _copyCodeToClipboard(data: widget.code),
        ),
      ],
    );
  }

  //Function to copy data to clipboard
  Future<void> _copyCodeToClipboard({String? msg, required String data}) async {
    try {
      ClipboardData cd = ClipboardData(
        text: data,
      );
      await Clipboard.setData(cd);
      if (mounted) {
        _showAlertSnackbar(msg ?? 'Code copied to clipboard.');
      }
    } catch (e) {
      //do nothing
    }
  }

  //Function to show alert in snackbar
  void _showAlertSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white70,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
