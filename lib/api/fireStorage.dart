import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://my-firebase-app-c159a.appspot.com/');
  final String path;
  StorageReference ref;

  FireStorage(this.path) {
    ref = _storage.ref().child(path);
  }

  StorageUploadTask putFile(File file) {
    return ref.putFile(file);
  }
}
