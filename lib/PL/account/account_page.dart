import 'package:abukhaledapp/PL/account/profile_card_item.dart';
import 'package:abukhaledapp/PL/account/top_container.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
   SharedPreferences? prefs;

  String? photoUrl,userName,loadedPassword,loadedEmail,userId,loadedPhone;

  List<String>? data;

  initialize()async{
    prefs=await SharedPreferences.getInstance();
    setState(() {
      data  =prefs!.getStringList(user_ref)!;
      if(data!.length!=0){
      loadedEmail=data![2];
      loadedPassword=data![5];
      photoUrl=data![3];
      userName=data![1];
      userId=data![0];
      loadedPhone=data![4];
      }
      });
    }


  @override
  Widget build(BuildContext context) {

    initialize();
//print(data);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
             backgroundImage()!,data==null?loadingWidget()!:   SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TopContainer(image_url: photoUrl,name: userName,email: loadedEmail,userId: userId),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CardItem(title:"الاسم", data:userName!,userId:userId!),
                        CardItem(title:"رقم الهاتف", data:loadedPhone!,userId:userId!),
                        CardItem(title:"كلمة المرور", data:loadedPassword!,userId: userId!),

                      ],
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            ]),
      );

  }
}
