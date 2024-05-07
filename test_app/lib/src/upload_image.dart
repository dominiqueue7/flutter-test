import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadButton {
  final picker = ImagePicker();

  Future<void> selectAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var file = File(pickedFile.path);  // XFile to File
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, 
        file.absolute.path + "_compressed.jpg",
        quality: 88,
      );

      if (result != null) {
        var file = File(result.path);
        var snapshot = await FirebaseStorage.instance
          .ref('uploads/file-to-upload.jpg')
          .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print('Download URL: $downloadUrl');
      }
    } else {
      print('No image selected.');
    }
  }
}