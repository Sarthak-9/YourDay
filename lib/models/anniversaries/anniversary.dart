import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';

class Anniversary {
  final String anniversaryId;
  final String calenderId;
  final String husband_name;
  final String wife_name;
  final int notifId;
   String notes;
  final DateTime dateofanniversary;
  bool yearofmarriageProvided = true;
  // TimeOfDay setAlarmforAnniversary;
   List<Interest> interestsofCouple;
  final CategoryofPerson categoryofCouple;
   String phoneNumberofCouple;
   String emailofCouple;
  File imageofCouple;
  String imageUrl = null;

  Anniversary({
    this.anniversaryId,
    this.calenderId,
    @required this.husband_name,
    @required this.wife_name,
    // @required this.relation,
    this.notes,
    @required this.dateofanniversary,
    this.yearofmarriageProvided,
    // this.setAlarmforAnniversary,
    this.interestsofCouple,
    @required this.categoryofCouple,
    this.phoneNumberofCouple,
    this.emailofCouple,
    this.imageofCouple,
    this.imageUrl,
    this.notifId,
  });

  int interestListSize() {
    if (interestsofCouple == null || interestsofCouple.isEmpty) return 0;
    return interestsofCouple.length;
  }


}