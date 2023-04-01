import 'package:abukhaledapp/PL/utilities/show_dialog.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'custom_text.dart';

class PersonCard extends StatelessWidget {
    final String? type;
    final double? value;
    final String? reason;
    final String? date;
    final String? personId;
    PersonCard({this.reason, this.value,this.type,this.date,this.personId});

    @override
    Widget build(BuildContext context) {

  DateTime dateTime=DateTime.fromMillisecondsSinceEpoch(int.parse(date!));
  int year=dateTime.year,month=dateTime.month,day=dateTime.day;
      PeopleProvider peopleProvider=Provider.of<PeopleProvider>(context);
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
        child: Row(          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
                CustomText(
                text:value.toString(),
                ),
                SizedBox(height: 10,),
               type=="values"||type=="data2" ?Container(height: 0,):Column(crossAxisAlignment:  CrossAxisAlignment.start,
                 children: [
                   Text("السبب : "),
                   Container(
                     width: 200,
                     height: reason!.length>100 ?100:50,
                     child: Text(
                           "${reason}"),
                   ),
                 ],
               ),SizedBox(height: 10,),
                CustomText(
                  text: "التاريخ : ${year.toString()} - ${month} - ${day} ",
                  color: Colors.black54,
                ),
                ],
            ),

            Container(
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        _deleteOrUpdateWidget(
        type: "تعديل",
            onPress: () {
              showDialog1(context: context,addOrUpdate: "update",value1:value,reason1: reason,personId: personId,date: date,type: type);
        },
        )!,
          _deleteOrUpdateWidget(
              type: "حذف",
              onPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: CustomText(
                          text:
                          "هل انت متاكد من إنك تريد حذف ${value.toString()}" +
                          " نهائيا ",color: Colors.white,),
                      action: SnackBarAction(
                          textColor: primaryColor,
                          label: "حذف",
                          onPressed: () async {
                            if(await peopleProvider.deleteOperation(data:{person_id_f:personId,"date":date}))
                               Fluttertoast.showToast(msg: "تم الحذف بنجاح");
                             else{
                              Fluttertoast.showToast(msg: peopleProvider.error);

                            }
                            },
                      ),
                  ));
              })!,
          ],
        ),
        ),
          ],
        ),
        ),
        );
        }

    Widget? _deleteOrUpdateWidget({String? type, Function()? onPress}) {
Color btnColor = type == "تعديل" ? Colors.black : Colors.black;
return IconButton(
icon:Icon(type=="تعديل"?Icons.edit:Icons.delete,color:btnColor,size: 30,) ,
onPressed: onPress,
);
}
}
