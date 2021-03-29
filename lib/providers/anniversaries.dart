import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yday/models/anniversary.dart';
import 'package:http/http.dart' as http;
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';

import '../models/anniversary.dart';

class Anniversaries with ChangeNotifier {
  List<Anniversary> _anniversaryList = [];

  List<Anniversary> get anniversaryList => _anniversaryList;

  Future<void> fetchAnniversary() async {
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/anniversaries.json';
    try {
      final response = await http.get(url);
      final List<Anniversary> _loadedAnniversaries = [];
      final extractedAnniversaries =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedAnniversaries == null) {
        return;
      }
      extractedAnniversaries.forEach((annivId, anniv) {
        _loadedAnniversaries.add(Anniversary(
          anniversaryId: annivId,
          husband_name: anniv['husband_name'],
          wife_name: anniv['wife_name'],
          relation: anniv['relation'],
          notes: anniv['notes'],
          yearofmarriageProvided: anniv['yearofmarriageProvided'],
          dateofanniversary: DateTime.parse(anniv['dateofanniversary']),
          categoryofCouple: getCategory(anniv['categoryofCouple']),
          interestsofCouple: anniv['interestsofCouple'] == null
              ? null
              : (anniv['interestsofCouple'] as List<dynamic>)
                  .map((interest) =>
                      Interest(id: interest['id'], name: interest['name']))
                  .toList(),
          phoneNumberofCouple: anniv['phoneNumberofCouple'],
          emailofCouple: anniv['emailofCouple'],
        ));
      });
      _anniversaryList = _loadedAnniversaries;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addAnniversary(Anniversary anniv) async {
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/anniversaries.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'husband_name': anniv.husband_name,
          'wife_name': anniv.wife_name,
          'relation': anniv.relation,
          'notes': anniv.notes,
          'dateofanniversary': anniv.dateofanniversary.toIso8601String(),
          'yearofmarriageProvided': anniv.yearofmarriageProvided,
          // 'setAlarmforAnniversary': anniv.setAlarmforAnniversary,

          'categoryofCouple': categoryText(anniv.categoryofCouple),
          'phoneNumberofCouple': anniv.phoneNumberofCouple,
          'emailofCouple': anniv.emailofCouple,
          'interestsofCouple': anniv.interestsofCouple.map((intr) =>
          {
            'id': intr.id,
            'name': intr.name,
          }).toList(),
          // imageofCouple: anniv.imageofCouple,
        }),
      );
      final newAnniv = Anniversary(
              anniversaryId: json.decode(response.body)['name'],
              husband_name: anniv.husband_name,
              wife_name: anniv.wife_name,
              relation: anniv.relation,
              notes: anniv.notes,
              dateofanniversary: anniv.dateofanniversary,
              yearofmarriageProvided: anniv.yearofmarriageProvided,
              setAlarmforAnniversary: anniv.setAlarmforAnniversary,
              interestsofCouple: anniv.interestsofCouple,
              categoryofCouple: anniv.categoryofCouple,
              phoneNumberofCouple: anniv.phoneNumberofCouple,
              emailofCouple: anniv.emailofCouple,
              imageofCouple: anniv.imageofCouple,
            );
            _anniversaryList.add(newAnniv);
            notifyListeners();
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

      // _birthdayList.add(newBday);
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }




  // Future<void> addAnniversary(Anniversary anniv) async {
  //   const url = 'https://yourday-306218-default-rtdb.firebaseio.com/anniversary.json';
  //   final timestamp = anniv.dateofanniversary;
  //   final alarmstamp = anniv.setAlarmforAnniversary;
  //   print('1');
  //   try {
  //     print('2');
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'husband_name': anniv.husband_name,
  //           'wife_name': anniv.wife_name,
  //           'relation': anniv.relation,
  //           'notes': anniv.notes,
  //           // 'dateofanniversary': timestamp.toIso8601String(),
  //           'yearofmarriageProvided': anniv.yearofmarriageProvided,
  //           //'setAlarmforAnniversary': alarmstamp.toString(),
  //           'interestsofCouple': anniv.interestsofCouple
  //               .map((intr) => {
  //                     'id': intr.id,
  //                     'name': intr.name,
  //                   })
  //               .toList(),
  //           'categoryofCouple': categoryText(anniv.categoryofCouple),
  //           'phoneNumberofCouple': anniv.phoneNumberofCouple,
  //           'emailofCouple': anniv.emailofCouple,
  //         }));
  //     print('3');
  //
  //     final newAnniv = Anniversary(
  //       anniversaryId: json.decode(response.body)['name'],
  //       husband_name: anniv.husband_name,
  //       wife_name: anniv.wife_name,
  //       relation: anniv.relation,
  //       notes: anniv.notes,
  //       dateofanniversary: anniv.dateofanniversary,
  //       yearofmarriageProvided: anniv.yearofmarriageProvided,
  //       setAlarmforAnniversary: anniv.setAlarmforAnniversary,
  //       interestsofCouple: anniv.interestsofCouple,
  //       categoryofCouple: anniv.categoryofCouple,
  //       phoneNumberofCouple: anniv.phoneNumberofCouple,
  //       emailofCouple: anniv.emailofCouple,
  //       imageofCouple: anniv.imageofCouple,
  //     );
  //     _anniversaryList.add(newAnniv);
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Anniversary findById(String annivId) {
    return _anniversaryList
        .firstWhere((element) => element.anniversaryId == annivId);
  }

  List<Anniversary> findByDate(DateTime birthdayDateTime) {
    return _anniversaryList
        .where((element) =>
            element.dateofanniversary.day == birthdayDateTime.day &&
            element.dateofanniversary.month == birthdayDateTime.month)
        .toList();
  }

  void completeEvent(String anniversaryid) {
    final url =
        'https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$anniversaryid.json';
    final existingBdayIndex =
    _anniversaryList.indexWhere((element) => element.anniversaryId == anniversaryid);
    var existingBday = _anniversaryList[existingBdayIndex];
    _anniversaryList.removeAt(existingBdayIndex);
    notifyListeners();
    http.delete(url).then((value) => {existingBday = null}).catchError((error) {
      _anniversaryList.insert(existingBdayIndex, existingBday);
      notifyListeners();
    });
  }
}
