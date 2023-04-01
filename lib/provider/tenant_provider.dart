import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/interfaces/tenant_interface.dart';
import 'package:abukhaledapp/models/tenant_model.dart';
import 'package:abukhaledapp/services/tenant_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class TenantProvider extends TenantInterface with ChangeNotifier {
  bool teniantLoading = false;
  String error = "";
  TenantServices _tenantServices =TenantServices();
  List<TenantModel>? tenantList;
  double? flatValueLoaded;
  TenantProvider() {
    loadTenants();
  }
  @override
  Future<bool> addTenant({Map<String, dynamic>? data}) async {
    try {
      teniantLoading = true;
      notifyListeners();

      await _tenantServices.addTenantToFirestore(data: data!);

      teniantLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      teniantLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> updateTenant({required Map<String, dynamic> data}) async {
    try {
      teniantLoading = true;
      notifyListeners();

      await _tenantServices.updateTenantToFirestore(data: data);

      teniantLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      teniantLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<bool> deleteTenant({required String tenantId}) async {
    try {
      teniantLoading = true;
      notifyListeners();

      await _tenantServices.deleteTenantFromFirestore(tenantId: tenantId);

      teniantLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      teniantLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }

  @override
  Future<void> loadTenants() async {
    tenantList = await _tenantServices.loadTenantsList();
    notifyListeners();
  }

  @override
  Future<void> loadFlatValue({required String tenantId}) async {
    flatValueLoaded = await _tenantServices.loadFlatValue( tenantId:tenantId) ;
    notifyListeners();
  }
  @override
  Future<bool> updateFlatValue({required String tenantId,required double flatValue,required double additionValue,required int additionMonth}) async {
  try{
    teniantLoading = true;
    notifyListeners();

    await _tenantServices.updateFlatValue(tenantId: tenantId,flatValue: flatValue,additionValue: additionValue,additionMonth: additionMonth);

    teniantLoading = false;
    notifyListeners();
    return true;
  } on FirebaseException catch (e) {
  teniantLoading = false;
  error = e.message!;
  notifyListeners();
  return false;
  }}

  @override
  Stream<QuerySnapshot<Map<String,dynamic>>> myStreem(String adminId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance.collection(tenant_ref).where(admin_id_f,isEqualTo: adminId).get().asStream();
    notifyListeners();
    return stream;
  }

}
