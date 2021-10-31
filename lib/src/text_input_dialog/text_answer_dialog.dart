import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showTextAnswerDialog({
  required BuildContext context,
  required String keyword,
  String? title,
  String? message,
  String? okLabel,
  String? cancelLabel,
  bool isDestructiveAction = false,
  bool barrierDismissible = true,
  String? hintText,
  String? retryTitle,
  String? retryMessage,
  String? retryOkLabel,
  String? retryCancelLabel,
  AdaptiveStyle style = AdaptiveStyle.adaptive,
  bool useRootNavigator = true,
  VerticalDirection actionsOverflowDirection = VerticalDirection.up,
  bool fullyCapitalizedForMaterial = true,
  WillPopCallback? onWillPop,
  bool isCaseSensitive = true,
  FormFieldValidator<String>? validator,
}) async => showTextCallbackDialog(
    context: context,
    asyncCallback: (value) async => isCaseSensitive ?
        value == keyword : value.toLowerCase() == keyword.toLowerCase(),
    title: title,
    message: message,
    okLabel: okLabel,
    cancelLabel: cancelLabel,
    isDestructiveAction: isDestructiveAction,
    barrierDismissible: barrierDismissible,
    hintText: hintText,
    retryTitle: retryTitle,
    retryMessage: retryMessage,
    retryOkLabel: retryOkLabel,
    retryCancelLabel: retryCancelLabel,
    style: style,
    useRootNavigator: useRootNavigator,
    actionsOverflowDirection: actionsOverflowDirection,
    fullyCapitalizedForMaterial: fullyCapitalizedForMaterial,
    onWillPop: onWillPop,
    validator: validator
);

