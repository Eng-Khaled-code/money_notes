
import 'package:abukhaledapp/PL/utilities/stream_builder.dart';
import 'package:abukhaledapp/provider/day_ope_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayOperations extends StatefulWidget {
  final String? type;
  final String? adminId;
  String? selectedItem;

  DayOperations({Key? key,this.type,this.adminId,this.selectedItem}): super(key: key);

  @override
  _DayDayOperationsState createState() => _DayDayOperationsState();
}

class _DayDayOperationsState extends State<DayOperations> {
  double total=0;
  @override
  Widget build(BuildContext context) {
    DayProvider dayProvider= Provider.of<DayProvider>(context);
    if(widget.selectedItem!="الكل"){
       dayProvider.loadTotal(date: widget.selectedItem,adminId: widget.adminId,type: widget.type);
    total=dayProvider.total;}
    return Directionality(
    textDirection: TextDirection.rtl,
    child: _body(dayProvider: dayProvider)!
    );
  }

  Widget? _body({DayProvider? dayProvider}){

    Stream<QuerySnapshot<Map<String,dynamic>>> stream =
    (widget.type=="in"&&widget.selectedItem=="الكل")
        ?
    dayProvider!.dayAllInStreem(adminId:widget.adminId!)
        :
    (widget.type=="in"&&widget.selectedItem!="الكل")?
    dayProvider!.dayInByDateStreem(date: widget.selectedItem,adminId:widget.adminId!)

        :(widget.type=="out"&&widget.selectedItem!="الكل")?
    dayProvider!.dayOutByDateStreem(date: widget.selectedItem,adminId:widget.adminId!)
        :
    dayProvider!.dayAllOutStreem(adminId:widget.adminId!)

    ;
    return Container(
        height: double.infinity,
   child:Stack(alignment: Alignment.center,children: [CustomStreamBuilder(
    stream:stream ,
    cardType: "data1",
    noItemsMessage: "لا توجد بيانات",
    ),widget.selectedItem!="الكل"?Positioned(top:0,child: Text("الاجمالي : "+"${total.toString()}")):Container(height: 0)]));
  }
}

