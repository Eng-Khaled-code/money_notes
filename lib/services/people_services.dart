import 'package:abukhaledapp/constance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PeopleServices {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> addPersonToFirestore(
        {required Map<String, dynamic> data}) async {
        await _firestore.collection(people_ref).doc(data[person_id_f]).set(data);
    }

    Future<void> updatePersonToFirestore(
        {required Map<String, dynamic> data}) async {
     await _firestore.collection(people_ref).doc(data[person_id_f]).update(data);
    }
      Future<void> addOperation(
        {required Map<String, dynamic> data}) async {
       await _firestore.collection(people_ref).doc(data[person_id_f]).collection("data").doc(data["date"]).set(data);
    }
    Future<void> updateOperation(
        {required Map<String, dynamic> data}) async {
        await _firestore.collection(people_ref).doc(data[person_id_f]).collection("data").doc(data["date"]).update(data);
    }
    Future<void> deleteOperation(
        {required Map<String, dynamic> data}) async {
       await _firestore.collection(people_ref).doc(data[person_id_f]).collection("data").doc(data["date"]).delete();
    }

    Future<double> getTotal({String? personId,String? type})async{
        double value=0;

        await _firestore.collection(people_ref).doc(personId).collection("data").where(type_f,isEqualTo: type).get().then((value1){
            value1.docs.forEach((element) {
                value=value+element.get("value");
            });

        });

        return value;
    }

    Future<void> deletePersonFromFirestore({required String personId}) async {

           await _firestore.collection(people_ref).doc(personId).collection("data").doc().delete();
           await _firestore.collection(people_ref).doc(personId).delete();

       }


}
