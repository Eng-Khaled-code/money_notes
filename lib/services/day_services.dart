import 'package:abukhaledapp/constance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DayServices {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> addDayOpeToFirestore(
        {required Map<String, dynamic> data}) async {
      await  _firestore.collection("day_operations").doc(data["ope_id"]).set(data);
    }

    Future<void> updateOperation(
        {required Map<String, dynamic> data}) async {
      await _firestore.collection("day_operations").doc(data["ope_id"]).update(data);
    }
    Future<void> deleteOperation(
        {required String opeId}) async {
      await _firestore.collection("day_operations").doc(opeId).delete();
    }

    Future<double> getTotal({String? date,String? type,String? adminId})async{
        double value=0;

        await _firestore.collection("day_operations").where(admin_id_f,isEqualTo: adminId).where(type_f,isEqualTo: type).where("date",isEqualTo: date).get().then((value1){
            value1.docs.forEach((element) {
                value=value+element.get("value");
            });

        });

        return value;
    }


}
