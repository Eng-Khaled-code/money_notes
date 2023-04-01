
import 'package:abukhaledapp/PL/home/home_controller.dart';
import 'package:abukhaledapp/PL/utilities/custom_buttom.dart';
import 'package:abukhaledapp/PL/utilities/custom_text_form_field.dart';
import 'package:abukhaledapp/PL/utilities/profile_image.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';



class RigisterPage extends StatefulWidget {
  @override
  _RigisterPageState createState() => _RigisterPageState();
}

class _RigisterPageState extends State<RigisterPage> {
  final _formKey = GlobalKey<FormState>();
String? name,email,password,phone;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ProfileImageState.imageFile = null;

  }

  @override
  Widget build(BuildContext context) {

    UserProvider userProvider=Provider.of<UserProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: _appBar()!,
            body: Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  backgroundImage()!,

              userProvider.isLoading?loadingWidget()!: Form(
                    key: _formKey,
                    child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle.light,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Container(
                          height: double.infinity,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileImage(),
                                SizedBox(height: 20.0),
                                _nameWidget()!,
                                SizedBox(height: 20.0),
                                _phone1Widget()!,
                                SizedBox(height: 20.0),
                            _emailWidget()!,
                            SizedBox(height: 20.0),
                            _passwordWidget()!,
                            SizedBox(height: 20.0),


                            _buildingNextWidget(userProvider),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  addUser(UserProvider userProvider) async{
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {

      if(await userProvider.signUpWithEmail(username: name,email: email,password:password,phoneNumber: phone,profileImage:ProfileImageState.imageFile )){
        Fluttertoast.showToast(msg: "تم إضافة المستخدم بالفعل");
        goTo(context:context,to:HomeController());
    }
    else
    Fluttertoast.showToast(msg:userProvider.error!);

    }
  }

  Widget _buildingNextWidget(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomButton(
          text: "تسجيل",
          onPress: () => addUser(userProvider),
          ),
    );
  }

  Widget? _nameWidget() {
    return CustomTextFormField(
      initial:name ,
      text: "الاسم",
      icon: Icons.person,
      onSave: (value) {
        name = value;
      },
      validator: (value) {
        if (value == "") return "من فضلك إدخل الاسم";
      },
    );
  }

  Widget? _emailWidget() {
    return CustomTextFormField(
      initial: email,
      text: "الايميل",
      icon: Icons.email,
      onSave: (value) {
        email = value;
      },
      validator: (value) {
        if (value == "") return "من فضلك إدخل الايميل";
      },
    );
  }

  Widget? _passwordWidget() {
    return CustomTextFormField(
      initial:password ,
      text: "كلمة المرور",
      icon: Icons.lock,
      onSave: (value) {
        password = value;
      },
      validator: (value) {
        if (value == "") return "من فضلك إدخل كلمة المرور";
      },
    );
  }

  Widget? _phone1Widget() {
    return CustomTextFormField(
      initial: phone,
      text:"رقم التليفون",
      icon: Icons.call,
      onSave: (value) {
        phone = value;
      },
      validator: (value) {
        bool isNumber;
        try {
          int.parse(value!);
          isNumber = true;
        } catch (e) {
          isNumber = false;
        }

        bool phoneValidate = (value!.startsWith("011") ||
            value.startsWith("012") ||
            value.startsWith("010") ||
            value.startsWith("015")) &&
        isNumber &&
        value.length == 11;
        if (value == "")
        return "من فضلك إدخل الهاتف";
        else if (!phoneValidate) return "رقم التليفون غير صحيح";
      },
    );
  }

 AppBar? _appBar() {
    return AppBar(
      flexibleSpace:  Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent,
                primaryColor,

              ],
            ),
          )),
      title: Text(
        "تسجيل مستخدم جديد",
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );

  }
}
