
import 'package:abukhaledapp/services/home_services.dart';
import 'package:flutter/cupertino.dart';

import 'package:abukhaledapp/interfaces/home_interface.dart';
class HomeProvider extends HomeInterface with ChangeNotifier {

  List<String>? peopleList;
  String error = "";

  HomeServices _homeServices=HomeServices();
  Future<List<Map<String,dynamic>>> loadData(List<String> peopleList)async{
    List<Map<String,dynamic>> data =await HomeServices().loadData(peopleList);
    notifyListeners();
    return data;
  }

  @override
  Future<void> loadPeopleList({required String adminId}) async {
    peopleList = await _homeServices.loadPeopleList(adminId) ;
    notifyListeners();
  }


}
