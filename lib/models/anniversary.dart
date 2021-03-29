import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';

class Anniversary {
  final String anniversaryId;
  final String husband_name;
  final String wife_name;
  final String relation;
  final String notes;
  final DateTime dateofanniversary;
  bool yearofmarriageProvided = true;
  TimeOfDay setAlarmforAnniversary;
  final List<Interest> interestsofCouple;
  final CategoryofPerson categoryofCouple;
  final String phoneNumberofCouple;
  final String emailofCouple;
  File imageofCouple;

  Anniversary({
    this.anniversaryId,
    @required this.husband_name,
    @required this.wife_name,
    @required this.relation,
    this.notes,
    @required this.dateofanniversary,
    this.yearofmarriageProvided,
    this.setAlarmforAnniversary,
    this.interestsofCouple,
    @required this.categoryofCouple,
    this.phoneNumberofCouple,
    this.emailofCouple,
    this.imageofCouple
  });

  int interestListSize() {
    if (interestsofCouple == null || interestsofCouple.isEmpty) return 0;
    return interestsofCouple.length;
  }


}