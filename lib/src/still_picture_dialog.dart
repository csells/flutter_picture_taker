import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import 'adaptive_dialog.dart';
import 'adaptive_progress_indicator.dart';
import 'camera_button.dart';

/// Displays a dialog for capturing still pictures using the camera.
///
/// This function shows a dialog that contains a custom camera interface
/// for taking pictures. It returns an [XFile] containing the captured
/// image, or `null` if no image was captured.
///
/// The [context] parameter is used to look up the [Navigator] for the dialog.
Future<XFile?> showStillCameraDialog(BuildContext context) async =>
    AdaptiveDialog.show<XFile>(
      context: context,
      content: const StillCameraDialog(),
    );

/// A dialog widget for capturing still pictures using the camera.
///
/// This widget provides a custom camera interface for taking pictures.
/// It is used in conjunction with the [showStillCameraDialog] function to
/// display the dialog.
///
/// The [StillCameraDialog] is a [StatefulWidget] that manages the camera
/// controller and handles the camera initialization and disposal.
class StillCameraDialog extends StatefulWidget {
  /// Creates a [StillCameraDialog].
  ///
  /// The [key] parameter is optional and is used to control how one widget
  /// replaces another widget in the tree.
  const StillCameraDialog({super.key});

  @override
  _StillCameraDialogState createState() => _StillCameraDialogState();
}

class _StillCameraDialogState extends State<StillCameraDialog> {
  late CameraController _controller;
  late final Future<void> _cameraFuture = _initCamera();

  Future<void> _initCamera() async {
    // pick the first camera
    final cameras = await availableCameras();
    final camera = cameras.first;

    // to display the camera output, create and initialize a controller
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    return _controller.initialize();
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _cameraFuture,
        builder: (context, snapshot) => Center(
          child: switch (snapshot.connectionState) {
            ConnectionState.done => snapshot.hasError
                ? Text('Error: ${snapshot.error}')
                : Stack(
                    children: [
                      CameraPreview(_controller),
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(child: CameraButton(onPressed: _click)),
                      ),
                    ],
                  ),
            _ => const AdaptiveCircularProgressIndicator(),
          },
        ),
      );

  Future<void> _click() async {
    try {
      final image = await _controller.takePicture();

      // I checked it... what more can I do??
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context, image);
    } on Exception catch (e) {
      debugPrint(e.toString());

      // I checked it... what more can I do??
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context, null);
    }
  }
}
