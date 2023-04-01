import 'package:abukhaledapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constance.dart';

class UserServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? _preferences;

  Future<void> addToFirestore(
      {Map<String, dynamic>? data}) async {
    await _firestore.collection(user_ref).doc(data![user_id_f]).set(data);
  }

  Future<void> updateToFirestore(
      {Map<String, dynamic>? data}) async {
    await _firestore.collection(user_ref).doc(data![user_id_f]).update(data);
  }


  Future<UserModel> loadUserInformation(String userID) async {
    UserModel _user = UserModel.empty();

    DocumentSnapshot<Map<String, dynamic>>? snapshot =
    await _firestore.collection(user_ref).doc(userID).get();
    _user = UserModel.fromSnapshot(snapshot.data()!);

    _preferences=await SharedPreferences.getInstance();
    List<String> userData=[userID,snapshot.data()![user_name_f],snapshot.data()![user_email_f]
    ,snapshot.data()![photo_url_f],snapshot.data()![user_phone],snapshot.data()![password_f]];
    _preferences!.setStringList(user_ref,userData);

    return _user;
  }
  Future <bool> signIn({String? email,String? password})async{
    QuerySnapshot<Map<String ,dynamic>> x= await _firestore.collection(user_ref).where(user_email_f,isEqualTo: email).where(password_f,isEqualTo: password).get();

    if( x.size!=0){

      Map<String ,dynamic> data=x.docs.first.data();
      _preferences=await SharedPreferences.getInstance();
      List<String> userData=[data[user_id_f],data[user_name_f],data[user_email_f]
      ,data[photo_url_f],data[user_phone],data[password_f]];
      _preferences!.setStringList(user_ref,userData);
    }

    return x.size==0?false:true;
  }
}
