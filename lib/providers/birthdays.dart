import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudtrace/v2.dart';
import 'package:googleapis/dfareporting/v3_4.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {}
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;
  CloudStorageResult({this.imageUrl, this.imageFileName});
}

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
      ],
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

  Future<void> fetchBirthday() async {
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/birthdays.json';
    try {
      final response = await http.get(url);
      final List<BirthDay> _loadedBirthday = [];
      final extractedBirthdays =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedBirthdays == null) {
        return;
      }
      extractedBirthdays.forEach((bdayId, bday) {
        _loadedBirthday.add(BirthDay(
          birthdayId: bdayId,
          nameofperson: bday['nameofperson'],
          relation: bday['relation'],
          notes: bday['notes'],
          dateofbirth: DateTime.parse(bday['birthdaystamp']),
          yearofbirthProvided: bday['yearofbirthProvided'],
          // setAlarmforBirthday: bday['setAlarmforBirthday'],
          categoryofPerson: getCategory(
              bday['categoryofPerson']), //CategoryofPerson.family,//,
          phoneNumberofPerson: bday['phoneNumberofPerson'],
          emailofPerson: bday['emailofPerson'],
          interestsofPerson: bday['interestsofperson'] == null
              ? null
              : (bday['interestsofperson'] as List<dynamic>)
                  .map((interest) =>
                      Interest(id: interest['id'], name: interest['name']))
                  .toList(),
          imageofPerson: null,
        ));
      });
      _birthdayList = _loadedBirthday;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addBirthday(BirthDay bday) async {
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/birthdays.json';
    final timestamp = bday.dateofbirth;
    final alarmstamp = bday.setAlarmforBirthday;
    // CloudStorageService _cloudStorageService;
    // print('done');
    // // CloudStorageResult storageResult = await _cloudStorageService.uploadImage(imageToUpload: bday.imageofPerson, title: 'ABC');
    // final Reference bdayref = firebase_storage.FirebaseStorage.instance.ref().child('Birthday').child('abc.jpg');
    // print('done');
    // await bdayref.putFile(bday.imageofPerson);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'nameofperson': bday.nameofperson,
          'relation': bday.relation,
          'notes': bday.notes,
          'yearofbirthProvided': bday.yearofbirthProvided,
          // 'setAlarmforBirthday': alarmstamp,
          'categoryofPerson': categoryText(bday.categoryofPerson),
          'phoneNumberofPerson': bday.phoneNumberofPerson,
          'emailofPerson': bday.emailofPerson,
          'birthdaystamp': timestamp.toIso8601String(),
          'interestsofperson': bday.interestsofPerson
              .map((intr) => {
                    'id': intr.id,
                    'name': intr.name,
                  })
              .toList(),
        }),
      );
      final newBday = BirthDay(
        birthdayId: json.decode(response.body)['name'],
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
      //     print('donr');
      // String fileName =
      //    json.decode(response.body)['name'];
      // final firebaseStorageRef =
      // FirebaseStorage.instance.ref().child('uploads/$fileName');
      // final uploadTask = firebaseStorageRef.putFile(bday.imageofPerson);
      // final taskSnapshot = await uploadTask.whenComplete;
      // taskSnapshot.ref.getDownloadURL().then(
      //       (value) => print("Done: $value"),
      // );
      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      //
      // Reference reference =
      // FirebaseStorage.instance.ref().child('Birthday').child(fileName);
      //
      // TaskSnapshot storageTaskSnapshot =await reference.putFile(bday.imageofPerson);
      //
      // print(storageTaskSnapshot.ref.getDownloadURL());
      //
      // var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

      _birthdayList.add(newBday);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  BirthDay findById(String bdayId) {
    return birthdayList.firstWhere((bday) => bday.birthdayId == bdayId);
  }

  List<BirthDay> findByDate(DateTime birthdayDateTime) {
    return birthdayList
        .where((element) =>
            element.dateofbirth.day == birthdayDateTime.day &&
            element.dateofbirth.month == birthdayDateTime.month)
        .toList();
  }

  void completeEvent(String birthdayid) {
    final url =
        'https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$birthdayid.json';
    final existingBdayIndex =
        _birthdayList.indexWhere((element) => element.birthdayId == birthdayid);
    var existingBday = _birthdayList[existingBdayIndex];
    _birthdayList.removeAt(existingBdayIndex);
    notifyListeners();
    http.delete(url).then((value) => {existingBday = null}).catchError((error) {
      _birthdayList.insert(existingBdayIndex, existingBday);
      notifyListeners();
    });
  }
}
