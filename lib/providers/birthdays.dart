import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/screens/add_birthday_screen.dart';

class Birthdays with ChangeNotifier {
  List<BirthDay> _birthdayList = [
    BirthDay(
      birthdayId: '1',
      nameofperson: 'Person 1',
      relation: 'Friend',
      notes: 'Party at 6',
      dateofbirth: DateTime.now(),
      interestsofPerson: [
        Interest(id: 1, name: "Music"),
        Interest(id: 2, name: "Painting"),
        Interest(id: 3, name: "Travelling"),

        // Interests(id: 6, name: "Penguin"),
        // Interests(id: 7, name: "Spider"),
        // Interests(id: 8, name: "Snake"),

      ],

      //interests: ['Music','Drawing'],
      categoryofPerson: CategoryofPerson.friend,
    ),
    BirthDay(
      birthdayId: '2',
      nameofperson: 'Person 2',
      relation: 'Cousin',
      notes: 'Lunch in Noida',
      dateofbirth: DateTime.now(),
      //interests: ['Cricket','Drawing'],
      categoryofPerson: CategoryofPerson.family,
    ),
    BirthDay(
      birthdayId: '3',
      nameofperson: 'Person 3',
      relation: 'Boss',
      notes: 'Drinks in the evening',
      dateofbirth: DateTime.now(),
      //interests: ['Music','Reading'],
      categoryofPerson: CategoryofPerson.work,
    ),
  ];

  List<BirthDay> get birthdayList => [..._birthdayList];

  void addBirthday(BirthDay bday){
    final newBday = BirthDay(
      birthdayId: DateTime.now().toString(),
      nameofperson: bday.nameofperson,
      relation: bday.relation,
      notes: bday.notes,
      dateofbirth: bday.dateofbirth,
      yearofbirthProvided: bday.yearofbirthProvided,
      //interests: ['Music','Reading'],
      setAlarmforBirthday: bday.setAlarmforBirthday,
      categoryofPerson: bday.categoryofPerson,
      interestsofPerson: bday.interestsofPerson,
      phoneNumberofPerson: bday.phoneNumberofPerson,
      emailofPerson: bday.emailofPerson,
      imageofPerson: bday.imageofPerson,
      //catergory: CategoryofPerson.work,
    );
    _birthdayList.add(newBday);
    notifyListeners();
  }

  BirthDay findById(String bdayId) {
    return birthdayList.firstWhere((bday) => bday.birthdayId == bdayId);
  }

  List<BirthDay> findByDate(DateTime birthdayDateTime){
    return birthdayList.where((element) => element.dateofbirth.day==birthdayDateTime.day&&element.dateofbirth.month==birthdayDateTime.month).toList();
  }
  void completeEvent(String birthdayid){
    _birthdayList.removeWhere((element) => element.birthdayId==birthdayid);
    notifyListeners();
  }

}