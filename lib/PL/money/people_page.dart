
import 'package:abukhaledapp/PL/utilities/stream_builder.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constance.dart';

class PeoplePage extends StatefulWidget {
  final String? moneyType;

  PeoplePage({this.moneyType});

  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  String? adminId;

  initialize()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(()=> adminId = prefs.getStringList(user_ref)!.first);
  }
  Widget build(BuildContext context) {

    initialize();

    return adminId==null?loadingWidget()!
        :CustomStreamBuilder(stream:Provider.of<PeopleProvider>(context)
        .myStreem(widget.moneyType!,adminId!) ,cardType: "peopleCard",noItemsMessage: "لا يوجد اشخاص",);

  }
}
