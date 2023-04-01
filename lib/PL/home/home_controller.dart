import 'package:abukhaledapp/PL/account/account_page.dart';
import 'package:abukhaledapp/PL/day_operations/day_operations.dart';
import 'package:abukhaledapp/PL/money/people_operations.dart';
import 'package:abukhaledapp/PL/money/people_page.dart';
import 'package:abukhaledapp/PL/tenant/tenant_page.dart';
import 'package:abukhaledapp/PL/utilities/custom_alert_dialog.dart';
import 'package:abukhaledapp/PL/utilities/show_dialog.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tenant/tenant_operations.dart';
import 'package:flutter/material.dart';

class HomeController extends StatefulWidget {


  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int currentIndex = 0;
  String? adminId;

  initialize()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(()=> adminId = prefs.getStringList(user_ref)!.first);
  }
  List<String> choices = ["الكل", "إختر تاريخ"];

  String selectedItem = "الكل";

  @override
  Widget build(BuildContext context) {
    initialize();
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
              title: "تنبيه",
              onPress: () async {
                SystemNavigator.pop();
              },
              text: "هل تريد الخروج من التطبيق بالفعل",
            ));
        return Future.delayed(Duration(seconds: 0));
      },
      child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _appBar(),
        body: Stack(alignment: Alignment.center,children: <Widget>[
         backgroundImage()!,
          adminId !=null? loadingBody()!:Container()

    ]),
        bottomNavigationBar: bottomNavigationBar(),
        floatingActionButton: (currentIndex == 0||currentIndex == 1||currentIndex==2||currentIndex==3||currentIndex == 4)
            ?floatingActionButton(index:currentIndex )
            : null,
      )),
    );
  }

  Widget? loadingBody() {
    switch (currentIndex) {
     // case 0:
       // return HomePage();
      case 0:
        return DayOperations(type:"out",adminId: adminId,selectedItem: selectedItem,);
      case 1:
        return DayOperations(type:"in",adminId: adminId,selectedItem: selectedItem,);
      case 2:
        return TenantPage();
      case 3:
        return PeoplePage(moneyType:i_pay_to_him);
      case 4:
        return PeoplePage(moneyType: he_pay_to_me);
      case 5:
        return AccountPage();
    }
  }

  AppBar? _appBar() {
    switch (currentIndex) {
      //case 0:
        //return CustomAppBar(title: "الرئيسية");
      case 0:
        return _dayAppbar("المصاريف اليومية");
      case 1:
        return _dayAppbar("الدخل اليومي");
      case 2:
        return CustomAppBar(title: "السكان");
      case 3:
        return CustomAppBar(title: "المديونيات");
      case 4:
        return CustomAppBar(title: "المستحقات");
      case 5:
        return CustomAppBar(title: "الحساب");
    }
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
       /* BottomNavigationBarItem(
            label: 'الرئيسية',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(Icons.home),
            )),
*/        BottomNavigationBarItem(
            label: 'مصاريف',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.arrow_downward))),
        BottomNavigationBarItem(
            label:"الدخل",
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.arrow_upward))),
        BottomNavigationBarItem(
            label: 'السكان',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.people))),

        BottomNavigationBarItem(
            label: 'مديونيات',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.money_off))),
        BottomNavigationBarItem(
            label: 'مستحقات',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.money))),
        BottomNavigationBarItem(
            label: 'الحساب',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.account_circle,))),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      elevation: 20,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black45,
unselectedLabelStyle: TextStyle(color: Colors.black45,fontSize: 9),
      showUnselectedLabels: true,
    );
  }

  Widget? floatingActionButton({int? index}){
    String lable=index==2?"إضافة ساكن":index==3||index==4?"إضافة شخص":index==1?"إضافة دخل":index==0?"إضافةمصروف":"";
    String moneyType=index==3?i_pay_to_him:index==4?he_pay_to_me:"";
    Widget to=index==2?TenantOperations(type: "add",admin_id: adminId,):index==3||index==4?PeopleOperations(type: "add",moneyType: moneyType,adminId:adminId):Container();
    return adminId==null?loadingWidget()!: FloatingActionButton.extended(
      splashColor: Colors.greenAccent,
      onPressed: (){
        if(index==0||index==1)
    {
      String date=DateTime.now().millisecondsSinceEpoch.toString();
    showDialog1(context: context,addOrUpdate: "add",personId: adminId,date: date,type:index==0? "out":"in");

    }
    else
      goTo(context: context, to: to);

    }      ,label: CustomText(
        text: lable,
        color: Colors.white,
      ),
      icon: Icon(currentIndex == 0||currentIndex == 1?Icons.money_rounded:Icons.person_outline),
    );
  }

  AppBar _dayAppbar(String title){
   return  AppBar(
     automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              primaryColor,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize:18),
      ), actions: [
      Center(
          child: Text("${selectedItem}",
              style: TextStyle(color: Colors.white, fontSize: 12))),
      PopupMenuButton(
          icon: Icon(Icons.arrow_drop_down),
          elevation: 3.2,
          tooltip: 'فرز بواسطة',
          onSelected: (String choice) {
            if(choice=="الكل")
              setState(()=>
              selectedItem = choice);
            else
            _showDatePacker();

          },
          itemBuilder: (BuildContext context) {
            return choices.map((String choice) {
              return PopupMenuItem(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(fontSize: 12),
                ),
              );
            }).toList();
          }),
    ],
    );
  }

   _showDatePacker() async{
     DateTime initialDate = DateTime.now();

     final DateTime? picked = await showDatePicker(
     context: context,
     initialDate: initialDate,
     firstDate: DateTime(2021,8,1),
     lastDate: DateTime.now());

     if (picked != null) {
       setState(()=>
     selectedItem = picked.day.toString() + "-" +
     picked.month.toString()+"-"+ picked.year.toString()
    );
   }
}
}
