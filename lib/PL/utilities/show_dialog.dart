import 'dart:io';
import 'package:abukhaledapp/provider/day_ope_provider.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../constance.dart';
showDialog1({BuildContext? context, String? addOrUpdate,String? reason1,double? value1,String? date,String? personId,String? type}){

  final _formKey=GlobalKey<FormState>();

  String? title =addOrUpdate=="add"?"إضافة":"تعديل",reason;
  double? value;

  showDialog(
  barrierDismissible: false,

      context: context!,
      builder: (context) {
    PeopleProvider peopleProvider= Provider.of<PeopleProvider>(context);
        DayProvider dayProvider = Provider.of<DayProvider>(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: Text(title),
            content: Container(
  height:type=="values"|| type=="values2"?100:175,

  child: Form(
                key: _formKey,
                child:  Column(
                  children: [
                    TextFormField(
  initialValue: value1 ==null?"":value1.toString(),
                      onSaved: (value2){
                value=value2!=""? double.parse(value2!):0;
                      },
                      validator: (value2) {
                        bool isNumber;
                        //checking is number or not
                        try {
                          double.parse(value2!);
                          isNumber = true;
                        } catch (ex) {
                          isNumber = false;
                        }

                        if (value2!.isEmpty||value==0)
                          return "يجب ان تدخل قيمة";
                        else if(isNumber==false)
                          return "يجب ان تدخل رقم";
                      },
                      decoration: InputDecoration(
                        labelText: "القيمة",
                      ),
                    ),
  type=="values"||type=="values2"?Container(): TextFormField(
  initialValue: reason1,
                      onSaved: (value){
                        reason=value!;
                      },
                      validator: (value) {
                        //checking is number or not
                        if (value!.isEmpty&&type=="data")
                          return "يجب ان تدخل السبب";

                      },
                      decoration: InputDecoration(
                        labelText: "السبب",
                      ),
                    ),
                  ],
                ),
              ),
            ) ,actions: <Widget>[
            peopleProvider.peopleLoading||dayProvider.dayLoading
                ? Container(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 0.7,
                ))
                : TextButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                  try {
                  final result = await InternetAddress.lookup(
                  'google.com');
                  if (result.isNotEmpty &&
                  result[0].rawAddress.isNotEmpty) {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();

  if(addOrUpdate=="add")
  {
    if(type=="in"||type=="out"){

      String date1=date!;
  DateTime dateTime=DateTime.fromMillisecondsSinceEpoch(int.parse(date1));
  int day=dateTime.day;
  int year=dateTime.year;
  int month=dateTime.month;

  String date2=day.toString()+"-"+month.toString()+"-"+year.toString();
      if(await dayProvider.addOperation(data: {"ope_id":date,admin_id_f:personId,type_f:type,"date":date2,"value":value,"reason":reason}))
  {
  Fluttertoast.showToast(msg: "تمت الإضافة بنجاح");
  Navigator.pop(context);
  }
  else
  Fluttertoast.showToast(msg:peopleProvider.error);



  }else{
  //add operations
  if(await peopleProvider.addOperation(data:{"value":value,person_id_f:personId,"reason":reason,type_f:type,"date":date}))
  {
  Fluttertoast.showToast(msg: "تمت الإضافة بنجاح");
  Navigator.pop(context);
  }
  else
  Fluttertoast.showToast(msg:peopleProvider.error);

  }
  }else{

  //update operations
  if(type=="in"||type=="out"){

  if(await dayProvider.updateOperation(data: {"ope_id":personId,type_f:type,"date":date,"value":value,"reason":reason}))
  {

  Fluttertoast.showToast(msg: "تمت التعديل بنجاح");
  Navigator.pop(context);
  }
  else
  Fluttertoast.showToast(msg:peopleProvider.error);


  }else{

  if(await peopleProvider.updateOperation(data:{"value":value,person_id_f:personId,"reason":reason,"date":date}))
  {
  Fluttertoast.showToast(msg: "تمت التعديل بنجاح");
  Navigator.pop(context);
  }
  else
  Fluttertoast.showToast(msg:peopleProvider.error);

  }
  }
  }
                  }
                  } on SocketException catch (_) {
                  Fluttertoast.showToast(
                  msg: "تأكد من إتصالك بالإنترنت",
                  toastLength: Toast.LENGTH_LONG);
                  }
                  }
                },
                child: Text(title)),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("إلغاء")),
          ],
          ),
        );

      });}