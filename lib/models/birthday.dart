
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yday/screens/add_birthday_screen.dart';

enum CategoryofPerson {
  family,
  friend,
  work,
  others,
}

class BirthDay {
  final String birthdayId;
  String nameofperson;
  final String relation;
  final String notes;
  final DateTime dateofbirth;
  bool yearofbirthProvided = true;
  TimeOfDay setAlarmforBirthday;
  final List<Interest> interestsofPerson;
  final CategoryofPerson categoryofPerson;
  final String phoneNumberofPerson;
  final String emailofPerson;
  File imageofPerson;


  BirthDay(
  {   this.birthdayId,
    @required this.nameofperson,
    @required this.relation,
      this.notes,
    @required this.dateofbirth,
      this.yearofbirthProvided,
      this.setAlarmforBirthday,
      this.interestsofPerson,
    @required this.categoryofPerson,
      this.phoneNumberofPerson,
      this.emailofPerson,
      this.imageofPerson,
  });

  String get categoryText {
    switch (categoryofPerson) {
      case CategoryofPerson.friend:
        return 'Friend';
        break;
      case CategoryofPerson.family:
        return 'Family';
        break;
      case CategoryofPerson.work:
        return 'Work';
        break;
      case CategoryofPerson.others:
        return 'Others';
      default:
        return 'Others';
    }
  }

  Color get categoryColor {
    switch (categoryofPerson) {
      case CategoryofPerson.friend:
        return Colors.green;
        break;
      case CategoryofPerson.family:
        return Colors.red;
        break;
      case CategoryofPerson.work:
        return Colors.amber;
        break;
      default:
        return Colors.lightBlue;
    }
  }

  int interestListSize() {
    if (interestsofPerson == null || interestsofPerson.isEmpty) return 0;
    return interestsofPerson.length;
  }

  bool get yearofBirthProvidedStatus {
    if(yearofbirthProvided == null)
      return true;
    return yearofbirthProvided;
  }
  // String get categoryText {
  //   switch(categoryofPerson){
  //     case CategoryofPerson.friend :
  //       return 'Friend';
  //       break;
  //     case CategoryofPerson.family :
  //       return 'Family';
  //       break;
  //     case CategoryofPerson.work :
  //       return 'Work';
  //       break;
  //     default:
  //       return 'Others';
  //   }
  // }
}
