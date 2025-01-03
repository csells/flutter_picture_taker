// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter/material.dart' as mat;
import 'package:flutter/widgets.dart';

import 'is_cupertino_app.dart';

/// A utility class for showing adaptive dialogs that match the current platform
/// style.
@immutable
class AdaptiveDialog {
  /// Shows an adaptive dialog with the given [content] widget as content.
  ///
  /// This method automatically chooses between a Cupertino-style dialog for iOS
  /// and a Material-style dialog for other platforms.
  ///
  /// Parameters:
  ///   * [context]: The build context in which to show the dialog.
  ///   * [child]: The widget to display as the dialog's content.
  ///
  /// Returns a [Future] that completes with the result value when the dialog is
  /// dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool barrierDismissible = false,
  }) =>
      isCupertinoApp(context)
          ? cup.showCupertinoDialog<T>(
              context: context,
              barrierDismissible: barrierDismissible,
              builder: (context) => content,
            )
          : mat.showDialog<T>(
              context: context,
              barrierDismissible: barrierDismissible,
              builder: (context) => content,
            );
}
