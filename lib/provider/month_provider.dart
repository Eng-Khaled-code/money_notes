import 'package:abukhaledapp/interfaces/month_interface.dart';
import 'package:abukhaledapp/models/month_data_model.dart';
import 'package:abukhaledapp/services/month_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MonthProvider extends MonthInterface with ChangeNotifier {
  bool addYearLoding = false;
  bool monthStatusLoading = false;
  double? total;
  String error = "";
  List<int>? years;
  List? disabledYears;
  MonthDataModel? lastPaiedMonth;
 MonthServices _monthServices= MonthServices();
  @override
  Future<bool> addNewYear({required int year,required String tenantId,required double flatValue,required double additionValue,required int additionMonth}) async {
    try {
      addYearLoding = true;
      notifyListeners();

      await _monthServices.addNewYear(year: year,tenantId: tenantId,flatValue: flatValue,additionValue: additionValue,additionMonth: additionMonth);

      addYearLoding = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {

      addYearLoding = false;
      error = e.message!;
      notifyListeners();
      return false;
    }
  }

  @override
  Future<bool> disableYear({required int year,required String tenantId,required List? disabledList }) async {

    try {
      addYearLoding = true;
      notifyListeners();

      await _monthServices.disableYear(year: year,tenantId: tenantId,disabledList: disabledList! );

      addYearLoding = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      addYearLoding = false;
      error = e.message!;
      print("error");

    notifyListeners();
    return false;
    }
    }

    @override
  Future<void> loadYears({required String tenantId}) async {
    years=await _monthServices.loadYears(tenantId: tenantId);
    notifyListeners();

  }
  @override
  Future<void> loadDisabledList({required String tenantId}) async {
    disabledYears=await _monthServices.loadDisabledList(tenantId);
    notifyListeners();
  }

  @override
  Future<List<Map<String,dynamic>>>? loadMonthsByYear(int year,String tenantId)async{

    return await _monthServices.loadMonthsListMap(year, tenantId)!;

  }

  @override
  Future<MonthDataModel>? loadLastMonthByYear({int? year,String? tenantId})async{
    return await _monthServices.loadLastMonthByYear(year: year,tenantId: tenantId)!;

  }
  @override
  Future<void> loadLastPaiedMonth({required String tenantId}) async {
    lastPaiedMonth=await _monthServices.loadLastPaiedMonth(tenantId:tenantId)!;
    notifyListeners();
  }

  @override
  Future<bool> changeMonthStatus({required MonthDataModel model}) async {
    try {

      await _monthServices.changeMonthStatus(model: model);

      notifyListeners();
      return true;
    } on FirebaseException catch (e) {

      monthStatusLoading = false;
      error = e.message!;
    notifyListeners();
    return false;
    }
    }
  @override
  Future<void> updateLastPaiedMonth({required int monthNumber,required int year,required String tenantId})async{
    await _monthServices.updateLastPaiedMonth(tenantId:tenantId,monthNumber: monthNumber,year: year);
    notifyListeners();
  }

  Future<void> loadTotal({required String tenantId,required int lastPaiedYear,required int lastPaiedMonth}) async {
    total=await _monthServices.loadTotal(tenantId: tenantId, lastPaiedYear: lastPaiedYear, lastPaiedMonth: lastPaiedMonth);
    notifyListeners();
  }
  }