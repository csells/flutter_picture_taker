// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'is_cupertino_app.dart';

/// A progress indicator that adapts to the current platform.
///
@immutable
class AdaptiveCircularProgressIndicator extends StatelessWidget {
  /// Creates an adaptive circular progress indicator.
  ///
  /// This widget will display a [CupertinoActivityIndicator] on iOS
  /// and a [CircularProgressIndicator] on other platforms.
  ///
  /// The [key] parameter is optional and is used to control how one widget
  /// replaces another widget in the tree.
  const AdaptiveCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => isCupertinoApp(context)
      ? const CupertinoActivityIndicator()
      : const CircularProgressIndicator();
}
