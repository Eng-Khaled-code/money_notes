
import 'dart:io';

abstract class UserInter {
  Future<bool> signUpWithEmail(
      {File? profileImage,
        String? username,
        String? phoneNumber,
        String? email,
        String? password});
  Future<void> loadUserInformation(String userId);
  Future<bool> updateUserName(
      {String? userName, required String userId});
  Future<bool> updatePhoneNumber(
      {String? phoneNumber, required String userId});
  Future<bool> updatePassword(
      {String? newPassword, required String userId});
  Future<bool> updateProfilePicture(
      {File? imageFile, required String userId});


}
