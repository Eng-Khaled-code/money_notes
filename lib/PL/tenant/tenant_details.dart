import 'dart:io';

import 'package:abukhaledapp/PL/utilities/custom_buttom.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/models/month_data_model.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:abukhaledapp/provider/month_provider.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TenantDetails extends StatefulWidget {
  final TenantModel? tenantModel;

  TenantDetails({this.tenantModel});

  @override
  _TenantDetailsState createState() => _TenantDetailsState();
}

class _TenantDetailsState extends State<TenantDetails> {

  List<int>? onlyYearsList;
  //variables

  SharedPreferences? pref;
  List? disabledList;
  //bool? monthsNull;
  int? thisYearGlobal;
  MonthDataModel? lastPaiedMonthModel;

  double? loadedFlatValue,total;
  @override
  Widget build(BuildContext context) {
    total=0;
    thisYearGlobal=DateTime.now().year;
    List<String> callList = [widget.tenantModel!.phone1!];
    if (widget.tenantModel!.phone2! != "")
    callList.add(widget.tenantModel!.phone2!);

    TenantProvider tenantsProvider=Provider.of<TenantProvider>(context);

    MonthProvider monthProvider = Provider.of<MonthProvider>(context);
    monthProvider.loadYears(tenantId:widget.tenantModel!.tenantId!);
    onlyYearsList = monthProvider.years;
    monthProvider.loadDisabledList(tenantId: widget.tenantModel!.tenantId!);
    disabledList=monthProvider.disabledYears;
    monthProvider.loadLastPaiedMonth(tenantId:widget.tenantModel!.tenantId! );
    lastPaiedMonthModel=monthProvider.lastPaiedMonth;
    List<String> settingList=[];
    if(onlyYearsList!=null)
       settingList = ["إضافة سنة قادمة","إضافة سنه سابقة"];

    tenantsProvider.loadFlatValue(tenantId: widget.tenantModel!.tenantId!);
    loadedFlatValue=tenantsProvider.flatValueLoaded;

    if( onlyYearsList!=null&&lastPaiedMonthModel!.year!=null&&onlyYearsList!.length!=0){
        monthProvider.loadTotal(tenantId:widget.tenantModel!.tenantId!,lastPaiedMonth: lastPaiedMonthModel!.monthNumber!,lastPaiedYear:lastPaiedMonthModel!.year! );
       total=monthProvider.total;
    }
    return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
    // key: _scaffoldKey,
    appBar: _appBar(settingList, callList, monthProvider,tenantsProvider)!,
    body: GestureDetector(
    onTap: () {
    ScaffoldMessenger.of(context).clearSnackBars();
    },
    child: Container(
    height: double.infinity,
    padding:
    const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 8.0),
    child: Stack(children: <Widget>[
   backgroundImage()!,
    onlyYearsList == null||disabledList==null||lastPaiedMonthModel!.monthNumber==null||tenantsProvider.teniantLoading
    ? loadingWidget()!
        : onlyYearsList!.length == 0
    ? Align(
    alignment: Alignment.topCenter,
    child: noDataCard(message: "لا توجد بيانات")!)
        :
    ListView.builder(
    itemCount: onlyYearsList!.length,
    shrinkWrap: true,
    itemBuilder: (context, position) {

    int yearNumber=onlyYearsList![position];

    return disabledList!.contains(yearNumber)?Container(height: 0):Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
        text:yearNumber.toString(),
        fontSize: 18,
        height: 2),
    thisYearGlobal! <=yearNumber? Container()  :CustomButton(text:"حذف السنة",color:primaryColor,onPress: ()async{
        MonthDataModel model=await monthProvider.loadLastMonthByYear(year: yearNumber,tenantId: widget.tenantModel!.tenantId!)!;
      print(model.status);
     if(model.status=="مدفوع"){
    disabledList!.add(yearNumber);
    if(await monthProvider.disableYear(year: yearNumber, tenantId: widget.tenantModel!.tenantId!,disabledList: disabledList))
    showSnackBar(context: context, message: "تم حذف السنة بنجاح");
    else
    showSnackBar(context: context, message: monthProvider.error);
   }
   else
   showSnackBar(context: context, message: "لا يمكنك حذف هذه السنة لانك لم تسددها كاملة");


    },width: 80,
    ) ],
    ),
    ),
    Container(
    height: 110,
    decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(8.0),
    bottomRight:
    Radius.circular(8.0))),
    child: FutureBuilder<List<Map<String,dynamic>>>(
    future: monthProvider.loadMonthsByYear(yearNumber,widget.tenantModel!.tenantId!),
    builder:(context,snapshot){
      return snapshot.hasError?Text("error"):!snapshot.hasData||snapshot.connectionState.index==2||monthProvider.addYearLoding?Center(
    child: CircularProgressIndicator(color: primaryColor)): ListView.builder(
    addAutomaticKeepAlives: true,
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: 12,
    itemBuilder: (context, index) {

    Map<String, dynamic> monthsMap =
    snapshot.data![index];


    Color cardColor,
    borderColor,
    textColor;
    IconData icon =
    monthsMap[status_f] == "مدفوع"
    ? Icons.check
        : Icons.clear;
    cardColor =
    monthsMap[status_f] == "مدفوع"
    ? primaryColor
        : Colors.white;
    borderColor =
    monthsMap[status_f] == "مدفوع"
    ? Colors.white
        : Colors.red;

    textColor =
    monthsMap[status_f] == "مدفوع"
    ? Colors.white
        : Colors.red;

    MonthDataModel _monthModel =
    MonthDataModel(
    tenantId:
    widget.tenantModel!
        .tenantId,
    status: monthsMap[status_f],
    monthName:
    monthsMap[month_name_f],
    monthNumber: monthsMap[
    month_number_f],year: monthsMap[
    year_f]);

    return GestureDetector(
    onTap: ()=>_onCardTap(
  _monthModel,monthProvider),
    child: Container(
    width: 70,
    padding:
    const EdgeInsets.all(8.0),
    margin:
    const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
    border: Border.all(
    color: borderColor),
    color: cardColor,
    borderRadius:
    BorderRadius.circular(
    5.0)),
    child: Column(
    mainAxisAlignment:MainAxisAlignment.spaceBetween,
    children: [
    CustomText(
    text: monthsMap[
    month_name_f],
    color: textColor,
    ),
    /*CustomText(
                                              text: monthsMap[month_number_f],
                                             color: textColor,
                                            ),*/
    Icon(icon,
    color: borderColor),
     CustomText(
    text:monthsMap[
    flat_value_f].toString(),
    color: textColor,
    ),
    ],
    ),
    ),
    );
    });},
    ),
    ),
    ],
    );
    },
    )
    ])),
    ), bottomNavigationBar:onlyYearsList==null||onlyYearsList!.length == 0
    ? Container(
    height: 0,
    )
        : _bottomNavigationWidget()!
    ),
    );
  }


  Widget? _bottomNavigationWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * .1,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor), color: Colors.grey[200]),
      child: CustomText(
          text: "القيمةالمطلوبة  " +

              "حتي شهر ${DateTime.now().month} " +
              "لسنة ${DateTime.now().year} هو "+total.toString()),
    );
  }

  AppBar? _appBar(List<String>? setting, List<String>? call,MonthProvider monthProvider,TenantProvider tenantsProvider) {
      return AppBar(
        title: CustomText(
          text: widget.tenantModel!.name!,
          color: Colors.white,
        ),flexibleSpace:  Container(
  decoration: BoxDecoration(
  gradient: LinearGradient(
  colors: [
  Colors.greenAccent,
  primaryColor,

  ],
  ),
  )),
        leading: _popupMenuButtonWidget(setting, Icons.more_vert,(selectedItem) async {
      try{
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  if (selectedItem == "إضافة سنة قادمة") {
  if (onlyYearsList != null) {
  int thisYear = DateTime.now().year;
  int nextYear = thisYear + 1;

  if (onlyYearsList!.length == 0) {
  await monthProvider.addNewYear(year: thisYear,tenantId: widget.tenantModel!.tenantId!,flatValue:widget.tenantModel!.flatValue!,additionValue: widget.tenantModel!.addedValue!,additionMonth:widget.tenantModel!.additionMonth!);
  showSnackBar(
  context: context,
  message: "تم إضافة السنة بنجاح " + thisYear.toString());
  } else {
  if (!onlyYearsList!.contains(thisYear)) {
  await monthProvider.addNewYear(year: thisYear,tenantId: widget.tenantModel!.tenantId!,flatValue:widget.tenantModel!.flatValue!,additionValue: widget.tenantModel!.addedValue!,additionMonth:widget.tenantModel!.additionMonth!);
  showSnackBar(
  context: context,
  message: "تم إضافة السنة بنجاح " + thisYear.toString());
  } else if (!onlyYearsList!.contains(nextYear)) {
  MonthDataModel model=await monthProvider.loadLastMonthByYear(year: nextYear-1,tenantId: widget.tenantModel!.tenantId!)!;
  await monthProvider.addNewYear(year: nextYear,tenantId: widget.tenantModel!.tenantId!,flatValue:model.flatValue!,additionValue: widget.tenantModel!.addedValue!,additionMonth:widget.tenantModel!.additionMonth!);
  showSnackBar(
  context: context,
  message: "تم إضافة السنة بنجاح " + nextYear.toString());
  } else {
  showSnackBar(
  context: context,
  message: "لا يمكنك إضافة سنه الا بعد انتهاء سنة  " +
  nextYear.toString());
  }
  }
  }
  }else if(selectedItem=="إضافة سنه سابقة"){
  if((onlyYearsList !=null&&onlyYearsList!.length !=0) ){
  if(lastPaiedMonthModel!.year==onlyYearsList!.first-1){
  double finalFlatValue=loadedFlatValue!-widget.tenantModel!.addedValue!;
  await monthProvider.addNewYear(year: onlyYearsList![0]-1,tenantId: widget.tenantModel!.tenantId!,flatValue:finalFlatValue,additionValue: widget.tenantModel!.addedValue!,additionMonth:widget.tenantModel!.additionMonth!);

  await tenantsProvider.updateFlatValue(tenantId: widget.tenantModel!.tenantId!, flatValue: finalFlatValue, additionValue: widget.tenantModel!.addedValue!,additionMonth:widget.tenantModel!.additionMonth!);
  await monthProvider.updateLastPaiedMonth(monthNumber: 12, year: onlyYearsList![0]-1, tenantId:widget.tenantModel!.tenantId!);
  showSnackBar(
  context: context,
  message: "تم إضافة السنة بنجاح " + (onlyYearsList![0]).toString());
  }}
  else{

  showSnackBar(
  context: context,
  message: "لا يمكنك إضافة " +" لانه لا لا يجب ان يكون هناك شهور مدفوعة او يجب عليكاضافةالسنة الحالية اولا");
  }
  }}
  }
  on SocketException catch (_) {
  Fluttertoast.showToast(
  msg: "تأكد من إتصالك بالإنترنت",
  toastLength: Toast.LENGTH_LONG);
  }}, monthProvider),
        actions: [
          _popupMenuButtonWidget(call, Icons.call,
              (selectedItem) async=> await launch("tel://"+selectedItem) , monthProvider)!
        ],
      );}

  PopupMenuButton? _popupMenuButtonWidget(List<String>? list, IconData? icon,
      Function(dynamic?)? onSelected, MonthProvider monthProvider) {
    return PopupMenuButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        elevation: 3.2,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return list!.map((String choice) {
            return PopupMenuItem(
              value: choice,
              child: onlyYearsList == null ||
                      choice == "إضافة سنة" && monthProvider.addYearLoding
                  ? CircularProgressIndicator(color: primaryColor,strokeWidth: 1,)
                  : Text(
                      choice,
                      style: TextStyle(fontSize: 12),
                    ),
            );
          }).toList();
        });
  }


  _onCardTap(MonthDataModel? model,MonthProvider monthProvider) async{

   int lastPaiedMonthNumber=lastPaiedMonthModel!.monthNumber!;
  int lastPaiedYear=lastPaiedMonthModel!.year!;

  bool makeUnPayed=model!.monthNumber==lastPaiedMonthNumber&&model.year==lastPaiedYear;
  bool makePaied=
      ( model.monthNumber == lastPaiedMonthNumber+1 && model.year == lastPaiedYear )
      ||
      (lastPaiedMonthNumber==12 &&  model.year == lastPaiedYear+1 && model.monthNumber == 1 )
      ||
      (lastPaiedMonthNumber==0 && model.year! == onlyYearsList![0] && model.monthNumber == 1 )
  ;


  String? message = "";
    String? actionLable = "";



  if (makeUnPayed) {
      message = "هل تريد بالفعل إلغاء دفع هذا الشهر";
      actionLable = "إلغاء دفع";
    } else if (makePaied) {
      message = "هل تريد بالفعل دفع هذا الشهر";
      actionLable = "دفع";
    } else {
      message = "لا يمكنك إجراء عمليه الا علي اخر شهر مدفوغ اوالشهر الذي يليه";
      actionLable = "إغلاق";
    }

    SnackBarAction? action = SnackBarAction(
        label: actionLable,
        onPressed: () async{
          if (actionLable == "إغلاق")
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          else {
  try{
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            if(await monthProvider.changeMonthStatus(model: model))
                showSnackBar(context: context,message:model.status=="مدفوع"?"تم الغاء الدفع بنجاح":"تم الدفع بنجاح");
            else
               showSnackBar(context: context,message:monthProvider.error);
  }}
  on SocketException catch (_) {
  Fluttertoast.showToast(
  msg: "تأكد من إتصالك بالإنترنت",
  toastLength: Toast.LENGTH_LONG);
  }
  }
        });
    SnackBar _snackbar = SnackBar(
      content: CustomText(
        text: message,
        color: Colors.white,
      ),
      duration: Duration(seconds: 20),
      action: action,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(_snackbar);

  }

  }


