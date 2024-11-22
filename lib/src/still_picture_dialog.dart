import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';

import 'adaptive_dialog.dart';
import 'adaptive_progress_indicator.dart';
import 'camera_button.dart';

/// Displays a dialog for capturing a still picture using the camera.
///
/// This function shows an [AdaptiveDialog] containing a [StillCameraDialog]
/// widget, allowing the user to take a picture. The dialog can be dismissed
/// by clicking outside of it or pressing the Esc key on systems that have one.
///
/// The function returns an [XFile] containing the captured image, or `null`
/// if the dialog was dismissed without taking a picture.
///
/// The mime type of the captured image is determined by reading the first
/// few bytes of the file and using the [lookupMimeType] function.
///
/// Example usage:
/// ```dart
/// Future<void> _takePicture() async {
///   final image = await showStillCameraDialog(context);
///   if (image != null) setState(() => _image = image);
/// }
/// ```
///
/// [context] - The build context to use for displaying the dialog.
Future<XFile?> showStillCameraDialog(BuildContext context) async {
  final image = await AdaptiveDialog.show<XFile>(
    context: context,
    barrierDismissible: true,
    content: const Padding(
      padding: EdgeInsets.all(16),
      child: StillCameraDialog(),
    ),
  );

  // if mime type is available from the XFile, return it immediately
  if (image == null || image.mimeType != null) return image;

  // look up the mime type
  final bytes = await image.readAsBytes();
  final mime = lookupMimeType(image.path, headerBytes: bytes.take(8).toList());
  return XFile.fromData(
    bytes,
    mimeType: mime,
    name: image.name,
    path: image.path,
  );
}

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
  CameraController? _controller;
  late final Future<void> _cameraFuture = _initCamera();

  Future<void> _initCamera() async {
    // pick the first camera
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw Exception('No cameras found');

    // to display the camera output, create and initialize a controller
    final camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    return _controller!.initialize();
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _cameraFuture,
        builder: (context, snapshot) => Center(
          child: switch (snapshot.connectionState) {
            ConnectionState.done => snapshot.hasError
                ? _ErrorView(snapshot.error!)
                : _CameraView(controller: _controller!, onPressed: _click),
            _ => const AdaptiveCircularProgressIndicator(),
          },
        ),
      );

  Future<void> _click() async {
    try {
      final image = await _controller!.takePicture();

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

class _CameraView extends StatelessWidget {
  const _CameraView({required this.controller, required this.onPressed});
  final CameraController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          CameraPreview(controller),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: CameraButton(onPressed: onPressed),
          ),
        ],
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.error);
  final Object error;

  static const _white = Color(0xffffffff);
  static const _black = Color(0xff000000);

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: _white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            error.toString(),
            style: const TextStyle(
              color: _black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
}
