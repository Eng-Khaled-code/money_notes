import 'package:abukhaledapp/constance.dart';

class UserModel {
  String? userId, username, photoUrl,phone,email,password;


  UserModel({this.userId,this.username,this.photoUrl,this.password,this.phone,this.email});

  UserModel.empty();

  UserModel.fromSnapshot(Map<String, dynamic> snapshot) {
    userId = snapshot[user_id_f]??"";
    username = snapshot[user_name_f]??"";
    photoUrl = snapshot[photo_url_f]??"";
    phone = snapshot[user_phone]??"";
    email = snapshot[user_email_f]??"";
    password = snapshot[password_f]??"";

  }
}
