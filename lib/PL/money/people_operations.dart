import 'dart:io';
import 'package:abukhaledapp/PL/utilities/custom_buttom.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:abukhaledapp/PL/utilities/custom_text_form_field.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PeopleOperations extends StatefulWidget {
  final String? type,moneyType;
  String? name, phone, peopleId,adminId;

  PeopleOperations({Key, @required this.type = "",@required this.moneyType,this.adminId}) : super(key: Key);
  PeopleOperations.update(
      {Key,
      this.peopleId,
      this.name,
      this.phone,
      this.type ,
      this.moneyType,})
      : super(key: Key);

  @override
  _PeopleOperationsState createState() => _PeopleOperationsState();
}

class _PeopleOperationsState extends State<PeopleOperations> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String title = widget.type == "add" ? "إضافة شخص" : "تعديل شخص";
    double hight = MediaQuery
        .of(context)
        .size
        .height;
    double sizedBoxHight = hight * .05;

    PeopleProvider peopleProvider = Provider.of<PeopleProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar:_appBar(title),
          body: Container(
              padding: EdgeInsets.all(sizedBoxHight),
              child: peopleProvider.peopleLoading
                  ? Center(
                  child: CircularProgressIndicator(color: primaryColor))
                  : SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                        _nameWidget()!,
                    SizedBox(height: sizedBoxHight),
                    _phoneWidget()!,
                    SizedBox(height: sizedBoxHight),
                    _addOrUpdateButton(title,peopleProvider)!
                    ]),
              )),
        )));
  }

  Widget?_nameWidget() {
    return CustomTextFormField(
      initial: widget.name,
      text: "الاسم",
      icon: Icons.person,
      onSave: (value) {
        widget.name = value;
      },
      validator: (value) {
        if (value == "") return "من فضلك إدخل الاسم";
      },
    );
  }

  AppBar _appBar(String title){
    return  AppBar(flexibleSpace:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              primaryColor,

            ],
          ),
        )),
        title: CustomText(
          text: title,
          color: Colors.white,
        ));
  }
  Widget?_phoneWidget() {
    return CustomTextFormField(
      initial: widget.phone,
      text: "رقم التليفون",
      icon: Icons.call,
      onSave: (value) {
        widget.phone = value;
      },
      validator: (value) {
        bool isNumber;
        try {
          int.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }

        bool firstPart=(value!.startsWith("011") ||
            value.startsWith("012") ||
            value.startsWith("010") ||
            value.startsWith("015"));
        bool phoneValidate =firstPart &&
        isNumber &&
        value.length == 11;
        if (value == "")
        return "من فضلك إدخل الهاتف";
        else if (!phoneValidate)
          return "رقم التليفون غير صحيح";
      },

    );
  }

  Widget?_addOrUpdateButton(String title,PeopleProvider peopleProvider) {
    return CustomButton(
        width: double.infinity,
        text: title,
        onPress: () async {

          if (_formKey.currentState!.validate()) {
            _formKey.currentState
          !.save();
          try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (widget.type == "add") {
          String personId =
          DateTime.now().millisecondsSinceEpoch.toString();
          if(await peopleProvider.addPerson(data: {admin_id_f:widget.adminId,person_id_f:personId,type_f:widget.moneyType,name_f:widget.name,phone1_f:widget.phone}))
          { Fluttertoast.showToast(msg:"تمت الإضافة بنجاح");
          Navigator.pop(context);
          }else
          Fluttertoast.showToast(msg:peopleProvider.error);


          } else {

             if(await peopleProvider.updatePerson(data: {person_id_f:widget.peopleId,type_f:widget.moneyType,name_f:widget.name,phone1_f:widget.phone}))
          { Fluttertoast.showToast(msg:"تمت التعديل بنجاح");
          Navigator.pop(context);

          } else
          Fluttertoast.showToast(msg:peopleProvider.error);


          }

          }
          }
          on SocketException catch (_) {
          Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت",
          toastLength: Toast.LENGTH_LONG);
          }}});
  }
}