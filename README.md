# Flutter Picture Taker

A Flutter package for capturing still pictures using the camera plugin targeting iOS, Android, and the web. This package provides a simple camera interface for taking pictures, making it easy to integrate camera functionality into your Flutter applications.

## Features

- Capture still pictures using the device camera.
- Supports iOS, Android, and web platforms, the same platforms supported by [the camera plugin](https://pub.dev/packages/camera) on which this package is based.
- Easy integration with existing Flutter applications.

## Usage

Add the `flutter_picture_taker` dependency to your `pubspec.yaml` file and add the corresponding import statement. Now you can call the `showStillCameraDialog` function to take a picture:

```dart
Future<void> _takePicture() async {
  final image = await showStillCameraDialog(context);
  if (image != null) setState(() => _image = image);
}
```

The [sample app](https://github.com/csells/flutter_picture_taker/blob/main/example/lib/main.dart) provides a simple way to take a picture and see the resulting image:

TODO:screenshot1

The dialog chooses the first camera reported available by the system and lets the user press the button to take a picture or click anywhere else (or press the Esc key on systems that have one) to dismiss the dialog without taking a picture. The picture is available as an `XFile` from [the cross_file package](https://pub.dev/packages/cross_file) and can be shown like so:

```dart
  kIsWeb ? Image.network(_image!.path) : Image.file(File(_image!.path))
```
