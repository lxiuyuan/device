import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static int camera = 0;
  static int gallery = 1;

  static Future<File> pickImage(int source,
      {double maxWidth, double maxHeight, int imageQuality}) {
    var sources = ImageSource.camera;
    if (source == camera) {
       sources = ImageSource.camera;
    } else if (source == gallery) {
       sources = ImageSource.gallery;
    }
    return ImagePicker.pickImage(
        source: sources,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality);
  }
  static Future<File> pickVideo(int source,) {
    var sources = ImageSource.camera;
    if (source == camera) {
       sources = ImageSource.camera;
    } else if (source == gallery) {
       sources = ImageSource.gallery;
    }
    return ImagePicker.pickVideo(
        source: sources,);
  }
}
