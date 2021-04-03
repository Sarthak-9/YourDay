import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/cloudtrace/v2.dart';
import 'package:googleapis/dfareporting/v3_4.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';


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
  List<BirthDay> _birthdayList = [];

  List<BirthDay> get birthdayList => [..._birthdayList];

  Future<bool> fetchBirthday() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth == null||_auth.currentUser==null ){
      return false;
    }
    _auth.currentUser.refreshToken;
    var _userID = _auth.currentUser.uid;
    var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID.json');
    try {
      final response = await http.get(url);
      final List<BirthDay> _loadedBirthday = [];
      final extractedBirthdays =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedBirthdays == null) {
        _birthdayList = _loadedBirthday;
        return true;
      }
      extractedBirthdays.forEach((bdayId, bday) {
       var dt = bday['setAlarmforBirthday'] == null? null :DateTime.parse(bday['setAlarmforBirthday']);
        _loadedBirthday.add(
            BirthDay(
          birthdayId: bdayId,
          nameofperson: bday['nameofperson'],
          relation: bday['relation'],
          notes: bday['notes'],
          dateofbirth: DateTime.parse(bday['birthdaystamp']),
          yearofbirthProvided: bday['yearofbirthProvided'],
          setAlarmforBirthday: dt==null?null:TimeOfDay(hour:dt.hour,minute :dt.minute),
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
              imageUrl: bday['imageUrl']  ,
            ));
      });
      _birthdayList = _loadedBirthday;
      _birthdayList.sort((a,b)=>a.dateofbirth.compareTo(b.dateofbirth));
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> addBirthday(BirthDay bday) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false ;
    }
    var photoUrl;
    var _userID = _auth.currentUser.uid;
    if(bday.imageofPerson!=null){
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('anniversaries').child(DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(bday.imageofPerson);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }
    var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID.json');

    final alarmstamp = bday.setAlarmforBirthday==null? null:DateTimeField.combine(bday.dateofbirth, bday.setAlarmforBirthday);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'nameofperson': bday.nameofperson,
          'relation': bday.relation,
          'notes': bday.notes,
          'yearofbirthProvided': bday.yearofbirthProvided,
          'setAlarmforBirthday': alarmstamp == null? null:alarmstamp.toIso8601String(),
          'categoryofPerson': categoryText(bday.categoryofPerson),
          'phoneNumberofPerson': bday.phoneNumberofPerson,
          'emailofPerson': bday.emailofPerson,
          'birthdaystamp': bday.dateofbirth.toIso8601String(),
          'interestsofperson': bday.interestsofPerson
              .map((intr) => {
                    'id': intr.id,
                    'name': intr.name,
                  })
              .toList(),
          'imageUrl' : photoUrl,
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
       imageUrl: photoUrl,
        //catergory: CategoryofPerson.work,
      );
      _birthdayList.add(newBday);
      // _birthdayList.sort((a,b)=>a.dateofbirth.compareTo(b.dateofbirth));
      notifyListeners();
      // return url;
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  BirthDay findById(String bdayId) {
    return birthdayList.firstWhere((bday) => bday.birthdayId == bdayId);
  }

  List<BirthDay> findByDate(DateTime birthdayDateTime) {
    // fetchBirthday();
    return birthdayList
        .where((element) =>
            element.dateofbirth.day == birthdayDateTime.day &&
            element.dateofbirth.month == birthdayDateTime.month)
        .toList();
  }

  void completeEvent(String birthdayid) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return ;
    }
    var _userID = _auth.currentUser.uid;
    final url = Uri.parse(
        'https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID/$birthdayid.json');
    final existingBdayIndex =
        _birthdayList.indexWhere((element) => element.birthdayId == birthdayid);
    var existingBday = _birthdayList[existingBdayIndex];
    // if(_birthdayList[existingBdayIndex].imageUrl != null){
    //   Reference storageReference = FirebaseStorage.instance
    //       .refFromURL(_birthdayList[existingBdayIndex].imageUrl);
    //   await storageReference.delete();
    // }
    _birthdayList.removeAt(existingBdayIndex);
    notifyListeners();
    http.delete(url).then((value) => {existingBday = null}).catchError((error) {
      _birthdayList.insert(existingBdayIndex, existingBday);
      notifyListeners();
    });
  }
}
