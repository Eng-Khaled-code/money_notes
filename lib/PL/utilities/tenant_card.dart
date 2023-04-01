import 'package:abukhaledapp/PL/registration/check_password.dart';
import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:abukhaledapp/PL/tenant/tenant_details.dart';
import 'package:abukhaledapp/PL/tenant/tenant_operations.dart';
import 'package:abukhaledapp/provider/tenant_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'custom_text.dart';

class TenantCard extends StatelessWidget {
    final TenantModel? tenantModel;

    TenantCard({Key, this.tenantModel}) : super(key: Key);

    @override
    Widget build(BuildContext context) {
        TenantProvider tenantProvider = Provider.of<TenantProvider>(context);
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () => goTo(
            context: context,
            to: TenantDetails(tenantModel: tenantModel)),
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(  gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent,
                    primaryColor,

                  ]),borderRadius: BorderRadius.circular(10),),
          child: Row(          mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                  CustomText(
                  text: "${tenantModel!.name!}",
                  ),
                  SizedBox(height: 10,),
                  CustomText(
                      text: "رقم الشقة : ${tenantModel!.flatNumber}",
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
        goTo(
        context: context,
        to: TenantOperations.update(
        type: "update",
        tenantId: tenantModel!.tenantId,
        name: tenantModel!.name,
        phone1: tenantModel!.phone1,
        phone2: tenantModel!.phone2,
        flatNumber: tenantModel!.flatNumber,
        flatValue: tenantModel!.flatValue,
        addedValue: tenantModel!.addedValue,
        additionMonth: tenantModel!.additionMonth,
        ));
        },
        )!,
            _deleteOrUpdateWidget(
                type: "حذف",
                onPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: CustomText(
                            text:
                            "هل انت متاكد من إنك تريد حذف ${tenantModel!.name}" +
                            "نهائيا",color: Colors.white,),
                        action: SnackBarAction(
                            textColor: primaryColor,
                            label: "حذف",
                            onPressed: () async {

                                goTo(context: context,to: CheckPassword(type: "delete",onPress: ()async{
                                    await tenantProvider.deleteTenant(
                                        tenantId: tenantModel!.tenantId!);
                                    Fluttertoast.showToast(msg: "تم حذف الساكن بنجاح");
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
