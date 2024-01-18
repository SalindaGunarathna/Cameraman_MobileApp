
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
 final FirebaseFirestore firestore = FirebaseFirestore.instance;



class StoreData{

  Future<String> uploadImageToStorange(String ChildName, Uint8List file)async{


    
    Reference ref = _storage.ref().child((ChildName));

    

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

 
}



