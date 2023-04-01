import 'package:abukhaledapp/interfaces/people_interface.dart';
import 'package:abukhaledapp/services/people_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../constance.dart';

class PeopleProvider extends PeopleInterface with ChangeNotifier {
  bool peopleLoading = false;
  String error = "";
  double total=0;

  PeopleServices peopleServices=PeopleServices();
  @override
  Future<bool> addPerson({Map<String, dynamic>? data}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.addPersonToFirestore(data: data!);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> updatePerson({required Map<String, dynamic> data}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.updatePersonToFirestore(data: data);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> deletePerson({required String personId}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.deletePersonFromFirestore(personId: personId);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }
  @override
  Future<bool> addOperation({ Map<String, dynamic>? data}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.addOperation(data: data!);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }
  @override
  Future<bool> updateOperation({ Map<String, dynamic>? data}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.updateOperation(data: data!);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> deleteOperation({ Map<String, dynamic>? data}) async {
    try {
      peopleLoading = true;
      notifyListeners();

      await peopleServices.deleteOperation(data: data!);

      peopleLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      peopleLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<void> loadTotal({String? personId,String? type}) async {
    total = await peopleServices.getTotal(personId: personId,type: type);
    notifyListeners();
  }


  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> myStreem(String moneyType,String adminId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(people_ref).where(
        type_f, isEqualTo: moneyType).where(admin_id_f,isEqualTo: adminId).get().asStream();
    notifyListeners();
  return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> personDataStreem({String? personId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(people_ref).doc(personId).collection("data").where(
        type_f, isEqualTo:"data" ).get().asStream();

    notifyListeners();
    return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> personValuesStreem({String? personId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(people_ref).doc(personId).collection("data").where(
        type_f, isEqualTo:"values" ).get().asStream();
    notifyListeners();
    return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> personData2Streem({String? personId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(people_ref).doc(personId).collection("data").where(
        type_f, isEqualTo:"data2" ).get().asStream();
    notifyListeners();
    return stream;
  }

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> personValues2Streem({String? personId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(people_ref).doc(personId).collection("data").where(
        type_f, isEqualTo:"values2" ).get().asStream();
    notifyListeners();
    return stream;
  }

}
