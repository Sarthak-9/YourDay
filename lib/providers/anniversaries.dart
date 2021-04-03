import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/anniversary.dart';
import 'package:http/http.dart' as http;
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';

import '../models/anniversary.dart';

class Anniversaries with ChangeNotifier {
  List<Anniversary> _anniversaryList = [];

  List<Anniversary> get anniversaryList => _anniversaryList;

  Future<bool> fetchAnniversary() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false;
    }
    var _userID = _auth.currentUser.uid;

    final url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$_userID.json');
    try {
      final response = await http.get(url);
      final List<Anniversary> _loadedAnniversaries = [];
      final extractedAnniversaries =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedAnniversaries == null) {
        _anniversaryList = _loadedAnniversaries;
        return true;
      }
      extractedAnniversaries.forEach((annivId, anniv) {
        var dt = anniv['setAlarmforBirthday'] == null? null :DateTime.parse(anniv['setAlarmforBirthday']);
        _loadedAnniversaries.add(Anniversary(
          anniversaryId: annivId,
          husband_name: anniv['husband_name'],
          wife_name: anniv['wife_name'],
          relation: anniv['relation'],
          notes: anniv['notes'],
          yearofmarriageProvided: anniv['yearofmarriageProvided'],
          dateofanniversary: DateTime.parse(anniv['dateofanniversary']),
          setAlarmforAnniversary: dt==null?null:TimeOfDay(hour:dt.hour,minute :dt.minute),
          categoryofCouple: getCategory(anniv['categoryofCouple']),
          interestsofCouple: anniv['interestsofCouple'] == null
              ? null
              : (anniv['interestsofCouple'] as List<dynamic>)
                  .map((interest) =>
                      Interest(id: interest['id'], name: interest['name']))
                  .toList(),
          phoneNumberofCouple: anniv['phoneNumberofCouple'],
          emailofCouple: anniv['emailofCouple'],
          imageUrl: anniv['imageUrl'],
        ));
      });
      _anniversaryList = _loadedAnniversaries;
      _anniversaryList.sort((a,b)=>a.dateofanniversary.compareTo(b.dateofanniversary));
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> addAnniversary(Anniversary anniv) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth == null||_auth.currentUser==null){
      return false;
    }
    var _userID = _auth.currentUser.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    var photoUrl;
    Reference ref = storage.ref().child('anniversaries').child(DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(anniv.imageofCouple);
    await uploadTask.whenComplete(() async {
      photoUrl = await ref.getDownloadURL();
    }).catchError((onError) {
      throw onError;
    });
    final url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$_userID.json');
    final alarmstamp = anniv.setAlarmforAnniversary==null? null:DateTimeField.combine(anniv.dateofanniversary, anniv.setAlarmforAnniversary);
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
          'setAlarmforBirthday': alarmstamp == null? null:alarmstamp.toIso8601String(),
          // 'setAlarmforAnniversary': anniv.setAlarmforAnniversary,
          'categoryofCouple': categoryText(anniv.categoryofCouple),
          'phoneNumberofCouple': anniv.phoneNumberofCouple,
          'emailofCouple': anniv.emailofCouple,
          'interestsofCouple': anniv.interestsofCouple.map((intr) =>
          {
            'id': intr.id,
            'name': intr.name,
          }).toList(),
          'imageUrl' : photoUrl,
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
              imageUrl: photoUrl,
            );
            _anniversaryList.add(newAnniv);
            notifyListeners();
            return true;
    } catch (error) {
      throw error;
    }
  }

  Anniversary findById(String annivId) {
    return _anniversaryList
        .firstWhere((element) => element.anniversaryId == annivId);
  }

  List<Anniversary> findByDate(DateTime birthdayDateTime) {
    // fetchAnniversary();
    return _anniversaryList
        .where((element) =>
            element.dateofanniversary.day == birthdayDateTime.day &&
            element.dateofanniversary.month == birthdayDateTime.month)
        .toList();
  }

  void completeEvent(String anniversaryid) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return ;
    }
    try{
      var _userID = _auth.currentUser.uid;
      final url = Uri.parse(
          'https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$_userID/$anniversaryid.json');
      final existingBdayIndex = _anniversaryList
          .indexWhere((element) => element.anniversaryId == anniversaryid);
      var existingBday = _anniversaryList[existingBdayIndex];
      // print(_anniversaryList[existingBdayIndex].imageUrl);
      // if (_anniversaryList[existingBdayIndex].imageUrl != null) {
      //   Reference storageReference = FirebaseStorage.instance
      //       .refFromURL(_anniversaryList[existingBdayIndex].imageUrl);
      //
      //   await storageReference.delete();
      // }
      _anniversaryList.removeAt(existingBdayIndex);
      notifyListeners();
      http
          .delete(url)
          .then((value) => {existingBday = null})
          .catchError((error) {
        _anniversaryList.insert(existingBdayIndex, existingBday);
        notifyListeners();
      });
    }catch(error){
      throw error;
    }
  }
}
