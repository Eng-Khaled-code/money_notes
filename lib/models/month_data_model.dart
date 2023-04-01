import 'package:abukhaledapp/constance.dart';

class MonthDataModel {
  String? monthName, status, tenantId;
  int? monthNumber;
  double? flatValue;
  int? year;
  MonthDataModel({
    this.tenantId,
    this.status,
    this.monthNumber,
    this.monthName,
    this.flatValue,
    this.year,
  });

  MonthDataModel.empty();

  MonthDataModel.fromSnapshot(Map<String, dynamic> snapshot) {
    tenantId = snapshot[tenant_id_f];
    status = snapshot[status_f];
    monthNumber = snapshot[month_number_f];
    monthName = snapshot[month_name_f];
    flatValue = snapshot[flat_value_f];
    year = snapshot[year_f];

  }
}
