import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DayInterface {

    Future<void> loadTotal({String? date,String? type});
    Future<bool> addOperation({Map<String, dynamic>? data});
    Future<bool> updateOperation({Map<String, dynamic>? data});
    Future<bool> deleteDayOperation({String? opeId});
    Stream<QuerySnapshot<Map<String,dynamic>>> dayAllInStreem({String? adminId});
    Stream<QuerySnapshot<Map<String,dynamic>>> dayInByDateStreem({String? date,String? adminId});
    Stream<QuerySnapshot<Map<String,dynamic>>> dayOutByDateStreem({String? date,String? adminId});
    Stream<QuerySnapshot<Map<String,dynamic>>> dayAllOutStreem({String? adminId});
    }
