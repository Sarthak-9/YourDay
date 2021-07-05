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

  return zodiac;
}

String zodiacTraits (DateTime birthDay) {
  int dtYear = DateTime.now().year;
  String traits;

  DateTime currentTime = DateTime.utc(dtYear,birthDay.month,birthDay.day);
  if(currentTime.isBefore(DateTime.utc(dtYear,01,20,0,0,0))){
    traits = 'A fantastic leader and excel at taking initiative in any aspect of life, whether that’s work or close relationships.';
  } else if(currentTime.isBefore(DateTime.utc(dtYear,2,18,0,0,0))){
    traits = 'A deeply creative thinker and often dreams about changing the world with big ideas and an unconventional attitude.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,3,20,0,0,0))){
    traits = 'Their kindness and creative spirit make their relationships passionate and dreamy, resulting in deep, spiritual connections.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,04,20,0,0,0))){
    traits = 'Their great ideas, creative mind, and natural drive form the skill set of an incredible leader, which they have the potential to be.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,05,20,0,0,0))){
    traits = 'An ambitious person who works to achieve his/her goals, even when it’s hard.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,06,21,0,0,0))){
    traits = 'They are social butterflies and can make friends with literally anyone due to their bubbly personality and attractive intelligence.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,07,22,0,0,0))){
    traits = 'Their loving nature is one of their greatest assets, and their ability to take care of people is second to none.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,08,22,0,0,0))){
    traits = 'A natural leader and can make some strong friendships.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,09,22,0,0,0))){
    traits = 'A diligent, considerate, and practical person who works your ass off and makes sure your loved ones are happy.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,10,23,0,0,0))){
    traits = 'Have the ability to resolve conflicts just by turning on the charm, making them a perfect asset to friend groups and in social gatherings.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,11,22,0,0,0))){
    traits = 'Their intensity and depth in relationships help them build an everlasting trust with the people.';
  }else if(currentTime.isBefore(DateTime.utc(dtYear,12,22,0,0,0))){
    traits = 'They work hard and blast themselves out of their comfort zone at every opportunity';
  }else if(currentTime.isAfter(DateTime.utc(dtYear,12,22,0,0,0))){
    traits = 'A fantastic leader and excel at taking initiative in any aspect of life, whether that’s work or close relationships.';
  } else{
    traits = 'A fantastic leader and excel at taking initiative in any aspect of life, whether that’s work or close relationships.';
  }
  return traits;
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

