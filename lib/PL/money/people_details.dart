
import 'package:abukhaledapp/PL/utilities/show_dialog.dart';
import 'package:abukhaledapp/PL/utilities/stream_builder.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleDetails extends StatefulWidget {
  final String? moneyType;
  final String? name;
  final String? phone;
  final String? personId;


  PeopleDetails({Key? key,this.moneyType, this.name, this.phone,this.personId}): super(key: key);

  @override
  _PeopleDetailsState createState() => _PeopleDetailsState();
}

class _PeopleDetailsState extends State<PeopleDetails>with SingleTickerProviderStateMixin {
  int selectedPage=0;

   TabController? _tabController;

   double total=0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }  @override
  Widget build(BuildContext context) {
    PeopleProvider peopleProvider= Provider.of<PeopleProvider>(context);
    String type=
    selectedPage==0&&widget.moneyType==i_pay_to_him
        ?
    "data"
        :
    selectedPage==0&&widget.moneyType==he_pay_to_me
        ?
    "data2"
        :
    selectedPage==1&&widget.moneyType==i_pay_to_him?
    "values":
    "values2";
    peopleProvider.loadTotal(type: type,personId: widget.personId);

    total=peopleProvider.total;

    return Directionality(
    textDirection: TextDirection.rtl,
        child:DefaultTabController(

          length: 2,
          initialIndex: 0,
          child: Scaffold(
    // key: _scaffoldKey,
    appBar: _appBar()!,
    body: _body(type: type,peopleProvider: peopleProvider)
            ,
            floatingActionButton:_floutingActionButton(type)! ,bottomNavigationBar: _bottomNavigationWidget(),
    ),
        ),
    );
  }

  Widget? _floutingActionButton(String type){
    return FloatingActionButton.extended(
      onPressed: (){
        String date=DateTime.now().millisecondsSinceEpoch.toString();
        showDialog1(context: context,addOrUpdate: "add",personId: widget.personId,date: date,type: type);
      },
      label: CustomText(
        text: selectedPage==0?"إضافة":"دفع",
        color: Colors.white,
      ),
      icon: Icon(Icons.money),
    );
  }

  Widget? _bottomNavigationWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor), color: Colors.grey[200]),
      child: CustomText(
          text: "الاجمالي : "+total.toString()),
    );
  }

  AppBar? _appBar() {
    Color activeColor = Colors.white;
    Color notActiveColor = Colors.black;

    String lable1=widget.moneyType==i_pay_to_him?"المديونيات":"المستحقات";

    return AppBar(

        title: CustomText(
          text: widget.name!,
          color: Colors.white,
        ),
        actions: [
         IconButton(icon: Icon(Icons.call,color:Colors.white),onPressed: ()async=> await launch("tel://"+widget.phone!),)
        ],
      bottom:TabBar(indicatorColor: activeColor,unselectedLabelColor:notActiveColor ,onTap: (int index){
        setState(()=>selectedPage=index);
      },tabs: [Tab(child: Text(lable1,
         ),),Tab(child: Text("المدفوع",
         ),)],) ,flexibleSpace:  Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Colors.greenAccent,
    primaryColor,

    ],
    ),
    )));}

  Widget? _body({PeopleProvider? peopleProvider,String? type}){

    return Container(
        height: double.infinity,
        padding:
        const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 8.0),
        child: TabBarView(controller:_tabController ,
          children: [
            CustomStreamBuilder(
              stream:type=="data"
                  ?
              peopleProvider!.personDataStreem(personId: widget.personId)
                  :
              type=="data2"
                  ?
              peopleProvider!.personData2Streem(personId:widget.personId)
                  :
              type=="values"
                  ?
              peopleProvider!.personValuesStreem(personId: widget.personId)
                  :
              peopleProvider!.personValues2Streem(personId: widget.personId)  ,
              cardType: "dataCard",
              noItemsMessage: "لا توجد بيانات",
            ),
            Container()
          ],));
  }
}

