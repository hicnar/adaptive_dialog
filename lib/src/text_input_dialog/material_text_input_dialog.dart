import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MaterialTextInputDialog extends StatefulWidget {
  const MaterialTextInputDialog({
    Key? key,
    required this.textFields,
    this.title,
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.isDestructiveAction = false,
    this.style = AdaptiveStyle.adaptive,
    this.actionsOverflowDirection = VerticalDirection.up,
    this.useRootNavigator = true,
    this.fullyCapitalized = true,
    this.onWillPop,
    this.autoSubmit = false,
    this.dialogBackgroundColor
  }) : super(key: key);
  @override
  _MaterialTextInputDialogState createState() =>
      _MaterialTextInputDialogState();

  final List<DialogTextField> textFields;
  final String? title;
  final String? message;
  final String? okLabel;
  final String? cancelLabel;
  final bool isDestructiveAction;
  final AdaptiveStyle style;
  final VerticalDirection actionsOverflowDirection;
  final bool useRootNavigator;
  final bool fullyCapitalized;
  final WillPopCallback? onWillPop;
  final bool autoSubmit;
  final Color? dialogBackgroundColor;
}

class _MaterialTextInputDialogState extends State<MaterialTextInputDialog> {
  late final List<TextEditingController> _textControllers = widget.textFields
      .map((tf) => TextEditingController(text: tf.initialText))
      .toList();
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    for (final c in _textControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = widget.title;
    final message = widget.message;
    final navigator = Navigator.of(
      context,
      rootNavigator: widget.useRootNavigator,
    );
    void submit() => navigator.pop(
          _textControllers.map((c) => c.text).toList(),
        );
    void submitIfValid() {
      if (_formKey.currentState!.validate()) {
        submit();
      } else if (_autoValidateMode == AutovalidateMode.disabled) {
        setState(() {
          _autoValidateMode = AutovalidateMode.always;
        });
      }
    }

    void cancel() => navigator.pop();
    final titleText = title == null ? null : Text(title);
    final cancelLabel = widget.cancelLabel;
    final okLabel = widget.okLabel;
    final okText = Text(
      (widget.fullyCapitalized ? okLabel?.toUpperCase() : okLabel) ??
          MaterialLocalizations.of(context).okButtonLabel,
      style: TextStyle(
        color: widget.isDestructiveAction ?
          colorScheme.error : theme.iconTheme.color ?? theme.primaryColor
      ),
    );
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: Form(
        key: _formKey,
        child: AlertDialog(
          backgroundColor: theme.cardColor,
          title: titleText,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(message),
                      ),
                    ),
                  ),
                ),
              ..._textControllers.mapIndexed((i, c) {
                final isLast = widget.textFields.length == i + 1;
                final textField = widget.textFields[i];
                return TextFormField(
                  controller: c,
                  autofocus: i == 0,
                  obscureText: textField.obscureText,
                  keyboardType: textField.keyboardType,
                  cursorColor: theme.iconTheme.color ?? theme.primaryColor,
                  minLines: textField.minLines,
                  maxLines: textField.maxLines,
                  decoration: InputDecoration(
                    hintText: textField.hintText,
                    prefixText: textField.prefixText,
                    suffixText: textField.suffixText,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.iconTheme.color ?? theme.primaryColor
                        )
                    )
                  ),
                  validator: textField.validator,
                  autovalidateMode: _autoValidateMode,
                  textInputAction: isLast ? null : TextInputAction.next,
                  onFieldSubmitted: isLast && widget.autoSubmit
                      ? (_) => submitIfValid()
                      : null,
                );
              })
            ],
          ),
          actions: [
            TextButton(
              onPressed: cancel,
              child: Text(
                (widget.fullyCapitalized
                        ? cancelLabel?.toUpperCase()
                        : cancelLabel) ??
                    MaterialLocalizations.of(context).cancelButtonLabel,
                style: TextStyle(
                    color: theme.iconTheme.color ?? theme.primaryColor
                )
              ),
            ),
            TextButton(
              onPressed: submitIfValid,
              child: okText,
            )
          ],
          actionsOverflowDirection: widget.actionsOverflowDirection,
        ),
      ),
    );
  }
}
