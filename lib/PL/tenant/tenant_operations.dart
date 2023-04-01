import 'dart:io';

import 'package:abukhaledapp/PL/utilities/custom_buttom.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:abukhaledapp/PL/utilities/custom_text_form_field.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantOperations extends StatefulWidget {
  final String? type;
  String? name, phone1, phone2, tenantId,admin_id;

  int? flatNumber, additionMonth;

  double? flatValue, addedValue;

  TenantOperations({Key, @required this.type = "",this.admin_id}) : super(key: Key);
  TenantOperations.update(
      {Key,
      this.tenantId,
      this.name,
      this.phone1,
      this.phone2,
      this.type = "",
      this.flatNumber = 0,
      this.flatValue = 0,
      this.addedValue = 0,
      this.additionMonth})
      : super(key: Key);

  @override
  _TenantOperationsState createState() => _TenantOperationsState();
}

class _TenantOperationsState extends State<TenantOperations> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? selectedItem;

  int? monthNumber;

  @override
  Widget build(BuildContext context) {
    String title = widget.type == "add" ? "إضافة ساكن" : "تعديل الساكن";
    selectedItem = widget.additionMonth;
    double hight = MediaQuery.of(context).size.height;
    double sizedBoxHight = hight * .05;

    TenantProvider tenantProvider = Provider.of<TenantProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: _appBar(title),
            body: Container(
              padding: EdgeInsets.all(sizedBoxHight),
              child: tenantProvider.teniantLoading
                  ? Center(
                      child: CircularProgressIndicator(color: primaryColor))
                  : SingleChildScrollView(
                      child: Form(
                      key: _formKey,
                      child: Column(children: [
                        _nameWidget()!,
                        SizedBox(height: sizedBoxHight),
                        _phone1Widget()!,
                        SizedBox(height: sizedBoxHight),
                        _phone2Widget()!,
                        SizedBox(height: sizedBoxHight),
                        _flatNumberWidget()!,
                        SizedBox(height: sizedBoxHight),
                        _flatValueWidget()!,
                        SizedBox(height: sizedBoxHight),
                        _addedValueWidget()!,
                        SizedBox(height: sizedBoxHight),
                        _additionMonthWidget()!,
                        SizedBox(height: sizedBoxHight),
                        _addOrUpdateButton()!
                      ]),
                    )),
            )));
  }

  AppBar _appBar(String title){
    return AppBar(
        title: CustomText(
          text: title,
          color: Colors.white,
        ),flexibleSpace:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              primaryColor,

            ],
          ),
        )));
  }
  Widget? _nameWidget() {
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

  Widget? _phone1Widget() {
    return CustomTextFormField(
      initial: widget.phone1,
      text: "رقم التليفون 1",
      icon: Icons.call,
      onSave: (value) {
        widget.phone1 = value;
      },
      validator: (value) {
        bool isNumber;
        try {
          int.parse(value!);
          isNumber = true;
        } catch (e) {
          print("99");
          isNumber = false;
        }

        bool phoneValidate = (value!.startsWith("011") ||
                value.startsWith("012") ||
                value.startsWith("010") ||
                value.startsWith("015")) &&
           isNumber &&
            value.length == 11;
        print(value.length.toString());
        print(phoneValidate);
        print(isNumber);

        if (value == "")
          return "من فضلك إدخل الهاتف";
        else if (!phoneValidate) return "رقم التليفون غير صحيح";
      },
    );
  }

  Widget? _phone2Widget() {
    return CustomTextFormField(
      initial: widget.phone2,
      text: "رقم التليفون 2",
      icon: Icons.call,
      onSave: (value) {
        widget.phone2 = value;
      },
      validator: (value) {
       bool isNumber;
        try {
          int.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }

        bool phoneValidate1 = (value!.startsWith("011") ||
                value.startsWith("012") ||
                value.startsWith("010") ||
                value.startsWith("015")) &&
            isNumber &&
            value.length == 11;

        if (value == null || value == "");
        else if (!phoneValidate1) return "رقم التليفون غير صحيح";
      },
    );
  }

  Widget? _flatNumberWidget() {
    return CustomTextFormField(
      initial: widget.flatNumber==null?"0":widget.flatNumber.toString(),
      text: "رقم الشقة",
      icon: Icons.home,
      onSave: (value) {
        widget.flatNumber = int.parse(value!);
      },
      validator: (value) {
        bool isNumber;
        try {
          int.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }
        if (value == ""||value=="0")
          return "من فضلك إدخل رقم الشقة";
        else if (!isNumber) return "يجب ان تكون الارقام بالغة الإنجليزية";
      },
    );
  }

  Widget? _flatValueWidget() {
    return CustomTextFormField(
      initial: widget.flatValue==null?"0":widget.flatValue.toString(),
      text: "قيمةالإيجار",
      icon: Icons.monetization_on_sharp,
      onSave: (value) {
        widget.flatValue = double.parse(value!);
      },
      validator: (value) {
        bool isNumber;
        try {
          double.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }
        if (value == ""||value=="0")
          return "من فضلك إدخل قيمة الإيجار";
        else if (!isNumber) return "يجب ان تكون الارقام بالغة الإنجليزية";
      },
    );
  }

  Widget? _addedValueWidget() {
    return CustomTextFormField(
      initial: widget.addedValue==null?"0":widget.addedValue.toString(),
      text: "قيمةالزيادةالسنوية",
      icon: Icons.monetization_on_sharp,
      onSave: (value) {
        widget.addedValue = double.parse(value!);
      },
      validator: (value) {
        bool isNumber;
        try {
          double.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }
        if (value == "")
          return "من فضلك إدخل قيمة الزيادة السنوية";
        else if (!isNumber) return "يجب ان تكون الارقام بالغة الإنجليزية";
      },
    );
  }

  Widget? _additionMonthWidget() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0)),
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null) return "من فضلك إختر شهر الزيادة السنوية";
        },
        decoration: InputDecoration.collapsed(hintText: ""),
        items: monthsNumbers
            .map((month) => DropdownMenuItem(
                  child: Text(month.toString()),
                  value: month,
                ))
            .toList(),
        onChanged: (int? value) {
          setState(() {
            monthNumber = value;
          });
          print(monthNumber);
        },
        value: selectedItem,
        hint: CustomText(text: "شهر الزيادة السنوية", color: Colors.grey),
      ),
    );
  }

  Widget? _addOrUpdateButton() {
    String buttonText = widget.type == "add" ? "إضافة ساكن" : "تعديل الساكن";

    return CustomButton(
        width: double.infinity,
        text: buttonText,
        onPress: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

          try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            if (widget.type == "add") {

          SharedPreferences prefs=await SharedPreferences.getInstance();
          String adminId=await prefs.getStringList(user_ref)!.first;
              String tenantId =
                  DateTime.now().millisecondsSinceEpoch.toString();
              print(selectedItem);
              TenantModel tenantModel = TenantModel(
          adminId: adminId,
                  tenantId: tenantId,
                  name: widget.name,
                  phone1: widget.phone1,
                  phone2: widget.phone2,
                  flatNumber: widget.flatNumber,
                  flatValue: widget.flatValue,
                  addedValue: widget.addedValue,
                  additionMonth: monthNumber, disabledList: [0],lastPaiedMonth: {month_number_f:12,year_f:DateTime.now().year-1,tenant_id_f:tenantId,status_f:"مدفوع"});
              await tenantOpe(model: tenantModel, type: "add");
            } else {
              TenantModel tenantModel = TenantModel(
                  tenantId: widget.tenantId,
                  name: widget.name,
                  phone1: widget.phone1,
                  phone2: widget.phone2,
                  flatNumber: widget.flatNumber,
                  addedValue: widget.addedValue,
                  flatValue:widget.flatValue ,
                  additionMonth:
                      monthNumber!=null? monthNumber : selectedItem,
          );
              await tenantOpe(model: tenantModel, type: "update");
            }
          }
        }
         on SocketException catch (_) {
    Fluttertoast.showToast(
    msg: "تأكد من إتصالك بالإنترنت",
    toastLength: Toast.LENGTH_LONG);
    }}});
  }

  Future<void> tenantOpe({TenantModel? model, String? type}) async {
    TenantProvider tenantProvider =
        Provider.of<TenantProvider>(context, listen: false);
    if (type == "add") {
      if (!await tenantProvider.addTenant(data: {
        admin_id_f:widget.admin_id,
        tenant_id_f: model!.tenantId,
        name_f: model.name,
        phone1_f: model.phone1,
        phone2_f: model.phone2,
        flat_number_f: model.flatNumber,
        added_value_f:model.addedValue,
        flat_value_f: model.flatValue,
        addition_month: model.additionMonth, disibled_list_f: model.disabledList,last_paied_month_f: model.lastPaiedMonth
      }))
        showSnackBar(context: context, message: tenantProvider.error);
      else {
        Fluttertoast.showToast(msg: "تم إضافة الساكن بنجاح");
        Navigator.pop(context);
      }
    } else {
      if (!await tenantProvider.updateTenant(data: {
    tenant_id_f: model!.tenantId,
    name_f: model.name,
    phone1_f: model.phone1,
    phone2_f: model.phone2,
    flat_number_f: model.flatNumber,
        added_value_f:model.addedValue,
        addition_month: model.additionMonth,
    })) {

        showSnackBar(context: context, message: tenantProvider.error);

      }else {
        await tenantProvider.updateFlatValue(tenantId: model.tenantId!, flatValue: model.flatValue!, additionValue: model.addedValue!, additionMonth: model.additionMonth!);
      Fluttertoast.showToast(msg: "تم تعديل بيانات الساكن بنجاح");
        Navigator.pop(context);
      }
    }
  }
}
