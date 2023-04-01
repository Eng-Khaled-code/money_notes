import 'package:abukhaledapp/PL/utilities/custom_clipper.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:abukhaledapp/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constance.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? adminId;

  initialize()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? d=await prefs.getStringList(user_ref);

    setState(()=> adminId =d!.first );
  }
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider=Provider.of<HomeProvider>(context);

    return Container(
        child: Column(children: <Widget>[
        Stack(
          children: [ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
      Colors.greenAccent,

    primaryColor,
    ],
    ),
    ))),_topWidget()!]
        ),
            ]));
  }
  Widget?  _topWidget() {

    return Container(
      height: 240,
      child: Center(child: Column(
        children: [
          SizedBox(height: 40),

          ClipRRect(borderRadius: BorderRadius.circular(100.0)
              ,child: Container(width: 150,height: 150,child: Image.asset("assets/images/app_icon.jpg",))),
          SizedBox(height: 20),
          CustomText(text:"حساباتي",fontSize: 20,color: Colors.white,),
        ],
      ),),
    );
  }
  /* String? adminId;

  initialize()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? d=await prefs.getStringList(user_ref);

    setState(()=> adminId =d!.first );
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    HomeProvider homeProvider=Provider.of<HomeProvider>(context);
    if( adminId != null)
       homeProvider.loadPeopleList(adminId: adminId!);

    return Container(
      child:homeProvider.peopleList == null|| adminId == null?Center(child: CircularProgressIndicator(color: primaryColor,),):
      FutureBuilder<List<Map<String,dynamic>>>(future: homeProvider.loadData(homeProvider.peopleList!),builder: (context,snapshot){
        return !snapshot.hasData?Center(child: CircularProgressIndicator(color: primaryColor,),) :ListView.builder(itemBuilder: (context,position)
        {
          return Text("${snapshot.data![position]["value"]}");
        });

      },)
      );
  }


*/
}