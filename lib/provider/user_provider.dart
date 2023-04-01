import 'dart:async';
import 'dart:io';
import 'package:abukhaledapp/interfaces/user_interface.dart';
import 'package:abukhaledapp/models/user_model.dart';
import 'package:abukhaledapp/services/storage_services.dart';
import 'package:abukhaledapp/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../constance.dart';
class UserProvider extends UserInter with ChangeNotifier {
  FirebaseAuth? _firebaseAuth;

  UserServices _userServices=UserServices();
  bool isLoading = false;
  bool isImageLoading = false;

  String? error;

 UserModel? _userInformation;

  UserModel get userInformation => _userInformation!;


  Future<void> loadUserInformation(String userId) async {
    try {
      _userInformation = await _userServices.loadUserInformation(userId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateUserName(
      {String? userName, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _userServices.updateToFirestore(

          data: {
           user_id_f:userId,
            user_name_f:userName
          }).then((value) async {
        await loadUserInformation(userId);
      });

      isLoading = false;
      notifyListeners();
      return true;
    }on FirebaseException catch (e) {
      isLoading = false;
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePhoneNumber(
      {String? phoneNumber, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _userServices.updateToFirestore(

          data: {
            user_id_f:userId,
            user_phone: phoneNumber,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    }on FirebaseException catch (e) {
      isLoading = false;
      error=e.message;
      notifyListeners();
      return false;
    }
  }
  Future<bool> updatePassword(
      {String? newPassword, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _userServices.updateToFirestore(

          data: {
            user_id_f:userId,
            password_f:newPassword
          }).then((value) async {
        await loadUserInformation(userId);
      });

      isLoading = false;
      notifyListeners();
      return true;
    }on FirebaseException catch (e) {
      isLoading = false;
      error = e.message;
      notifyListeners();
      return false;
    }
  }
  Future<bool> signIn(
      {String? email,String? password}) async {

    try {

   return   await _userServices.signIn(email: email,password: password);


    }on FirebaseException catch (e) {
      isImageLoading = false;
      error=e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfilePicture(
      {File? imageFile, required String userId}) async {
    try {
      isImageLoading = true;
      notifyListeners();
      await StorageServices()
          .uploadingImageToStorage(
              docId: userId,
              collection:user_ref ,
              image: imageFile,
              storageDirectoryPath: "profile images",
              type: "update")
          .then((value) async {
        await loadUserInformation(userId);
      });

      isImageLoading = false;
      notifyListeners();
      return true;
    }on FirebaseException catch (e) {
      isImageLoading = false;
      error=e.message;
      notifyListeners();
      return false;
    }
  }

//completed
  Future<bool> signUpWithEmail(
      {File? profileImage,
      String? username,
      String? phoneNumber,
      String? email,
      String? password}) async {
    try {
      isLoading=true;
      notifyListeners();
_firebaseAuth=FirebaseAuth.instance;
      await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((user) async {
        Map<String, dynamic> values = {
          user_id_f: user.user!.uid,
          user_name_f:username,
          user_phone:phoneNumber,
          user_email_f:email,
          password_f:password,
          photo_url_f:""
        };

        await _userServices
            .addToFirestore(
                data: values)
            .then((value) async {
          if (profileImage != null) {
            await StorageServices()
                .uploadingImageToStorage(
                    image: profileImage,
                    docId: user.user!.uid,
                    type: "add",
                    collection: user_ref,
                    storageDirectoryPath: "profile images",
                    )
                .then((value) async {
              await loadUserInformation(user.user!.uid);
            });
          }
        });
      });

      isLoading=false;
      return true;
    }on FirebaseException catch (e) {
     isLoading=false;
     error=e.message;
      notifyListeners();
      return false;
    }
  }

}
