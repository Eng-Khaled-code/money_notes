import 'package:abukhaledapp/PL/utilities/stream_builder.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantPage extends StatefulWidget {
  @override
  _TenantPageState createState() => _TenantPageState();
}

class _TenantPageState extends State<TenantPage> {
  String? adminId;

  initialize()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
   setState(()=> adminId = prefs.getStringList(user_ref)!.first);
  }

  @override
  Widget build(BuildContext context) {
    TenantProvider tenantProvider=Provider.of<TenantProvider>(context);
    initialize();

    return adminId==null?loadingWidget()!:CustomStreamBuilder(stream:tenantProvider.myStreem(adminId!) ,cardType: "tenantCard",noItemsMessage: "لا يوجد سكان",);
  }
}
