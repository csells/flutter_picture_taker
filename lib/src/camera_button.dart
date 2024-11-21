import 'package:flutter/widgets.dart';

/// A [CameraButton] widget that represents a circular button used to trigger
/// camera actions. It is a stateless widget that uses a [GestureDetector]
/// to handle tap events.
///
/// The button consists of two concentric circles: an outer transparent circle
/// and an inner white circle.
///
/// The [onPressed] callback is triggered when the button is tapped.
class CameraButton extends StatelessWidget {
  /// Creates a [CameraButton].
  ///
  /// The [onPressed] parameter is a callback that is called when the button
  /// is tapped. It can be null, in which case the button will be disabled.
  const CameraButton({
    super.key,
    this.onPressed,
  });

  static const _transparent = Color(0x00000000);
  static const _white = Color(0xFFFFFFFF);
  static const _black = Color(0xFF000000);

  /// The callback that is called when the button is tapped.
  ///
  /// If this is null, the button will be disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _black,
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _transparent,
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _white,
                ),
              ),
            ),
          ),
        ),
      );
}
