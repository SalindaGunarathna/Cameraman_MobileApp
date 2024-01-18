import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethodes {
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      {required String path,
      required bool isPost,
      required Uint8List file}) async {
    String res = "An error occured";

    try {
      Reference ref = _storage.ref().child(path).child(_auth.currentUser!.uid);

      if (isPost) {
        String postId = const Uuid().v4();
        ref = ref.child(postId);
      }

      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      res = e.toString();
      // ignore: avoid_print
      print(res);
    }
    return res;
  }
}
