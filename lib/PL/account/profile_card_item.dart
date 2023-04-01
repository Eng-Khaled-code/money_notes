import 'package:abukhaledapp/PL/registration/check_password.dart';
import 'package:abukhaledapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import '../../constance.dart';

class CardItem extends StatefulWidget {
  final String title;
  final String data;
  final String userId;

  CardItem(
      {Key? key, required this.title, required this.data, required this.userId})
      : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    String controllerText=widget.data;
    final _formKey = GlobalKey<FormState>();
   return InkWell(
      onTap: ()=> onTap(user: user,controllerText: controllerText,formKey: _formKey),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 21.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(
                    widget.title == "الاسم"
                        ? Icons.person
                        : widget.title == "رقم الهاتف"
                            ? Icons.phone
                            : Icons.lock,
                    size: MediaQuery.of(context).size.width * .08,
                    color:primaryColor,
                  ),
                  SizedBox(width: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "${widget.title=="كلمة المرور"?"********":widget.data}",
                        maxLines: 1,
                        style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ]),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 30.0,
                  color:primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateToFirestore({String? text, UserProvider? user}) async {
    if (widget.title == "الاسم") {

      if (!await user!
          .updateUserName(userName:text, userId: widget.userId))
        Fluttertoast.showToast(msg: user.error!);
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    }  else if (widget.title == "رقم الهاتف") {
      if (!await user!
          .updatePhoneNumber(phoneNumber: text, userId: widget.userId))
    Fluttertoast.showToast(msg: user.error!);
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    } else if (widget.title == "كلمة المرور") {

    if (!await user!.updatePassword(newPassword: text, userId: widget.userId))
    Fluttertoast.showToast(msg: user.error!);
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);

    }
    }
  }
  onTap({UserProvider? user, GlobalKey<FormState>? formKey,String? controllerText}){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          UserProvider user1 = Provider.of<UserProvider>(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("تعديل ${widget.title}"),
              content: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: widget.title=="كلمة المرور"?"":controllerText,
                  onSaved: (value) {
                    setState(()=> controllerText = value!);
                  },
                  validator: (value) {
                    bool isNumber;
                    //checking is number or not
                    try {
                      int.parse(value!);
                      isNumber = true;
                    } catch (ex) {
                      isNumber = false;
                    }

                    if (value!.isEmpty)
                      return "لا يمكن ان يكون ${widget.title} فارغ";
                    else if ((widget.title == "رقم الهاتف" &&
                        isNumber == false) ||
                        (widget.title == "رقم الهاتف" &&
                            value.length != 11) ||
                        (widget.title == "رقم الهاتف" &&
                            !value.startsWith("01")))
                      return "رقم الهاتف غير صحيح";
                  },
                  decoration: InputDecoration(
                    labelText: "${widget.title=="كلمة المرور"?"كلمةالمرور الجديدة":widget.title}",
                  ),
                ),
              ),
              actions: <Widget>[
                user1.isLoading
                    ? Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    ))
                    : TextButton(
                    onPressed: () async {
                      formKey!.currentState!.save();
                      if (formKey.currentState!.validate ()
                      ) {
                      try {
                      final result = await InternetAddress.lookup(
                      'google.com');
                      if (result.isNotEmpty &&
                      result[0].rawAddress.isNotEmpty) {
                      if(widget.title=="كلمة المرور")
                      goTo(context:context,to:CheckPassword(type:"password",onPress:()async{await updateToFirestore(
                      user: user,
                      text:controllerText);}));
                      else
                      await updateToFirestore(
                      user: user,
                      text:controllerText);
                      }
                      } on SocketException catch (_) {
                      Fluttertoast.showToast(
                      msg: "تأكد من إتصالك بالإنترنت",
                      toastLength: Toast.LENGTH_LONG);
                      }
                      }
                    },
                    child: Text("تعديل")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("إلغاء")),
              ],
            ),
          );
        });
  }
}
