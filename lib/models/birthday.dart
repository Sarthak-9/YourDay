
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yday/models/interests.dart';
import 'constants.dart';

class BirthDay {
  final String birthdayId;
  final String calenderId;
  final String nameofperson;
  final String gender;
  final String notes;
  final String zodiacSign;
  final int notifId;
  final DateTime dateofbirth;
  bool yearofbirthProvided = true;
  // TimeOfDay setAlarmforBirthday;
  final List<Interest> interestsofPerson;
  final CategoryofPerson categoryofPerson;
  final String phoneNumberofPerson;
  final String emailofPerson;
  File imageofPerson;
  String imageUrl = null;

  BirthDay(
  {   this.birthdayId,
      this.calenderId,
    @required this.nameofperson,
    @required this.gender,
      this.notes,
    this.zodiacSign,
    @required this.dateofbirth,
      this.yearofbirthProvided,
      // this.setAlarmforBirthday,
      this.interestsofPerson,
    @required this.categoryofPerson,
      this.phoneNumberofPerson,
      this.emailofPerson,
      this.imageofPerson,
    this.imageUrl,
    this.notifId,
  });


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
