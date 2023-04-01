import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/models/month_data_model.dart';
import 'package:abukhaledapp/services/tenant_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TenantServices _tenantServices = TenantServices();
  List<String> _tenant_ids = [];
  List<int>years1=[];


  //operations for adding new year
  Future<void> addNewYear({required int year,required tenantId,required double flatValue,required double additionValue,required int additionMonth}) async {
    String monthName;

    await addYearField(year,tenantId);
    double finalFlatValue;
    for (int month = 1; month <= 12; month++) {
      monthName = month == 1
          ? "يناير"
          : month == 2
              ? "فبراير"
              : month == 3
                  ? "مارس"
                  : month == 4
                      ? "ابريل"
                      : month == 5
                          ? "مايو"
                          : month == 6
                              ? "يونيه"
                              : month == 7
                                  ? "يوليو"
                                  : month == 8
                                      ? "أغسطس"
                                      : month == 9
                                          ? "سبتمبر"
                                          : month == 10
                                              ? "أكتوبر"
                                              : month == 11
                                                  ? "نوفمبر"
                                                  : "ديسمبر";
      finalFlatValue=additionMonth>month?flatValue:flatValue+additionValue;

        await _firestore
            .collection(tenant_ref)
            .doc(tenantId)
            .collection(table_ref)
            .doc(year.toString())
            .collection(months_ref)
            .doc(month.toString())

            .set({
          tenant_id_f: tenantId,
          month_number_f: month,
          month_name_f: monthName,
          status_f: "غير مدفوع",
          flat_value_f:finalFlatValue,
          year_f:year
        });
    }
  }
  Future<void> addYearField(int year,String tenantId)async{


    await _firestore
        .collection(tenant_ref).doc(tenantId).collection(table_ref)
        .doc(year.toString())
        .set({"year": year});


  }

  Future<List<int>>? loadYears({required String tenantId}) async {
    List<int> list = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection(tenant_ref).doc(tenantId).collection(table_ref).orderBy("year",descending: false).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotList =
        snapshot.docs;
    snapshotList.forEach((element) {
      int id = int.parse(element.id);

      list.add(id);

    });
    return list;
  }


  //operations for disabled list
  Future<void> disableYear({required int year,required String tenantId,required List disabledList}) async {

    await _firestore.collection(tenant_ref).doc(tenantId).update({disibled_list_f:disabledList});
  }

  Future<List> loadDisabledList(String tenantId)async{

    List disabledList=[];
    await _firestore.collection(tenant_ref).doc(tenantId).get().then((value){
      disabledList=value.get(disibled_list_f);
  });

    return disabledList;
  }





  Future<void> _loadTenantsIds() async {
    await _tenantServices.loadTenantsList().then((tenantModels) {
      tenantModels.forEach((element) {
        _tenant_ids.add(element.tenantId!);
      });
    });
  }

 Future<List<Map<String,dynamic>>>? loadMonthsListMap(int year,String tenantId)async{
    List<Map<String, dynamic>> monthsList = [];



      QuerySnapshot<Map<String,dynamic>> value=
      await _firestore .collection(tenant_ref)
          .doc(tenantId)
          .collection(table_ref)
          .doc(year.toString())
         .collection(months_ref).orderBy(month_number_f,descending: false)
          .get();

      value.docs.forEach((element) {
        monthsList.add(element.data());
      });

    return  monthsList;
  }


  Future<MonthDataModel>? loadLastMonthByYear({int? year,String? tenantId})async{

    MonthDataModel value;
    DocumentSnapshot snapshot=
    await _firestore
        .collection(tenant_ref)
        .doc(tenantId)
        .collection(table_ref)
        .doc(year.toString())
        .collection(months_ref)
        .doc("12").get();
    value=MonthDataModel.fromSnapshot(snapshot.data() as Map<String,dynamic>);
    return value;
  }

  Future<MonthDataModel>? loadLastPaiedMonth({String? tenantId})async{

    MonthDataModel data=MonthDataModel.empty();
    try {
      await _firestore
          .collection(tenant_ref)
          .doc(tenantId)
          .get().then((value) {
        MonthDataModel monthDataModel = MonthDataModel.fromSnapshot(
            value.get(last_paied_month_f));
        data = monthDataModel != null ? monthDataModel : MonthDataModel.empty();
      });
    }catch(e){

      data = MonthDataModel.empty();

    }

    return data;
  }

  Future<void> changeMonthStatus({required MonthDataModel model})async{
    //make paied
    if(model.status=="غير مدفوع"){
       await _firestore
           .collection(tenant_ref)
           .doc(model.tenantId)
           .collection(table_ref)
           .doc(model.year.toString())
           .collection(months_ref)
           .doc(model.monthNumber.toString())
           .update({status_f:"مدفوع"});
       await updateLastPaiedMonth(monthNumber: model.monthNumber!,year: model.year!,tenantId:model.tenantId! );
      // loadTotal(tenantId:model.tenantId!,lastPaiedYear:model.year!,lastPaiedMonth:model.monthNumber! );
    }
    //make unPayed
    else{
      int monthNumber=model.monthNumber!-1;
      int year=model.year!;
      if(monthNumber==0)
        {
          monthNumber=12;
          year=year-1;
        }

      await _firestore
          .collection(tenant_ref)
          .doc(model.tenantId)
          .collection(table_ref)
          .doc(model.year.toString())
          .collection(months_ref)
          .doc(model.monthNumber.toString())
          .update({status_f:"غير مدفوع"});

      await updateLastPaiedMonth(monthNumber: monthNumber,year: year,tenantId:model.tenantId! );
    }




  }

  Future<void> updateLastPaiedMonth({required int monthNumber,required int year,required String tenantId})async{
    await _firestore
        .collection(tenant_ref)
        .doc(tenantId)
        .update({
      last_paied_month_f:{month_number_f:monthNumber,year_f:year,tenant_id_f:tenantId,status_f:"مدفوع"}
    });

  }


  Future<double> loadTotal({required String tenantId,required int lastPaiedYear,required int lastPaiedMonth}) async {


   DateTime now=DateTime.now();
   int thisYear=now.year;
   int thisMonth=now.month;


    double value=0;

    if(!(lastPaiedYear>=thisYear&&lastPaiedMonth>=thisMonth)) {

      int innerLastPaiedMonths = lastPaiedMonth + 1;
      int finalYear = lastPaiedYear;
      if (innerLastPaiedMonths > 12) {
        finalYear = lastPaiedYear + 1;
        innerLastPaiedMonths = 1;
      }
      for (int year = finalYear; year <= thisYear; year++) {

       for (int month = 1; month <= 12; month++) {

         if (year == thisYear && month > thisMonth)
           break;
         else if(month<innerLastPaiedMonths&&year==lastPaiedYear)
           continue;
          await _firestore.collection(tenant_ref).doc(tenantId).collection(
              table_ref).doc(year.toString()).collection(months_ref)
              .doc(month.toString())
              .get()
              .then((value1) {
            value = value + value1.get(flat_value_f);
          });




        }
      }
    }

    return value;
  }

}
