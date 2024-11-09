import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<html.Blob?> convertImageToBlob() async {
  // Pick an image file
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null) {
    Uint8List? imageData = result.files.first.bytes;

    if (imageData != null) {
      if (kIsWeb) {
        // For web: Create a Blob from the byte data
        final blob = html.Blob([imageData], 'image/jpeg');
        return blob;
      } else {
        // For non-web platforms, you may not need a Blob
        // and can use the byte array directly for uploading or other purposes.
        io.File file = io.File(result.files.single.path!);
        Uint8List fileData = await file.readAsBytes();
        // Perform further processing with `fileData` if necessary
        return null;
      }
    }
  }
  return null; // Return null if no file was picked
}
