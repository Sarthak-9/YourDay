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
String categoryTextFromNumber (int categoryNumber) {
  switch (categoryNumber) {
    case 0:
      return 'Friend';
      break;
    case 1:
      return 'Family';
      break;
    case 2:
      return 'Work';
      break;
    case 3:
      return 'Others';
    default:
      return 'Others';
  }
}
String zodiacSign (DateTime birthDay) {
  int dtYear = DateTime.now().year;
  String zodiac;
  DateTime currentTime = DateTime.utc(dtYear,birthDay.month,birthDay.day);
  print(currentTime);
  if(currentTime.isBefore(DateTime.utc(dtYear,01,20,0,0,0))){
    zodiac = 'Capricorn';
  } else if(currentTime.isBefore(DateTime.utc(dtYear,2,18,0,0,0))){
    zodiac = 'Aquarius';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,3,20,0,0,0))){
    zodiac = 'Pisces';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,04,20,0,0,0))){
    zodiac = 'Aries';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,05,20,0,0,0))){
    zodiac = 'Taurus';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,06,21,0,0,0))){
    zodiac = 'Gemini';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,07,22,0,0,0))){
    zodiac = 'Cancer';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,08,22,0,0,0))){
    zodiac = 'Leo';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,09,22,0,0,0))){
    zodiac = 'Virgo';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,10,23,0,0,0))){
    zodiac = 'Libra';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,11,22,0,0,0))){
    zodiac = 'Scorpio';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,12,22,0,0,0))){
    zodiac = 'Sagittarius';
  }else if(currentTime.isAfter(DateTime.utc(dtYear,12,22,0,0,0))){
    zodiac = 'Capricorn';
  } else{
    zodiac = 'Capricorn';
  }
  // bool zodiac =currentTime.isAfter(DateTime.utc(dtYear));
  // if(currentTime.isBefore(DateTime.utc(dtYear,01,20,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,0,0,0,0,0))){
  //   zodiac = 'Capricorn';
  // } else if(currentTime.isAfter(DateTime.utc(dtYear,01,20,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,2,18,0,0,0))){
  //   zodiac = 'Aquarius';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,02,18,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,3,20,0,0,0))){
  //   zodiac = 'Pisces';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,03,20,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,04,20,0,0,0))){
  //   zodiac = 'Aries';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,04,20,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,05,20,0,0,0))){
  //   zodiac = 'Taurus';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,05,20,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,06,21,0,0,0))){
  //   zodiac = 'Gemini';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,06,21,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,07,22,0,0,0))){
  //   zodiac = 'Cancer';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,07,22,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,08,22,0,0,0))){
  //   zodiac = 'Leo';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,08,22,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,09,22,0,0,0))){
  //   zodiac = 'Virgo';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,09,22,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,10,23,0,0,0))){
  //   zodiac = 'Libra';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,10,23,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,11,22,0,0,0))){
  //   zodiac = 'Scorpio';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,11,22,0,0,0))&&currentTime.isBefore(DateTime.utc(dtYear,12,22,0,0,0))){
  //   zodiac = 'Sagittarius';
  // }else if(currentTime.isAfter(DateTime.utc(dtYear,12,22,0,0,0))){
  //   zodiac = 'Capricorn';
  // } else{
  //   zodiac = 'Capricorn';
  // }
  return zodiac;
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
    case CategoryofPerson.others:
      return Colors.lightBlue;
      break;
    default:
      return Colors.lightBlue;
  }
}

