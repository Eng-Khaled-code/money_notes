import 'package:abukhaledapp/constance.dart';

class TenantModel {
String? tenantId, name, phone1, phone2,adminId;

int? flatNumber, additionMonth;

double? flatValue, addedValue;

List? disabledList;
Map<String,dynamic>? lastPaiedMonth;

TenantModel(
{this.tenantId,
this.name,
this.phone1,
this.phone2,
this.flatNumber,
this.flatValue,
this.addedValue,
this.additionMonth,this.disabledList,this.lastPaiedMonth,this.adminId});

TenantModel.fromSnapshot(Map<String, dynamic> snapshot) {
tenantId = snapshot[tenant_id_f]??"";
name = snapshot[name_f]??"";
phone1 = snapshot[phone1_f]??"";
phone2 = snapshot[phone2_f]??"";
flatNumber = snapshot[flat_number_f]??"";
flatValue = snapshot[flat_value_f]??"";
addedValue = snapshot[added_value_f]??"";
additionMonth = snapshot[addition_month]??"";
disabledList=snapshot[disibled_list_f]??"";
lastPaiedMonth=snapshot[last_paied_month_f]??"";
adminId=snapshot[admin_id_f]??"";
}

}
