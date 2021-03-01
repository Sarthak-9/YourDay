import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yday/screens/add_birthday_screen.dart';

enum CategoryofCouple {
  family,
  friend,
  work,
  others,
}

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
  final CategoryofCouple categoryofCouple;
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

  String get categoryText {
    switch (categoryofCouple) {
      case CategoryofCouple.friend:
        return 'Friend';
        break;
      case CategoryofCouple.family:
        return 'Family';
        break;
      case CategoryofCouple.work:
        return 'Work';
        break;
      case CategoryofCouple.others:
        return 'Others';
      default:
        return 'Others';
    }
  }

  Color get categoryColor {
    switch (categoryofCouple) {
      case CategoryofCouple.friend:
        return Colors.amber;
        break;
      case CategoryofCouple.family:
        return Colors.red;
        break;
      case CategoryofCouple.work:
        return Colors.deepOrange;
        break;
      default:
        return Colors.black26;
    }
  }

  int interestListSize() {
    if (interestsofCouple == null || interestsofCouple.isEmpty) return 0;
    return interestsofCouple.length;
  }


}