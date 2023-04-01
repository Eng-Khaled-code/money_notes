import 'package:abukhaledapp/PL/money/people_details.dart';
import 'package:abukhaledapp/PL/money/people_operations.dart';
import 'package:abukhaledapp/PL/registration/check_password.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/provider/people_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'custom_text.dart';

class PeopleCard extends StatelessWidget {
    final String? moneyType;
    final String? name;
    final String? phone;
    final String? personId;


    PeopleCard({Key? key,this.moneyType, this.name, this.phone,this.personId}): super(key: key);

    @override
    Widget build(BuildContext context) {
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () => goTo(
            context: context,
            to:PeopleDetails(moneyType: moneyType,name: name,phone: phone,personId: personId)),
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(  gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent,
primaryColor
                  ]),borderRadius: BorderRadius.circular(10)),
          child: Row(          mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                  CustomText(
                  text:"${name!}",
                  ),
                  SizedBox(height: 10,),
                  CustomText(
                      text: "رقم التليفون : ${phone}",
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

            goTo(context: context, to: PeopleOperations.update(type: "update",moneyType: moneyType,name:name ,peopleId: personId,phone: phone));
        },
        )!,
            _deleteOrUpdateWidget(
                type: "حذف",
                onPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: CustomText(
                            text:
                            "هل انت متاكد من إنك تريد حذف ${name}" +
                            "نهائيا",color: Colors.white,),
                        action: SnackBarAction(
                            textColor: primaryColor,
                            label: "حذف",
                            onPressed: () async {

                                goTo(context: context,to: CheckPassword(type: "delete",onPress: ()async{
                                   await Provider.of<PeopleProvider>(context,listen: false).deletePerson(personId: personId!);

                                    Fluttertoast.showToast(msg: "تم الحذف بنجاح");
                                },));
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
