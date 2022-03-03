import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firenoteapp/services/log_service.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_images";

  static Future<String?> uploadImage(File _image) async {
    String imgName = "image_" + DateTime.now().toString();
    Reference? firebaseStorageRef = _storage.child(folder).child(imgName);
    UploadTask? uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot? taskSnapshot = await uploadTask;
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      Log.i("Download url :" + downloadUrl);
      return downloadUrl;
    }
    return null;
  }
}