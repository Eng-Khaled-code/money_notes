import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constance.dart';

class HomeServices
{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;

 Future<List<Map<String,dynamic>>> loadData(List<String> peopleList)async{
    List<Map<String,dynamic>> data=[];
     peopleList.forEach((element) async{
       QuerySnapshot<Map<String,dynamic>> i= await _firestore.collection(people_ref).doc(element).collection("data").get();

          i.docs.forEach((element1) {
            data.add(element1.data());
          });
       //print(data.toString());
     });

    //print(data.toString());

return data;
 }


  Future<List<String>> loadPeopleList(String adminId) async {
    List<String> finalList = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection(people_ref).where(admin_id_f,isEqualTo: adminId).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotList =
        snapshot.docs;
    snapshotList.forEach((element) {
      finalList.add(element.id);
    });

    return finalList;
  }


}