import 'dart:io';
import 'package:abukhaledapp/PL/home/home_controller.dart';
import 'package:abukhaledapp/PL/registration/register.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:abukhaledapp/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CheckPassword extends StatefulWidget {
 final Function()? onPress;
 final String? type;
  CheckPassword({Key? key,this.onPress,this.type}):super(key: key);
  @override
  _CheckPasswordState createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  bool isLoadingIn=false;

  String? password,email,photoUrl,userName,loadedPassword,loadedEmail;
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  SharedPreferences? prefs;
  List<String>? data;
  initialize()async{
    prefs=await SharedPreferences.getInstance();

    if(prefs!.getStringList(user_ref)  !=null){

  setState((){data  = prefs!.getStringList(user_ref)!;
    if(data!.length!=0){
    loadedEmail=data![2];
    loadedPassword=data![5];
    photoUrl=data![3];
    userName=data![1];}});
  }else{
      data=[];
    }

  }

  @override
  Widget build(BuildContext context) {
    initialize();
    bool splachRule=(data==null&&widget.type=="log_in");
    TenantProvider tenantProvider=Provider.of<TenantProvider>(context);
    bool loadingRule=(data==null&&widget.type != "log_in")|| tenantProvider.teniantLoading||isLoadingIn;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

    body: Container(
    child: Stack(
      alignment: Alignment.center,
    children: <Widget>[
    backgroundImage()!,
    splachRule?_splachScreen()!: loadingRule?loadingWidget()!:   SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.all(20),
    child:Column(
                children: [

              _profileImageWidget()!,userName==null?Container(): SizedBox(
                    height: 15,
                  ),
                  userName==null?Container():
                  Text(
                    userName!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  userName==null?Container(): SizedBox(
                    height: 24,
                  ),
                  userName==null?Container():Text(
                    'التحقق من الهوية',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  userName==null?Container():  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userName==null?"تسجيل الدخول": "من فضلك إدخل كلمة المرور",
                    style: TextStyle(
                      fontSize:userName==null? 18:14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),SizedBox(height: 15,),
      Container(
      padding: EdgeInsets.all(20),

      decoration: BoxDecoration
        (

        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey)
      ),
      child: Form(
        key:_formKey,
        child:Column(
        children: [
          loadedEmail !=null ? Container():_emailWidget()!,
          SizedBox(
            height: 30,
          ),
_passwordWidget()!
      ,
          SizedBox(
            height: 30,
          ),
          _checkWidget()!,

                 userName!=null?Container(): SizedBox(height: 40),
                  userName!=null?Container(): _buildSignUpButtonWidget()
                ],
              ),
            ),
            )]))]))));
  }

  Widget _buildSignUpButtonWidget() {
    return GestureDetector(
      onTap: () {
        goTo(context: context,to: RigisterPage());
      },
      child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "ليس لديك حساب؟",
                style: TextStyle(
                  fontFamily: "main_font",
                  color: Colors.black,
                  fontSize: 18,
                )),
            TextSpan(
                text: " تسجيل",
                style: TextStyle(
                  fontFamily: "main_font",
                  color: Colors.pink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ))
          ])),
    );
  }

 Widget?  _splachScreen() {

    return Container(
      height: 300,
      child: Center(child: Column(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(100.0)
            ,child:
            Container(width: 150,height: 150,child: Image.asset("assets/images/app_icon.jpg",))),
          SizedBox(height: 30),
          Text("حساباتي",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 20),

          CircularProgressIndicator(color: primaryColor,),
        ],
      ),),
    );
  }


  Widget? _passwordWidget(){

    return TextFormField(
      onSaved: (String? value){
    password=value;
    },
      validator: (String? value){
    if(value=="")
    return "من فضلك قم بإدخال كلمة المرور";
    },
      initialValue: password??"",
      obscureText: true,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(hintText: "كلمة المرور",
          border:OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10)),
          prefix: Icon(Icons.lock,color: primaryColor,),
          hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
      ),
    );
  }

  Widget? _checkWidget() {

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {


          _formKey.currentState!.save();
          if(_formKey.currentState!.validate()){

            if(loadedEmail==null){
            setState(()=>  isLoadingIn=true);
          if(await Provider.of<UserProvider>(context,listen: false).signIn(email: email,password: password))
              goTo(context:context,to:HomeController());
          else
          Fluttertoast.showToast(
          msg:"اسم المستخدم او كلمة المرور غير صحيحة");

          setState(()=>  isLoadingIn=false);

          }else{

          if(password==loadedPassword){
          if(widget.type=="log_in")
          goTo(context:context,to:HomeController());
          else{
          try{ final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          widget.onPress!();
          Navigator.pop(context);

          }}
          on SocketException catch (_) {
          Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت",
          toastLength: Toast.LENGTH_LONG);
          }
          }
          }
            }


          }

        },
        style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
          MaterialStateProperty.all<Color>(primaryColor),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            userName!=null? 'تحقق':'تسجيل دخول',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    )
    ;
  }

 Widget? _emailWidget() {

    return TextFormField(
      onSaved: (String? value){
    email=value;
    },
      validator: (String? value){
    if(value=="")
    return "من فضلك قم بإدخال الايميل";
    },
      initialValue: email??"",
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "الإيميل",
        hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
        border:OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10)),
        prefix: Icon(Icons.email,color: primaryColor,),

      ),
    );
  }

 Widget? _profileImageWidget() {
    return     ClipRRect(borderRadius: BorderRadius.circular(100.0)
      ,child:
      Container(width: 150,height: 150,child:photoUrl==null?Icon(Icons.account_circle,size: 120,color: Colors.grey,): Image.network(

        photoUrl!,
        fit: BoxFit.cover,
      ), ),);

  }

}