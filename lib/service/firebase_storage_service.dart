import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService{
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  FirebaseStorageService._();

  static final instance = FirebaseStorageService._();

  Map<String, dynamic> defaultFailedResponse = {
    "status": false,
    "message": "",
    "data": []
  };

  Future<String?> uploadFileToServer(File file,String imageName)
  async {
    TaskSnapshot snapshot = await storageInstance
        .ref()
        .child("images/$imageName")
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    return null;
  }

}