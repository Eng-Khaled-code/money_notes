import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'month_services.dart';

class TenantServices {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> addTenantToFirestore(
        {required Map<String, dynamic> data}) async {
        _firestore.collection(tenant_ref).doc(data[tenant_id_f]).set(data);
    }

    Future<void> updateTenantToFirestore(
        {required Map<String, dynamic> data}) async {
        _firestore.collection(tenant_ref).doc(data[tenant_id_f]).update(data);
    }

    Future<void> deleteTenantFromFirestore({required String tenantId}) async {
        List<int> years=await MonthServices().loadYears(tenantId: tenantId)!;

       years.forEach((element) async{

             for(int i=1;i<=12;i++)
               _firestore.collection(tenant_ref).doc(tenantId).collection(table_ref).doc(element.toString()).collection(months_ref).doc(i.toString()).delete();

            _firestore.collection(tenant_ref).doc(tenantId).collection(table_ref).doc(element.toString()).delete();

        });

        _firestore.collection(tenant_ref).doc(tenantId).delete();
    }

    Future<List<TenantModel>> loadTenantsList() async {
        List<TenantModel> finalList = [];
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(tenant_ref).get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotList =
            snapshot.docs;
        snapshotList.forEach((element) {
            TenantModel tenantModel = TenantModel.fromSnapshot(element.data());
            finalList.add(tenantModel);
        });

        return finalList;
    }

    //operations for adding new year
    Future<void> updateFlatValue({required tenantId,required double flatValue,required double additionValue,required int additionMonth}) async {
      await _firestore.collection(tenant_ref).doc(tenantId).update({flat_value_f:flatValue});
      List<int> years=await MonthServices().loadYears(tenantId: tenantId)!;

      double finalFlatValue=0;
      double greatValue=0;
   for(int i=0;i<years.length;i++){
      finalFlatValue=flatValue+(additionValue*i);
      greatValue=flatValue+(additionValue*i)+additionValue;
      for (int month = 1; month <= 12; month++) {

        finalFlatValue=additionMonth>month?finalFlatValue:greatValue;

        await _firestore
            .collection(tenant_ref)
            .doc(tenantId)
            .collection(table_ref)
            .doc(years[i].toString())
            .collection(months_ref)
            .doc(month.toString())
            .update({
          flat_value_f:finalFlatValue,
        });
      }

      }
    }

    Future<double> loadFlatValue({required String tenantId}) async {

      double value=0;
      await _firestore.collection(tenant_ref).doc(tenantId).get().then((value1){
        value=value1.get(flat_value_f);
      });

      return value;
    }


}
