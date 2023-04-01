import 'package:abukhaledapp/PL/utilities/people_card.dart';
import 'package:abukhaledapp/PL/utilities/person_card.dart';
import 'package:abukhaledapp/PL/utilities/tenant_card.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constance.dart';

class CustomStreamBuilder extends StatelessWidget {
  Stream<QuerySnapshot<Map<String,dynamic>>>? stream;
   String? noItemsMessage;
   String? cardType;
  CustomStreamBuilder({this.stream,this.noItemsMessage,this.cardType});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:stream,builder: (context,snapshot){
      return !snapshot.hasData
          ? Center(child: CircularProgressIndicator())
          : snapshot.data!.docs.length == 0
      ? noDataCard(message:noItemsMessage!)!
          : ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, position) {
      Map<String,dynamic> data1=snapshot.data!.docs[position].data();
      switch(cardType){
        case "peopleCard":
          return PeopleCard(moneyType: data1[type_f]??"",name: data1[name_f]??"",phone: data1[phone1_f]??"",personId:  data1[person_id_f]??"");
       case "tenantCard":
          return TenantCard(tenantModel: TenantModel.fromSnapshot(data1),);
        default:
          return PersonCard(value: data1["value"]??"",reason:data1["reason"]??"",date:data1["date"]??"" ,type: data1["type"]??"",personId: data1[cardType=="dataCard"?person_id_f:"ope_id"]??"");
      }

      });
    });  }
}

