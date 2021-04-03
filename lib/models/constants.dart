import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/interests.dart';

class Constants{
  static SharedPreferences prefs;
}

enum CategoryofPerson {
  family,
  friend,
  work,
  others,
}

String categoryText (CategoryofPerson categoryofPerson) {
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

CategoryofPerson getCategory(String catText){
  switch (catText) {
    case 'Friend':
      return CategoryofPerson.friend;
      break;
    case 'Family' :
      return CategoryofPerson.family;
      break;
    case 'Work':
      return CategoryofPerson.work;
      break;
    case 'Others' :
      return CategoryofPerson.others;
    default:
      return CategoryofPerson.others;
  }
}

Color categoryColor(CategoryofPerson categoryofPerson) {
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

