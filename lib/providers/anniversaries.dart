import 'package:flutter/material.dart';
import 'package:yday/models/anniversary.dart';

import '../models/anniversary.dart';

class Anniversaries with ChangeNotifier{
  List<Anniversary> _anniversaryList=[];

  List<Anniversary> get anniversaryList => _anniversaryList;

  void addAnniversary(Anniversary anniv){
    final newAnniv = Anniversary(
      anniversaryId: anniv.anniversaryId,
      husband_name: anniv.husband_name,
      wife_name: anniv.wife_name,
      relation: anniv.relation,
      notes: anniv.notes,
      dateofanniversary: anniv.dateofanniversary,
      yearofmarriageProvided: anniv.yearofmarriageProvided,
      setAlarmforAnniversary: anniv.setAlarmforAnniversary,
      interestsofCouple: anniv.interestsofCouple,
      categoryofCouple: anniv.categoryofCouple,
      phoneNumberofCouple: anniv.phoneNumberofCouple,
      emailofCouple: anniv.emailofCouple,
      imageofCouple: anniv.imageofCouple,
    );
    _anniversaryList.add(newAnniv);
    notifyListeners();
  }

  Anniversary findById(String annivId){
    return _anniversaryList.firstWhere((element) => element.anniversaryId == annivId);
  }
  List<Anniversary> findByDate(DateTime birthdayDateTime){
    return _anniversaryList.where((element) => element.dateofanniversary.day==birthdayDateTime.day&&element.dateofanniversary.month==birthdayDateTime.month).toList();
  }
  void completeEvent(String anniversaryid){
    _anniversaryList.removeWhere((element) => element.anniversaryId==anniversaryid);
    notifyListeners();
  }
}