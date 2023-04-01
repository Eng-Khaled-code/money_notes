import 'package:abukhaledapp/provider/day_ope_provider.dart';
import 'package:abukhaledapp/provider/month_provider.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abukhaledapp/provider/home_provider.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:abukhaledapp/provider/user_provider.dart';
import 'PL/registration/check_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TenantProvider()),
      ChangeNotifierProvider(create: (_) => MonthProvider()),
      ChangeNotifierProvider(create: (_) => PeopleProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DayProvider()),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'حساباتي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primaryColor,
          primarySwatch: Colors.green,
          iconTheme: IconThemeData(
            color: Colors.white,
          )),
     home: CheckPassword(type:"log_in"),
      // home: HomeController(),
    );
  }

}
