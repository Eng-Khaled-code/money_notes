import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constance.dart';

class StorageServices {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<void> uploadingImageToStorage(
      {File? image,
      String? docId,
      String? type,
      String? collection,
      String? storageDirectoryPath,
      }) async {
    String? imgFileName = docId;

    if (type == "update") {
      await deleteImageFromStorage(
          storageDirectoryPath: storageDirectoryPath, imgFileName: docId);
    }

    Reference storageReference = await _firebaseStorage
        .ref()
        .child(storageDirectoryPath!)
        .child(imgFileName!);

    UploadTask storageUploadTask = storageReference.putFile(File(image!.path));
    await storageUploadTask.whenComplete(() {});

    await storageReference.getDownloadURL().then((profileURL) async {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(docId)
          .update({photo_url_f: profileURL});
    });
  }

  Future<void> deleteImageFromStorage(
      {String? imgFileName, String? storageDirectoryPath}) async {
    try {
      await _firebaseStorage
          .ref()
          .child(storageDirectoryPath!)
          .child(imgFileName!)
          .delete();
    } catch (ex) {}
  }
}
