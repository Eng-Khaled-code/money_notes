import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PeopleInterface {
    Future<bool> addPerson({required Map<String, dynamic> data});
    Future<bool> updatePerson({required Map<String, dynamic> data});
    Future<bool> deletePerson({required String personId});
    Stream<QuerySnapshot<Map<String,dynamic>>> myStreem(String moneyType,String adminId);
    Stream<QuerySnapshot<Map<String,dynamic>>> personDataStreem({String? personId});
    Stream<QuerySnapshot<Map<String,dynamic>>> personData2Streem({String? personId});

    Stream<QuerySnapshot<Map<String,dynamic>>> personValuesStreem({String? personId});
    Stream<QuerySnapshot<Map<String,dynamic>>> personValues2Streem({String? personId});
    Future<void> loadTotal({String? personId,String? type});
    Future<bool> addOperation({Map<String, dynamic>? data});
    Future<bool> updateOperation({Map<String, dynamic>? data});
    Future<bool> deleteOperation({ Map<String, dynamic>? data});
    }
