import 'package:abukhaledapp/interfaces/day_interface.dart';
import 'package:abukhaledapp/services/day_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../constance.dart';

class DayProvider extends DayInterface with ChangeNotifier {
  bool dayLoading = false;
  String error = "";
  double total=0;

  DayServices _dayServices=DayServices();

  @override
  Future<bool> addOperation({ Map<String, dynamic>? data}) async {
    try {
      dayLoading = true;
      notifyListeners();

      await _dayServices.addDayOpeToFirestore(data: data!);

      dayLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      dayLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }
  @override
  Future<bool> updateOperation({ Map<String, dynamic>? data}) async {
    try {
      dayLoading = true;
      notifyListeners();

      await _dayServices.updateOperation(data: data!);

      dayLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      dayLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> deleteDayOperation({String? opeId}) async {
    try {
      dayLoading = true;
      notifyListeners();

      await _dayServices.deleteOperation(opeId: opeId!);

      dayLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      dayLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<void> loadTotal({String? date,String? type,String? adminId}) async {
    total = await _dayServices.getTotal(date:date ,type: type,adminId: adminId);
    notifyListeners();
  }


  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> dayAllInStreem({String? adminId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection("day_operations").where(
    type_f,isEqualTo:"in" ).where("admin_id",isEqualTo: adminId).get().asStream();
    notifyListeners();
  return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> dayInByDateStreem({String? date,String? adminId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection("day_operations").where(
        "date", isEqualTo: date).where(
        type_f,isEqualTo:"in" ).where("admin_id",isEqualTo: adminId).get().asStream();
    notifyListeners();
    return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> dayOutByDateStreem({String? date,String? adminId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection("day_operations").where(
        "date", isEqualTo: date).where(
        type_f,isEqualTo:"out" ).where("admin_id",isEqualTo: adminId).get().asStream();
    notifyListeners();
    return stream;
  }
  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> dayAllOutStreem({String? adminId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection("day_operations").where(
        type_f,isEqualTo:"out" ).where("admin_id",isEqualTo: adminId).get().asStream();
    notifyListeners();
    return stream;
  }


}
