import 'package:abukhaledapp/models/month_data_model.dart';

abstract class MonthInterface {
  Future<bool> addNewYear({required int year,required String tenantId,required double flatValue,required double additionValue,required int additionMonth});
  Future<void> loadYears({required String tenantId});
  Future<List<Map<String,dynamic>>>? loadMonthsByYear(int year,String tenantId);
  Future<MonthDataModel>? loadLastMonthByYear({int? year,String? tenantId});
  Future<bool> disableYear({required int year,required String tenantId,required List<int>? disabledList });
  Future<void> loadLastPaiedMonth({required String tenantId});
  Future<bool> changeMonthStatus({required MonthDataModel model});
  Future<void> updateLastPaiedMonth({required int monthNumber,required int year,required String tenantId});
  Future<void> loadTotal({required String tenantId,required int lastPaiedYear,required int lastPaiedMonth});

}
