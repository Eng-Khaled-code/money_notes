import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:flutter/material.dart';

///colors
const primaryColor = Color.fromRGBO(0, 197, 105, 1);

///tenant fields
const tenant_ref = "tenant";
const tenant_id_f = "tenant_id";
const name_f = "name";
const phone1_f = "phone1";
const phone2_f = "phone2";
const flat_number_f = "flat_number";
const flat_value_f = "flat_value";
const added_value_f = "added_value";
const addition_month = "addition_month";
const disibled_list_f = "disabled_list";
const last_paied_month_f = "last_paied_month";

///months fields
const table_ref = "table";
const months_ref = "months";
const month_number_f = "month_number";
const month_name_f = "month_name";
const status_f = "status";
const year_f = "year";

///people fields
const people_ref = "people";
const type_f = "type";
const person_id_f = "person_id";
const i_pay_to_him = "i_pay_to_him";
const he_pay_to_me = "he_pay_to_me";
const admin_id_f="admin_id";

// user fields

const user_ref="users";
const user_id_f="user_id";
const user_name_f="user_name";
const user_email_f="email";
const password_f="password";
const photo_url_f="photo_url";
const user_phone="phone";

List<int> monthsNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

///methods
goTo({@required BuildContext? context, @required Widget? to}) {
  Navigator.push(context!, MaterialPageRoute(builder: (context) => to!));
}

showSnackBar({@required BuildContext? context, @required message}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: CustomText(
        text: message,
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,duration: Duration(seconds: 5),));
}

Widget? loadingWidget(){
  return Center(child: CircularProgressIndicator(color: primaryColor,),);
}
Widget? noDataCard({required String message}) {
  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Icon(
        Icons.emoji_emotions,
        color: primaryColor,
        size: 50,
      ),
      SizedBox(
        height: 10,
      ),
      CustomText(text: message)
    ],
  );
}

AppBar? CustomAppBar({String? title}) {
  return AppBar(
      automaticallyImplyLeading: false,
      title: CustomText(
        text: title!,
        color: Colors.white,
      ),
      centerTitle: true, flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.greenAccent,
          primaryColor,

        ],
      ),
    ),));
}

  Widget? backgroundImage() {
    return  Container(
      height: double.infinity,
      width: double.infinity,
      child: Opacity(
          opacity: 0.5,
          child: Image.asset(
            'assets/images/splach_bg.png',
            fit: BoxFit.fill,
          )),
    );
  }

