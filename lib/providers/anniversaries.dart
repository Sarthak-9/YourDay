import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/services/message_handler.dart';

import '../models/anniversaries/anniversary.dart';

class Anniversaries with ChangeNotifier {
  List<Anniversary> _anniversaryList = [];
  List<Anniversary> _upcomingAnniversaryList = [];

  List<Anniversary> get upcomingAnniversaryList => _upcomingAnniversaryList;

  List<Anniversary> get anniversaryList => _anniversaryList;

  Future<bool> addAnniversary(Anniversary anniv) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return false;
    }
    var _userID = _auth.currentUser.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    var photoUrl;
    if (anniv.imageofCouple != null) {
      Reference ref = storage
          .ref()
          .child('anniversaries')
          .child(_userID + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(anniv.imageofCouple);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }

    try {
      final dtNow = DateTime.now();
      String str = DateFormat('ddMMhhmm')
          .format(dtNow);
      int dtInt= int.parse(str);
      String annivWish = 'Happy Anniversary '+anniv.husband_name+' & '+anniv.wife_name;
      // final alarmstamp = anniv.setAlarmforAnniversary==null? null:DateTimeField.combine(anniv.dateofanniversary, anniv.setAlarmforAnniversary);

      // final alarmstamp = anniv.setAlarmforAnniversary == null
      //     ? null
      //     : DateTimeField.combine(
      //         anniv.dateofanniversary, anniv.setAlarmforAnniversary);
      final anninvdatabaseRef = FirebaseDatabase.instance
          .reference()
          .child('anniversaries')
          .child(_userID); //database reference object
      final annivdatabasePush = anninvdatabaseRef.push();
      await annivdatabasePush.set({
        'calenderId': anniv.calenderId,
        'husband_name': anniv.husband_name,
        'wife_name': anniv.wife_name,
        'notifId': dtInt,
        'notes': anniv.notes,
        'dateofanniversary': anniv.dateofanniversary.toIso8601String(),
        'yearofmarriageProvided': anniv.yearofmarriageProvided,
        // 'setAlarmforAnniversary':
        //     alarmstamp == null ? null : alarmstamp.toIso8601String(),
        'categoryofCouple': categoryText(anniv.categoryofCouple),
        'phoneNumberofCouple': anniv.phoneNumberofCouple,
        'emailofCouple': anniv.emailofCouple,
        'interestsofCouple': anniv.interestsofCouple
            .map((intr) => {
                  'id': intr.id,
                  'name': intr.name,
                })
            .toList(),
        'imageUrl': photoUrl,
      });

      final newAnniv = Anniversary(
        anniversaryId: annivdatabasePush.key,
        calenderId: anniv.calenderId,
        husband_name: anniv.husband_name,
        wife_name: anniv.wife_name,
        notifId: dtInt,
        notes: anniv.notes,
        dateofanniversary: anniv.dateofanniversary,
        yearofmarriageProvided: anniv.yearofmarriageProvided,
        // setAlarmforAnniversary: anniv.setAlarmforAnniversary,
        interestsofCouple: anniv.interestsofCouple,
        categoryofCouple: anniv.categoryofCouple,
        phoneNumberofCouple: anniv.phoneNumberofCouple,
        emailofCouple: anniv.emailofCouple,
        imageofCouple: anniv.imageofCouple,
        imageUrl: photoUrl,
      );
      String payLoad = 'anniversary'+annivdatabasePush.key;
      _anniversaryList.add(newAnniv);
      await NotificationsHelper.setNotification(
          currentTime: anniv.dateofanniversary ,id:dtInt,title:annivWish,body:'Wish Happy Anniversary',payLoad: payLoad).then((value) => print(anniv.dateofanniversary));
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> editAnniversary(Anniversary anniv) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return false;
    }

    String _userID = _auth.currentUser.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    String photoUrl = anniv.imageUrl;
    if (anniv.imageofCouple != null) {
      Reference ref = storage
          .ref()
          .child('anniversaries')
          .child(_userID + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(anniv.imageofCouple);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }

    // Anniversary editAnniv = findById(anniv.anniversaryId);
    // editAnniv.notes = anniv.notes;
    // editAnniv.phoneNumberofCouple = anniv.phoneNumberofCouple;
    // editAnniv.emailofCouple = anniv.emailofCouple;

    try {
      // final alarmstamp = anniv.setAlarmforAnniversary == null
      //     ? null
      //     : DateTimeField.combine(
      //         anniv.dateofanniversary, anniv.setAlarmforAnniversary);
      final anninvdatabaseRef = FirebaseDatabase.instance
          .reference()
          .child('anniversaries')
          .child(_userID).child(anniv.anniversaryId); //database reference object
      if(anniv.interestsofCouple==null||anniv.interestsofCouple.isEmpty){
        await anninvdatabaseRef.update({
          // 'calenderId': anniv.calenderId,
          'notes': anniv.notes,
          'dateofanniversary': anniv.dateofanniversary.toIso8601String(),
          // 'setAlarmforAnniversary':
          // alarmstamp == null ? null : alarmstamp.toIso8601String(),
          'phoneNumberofCouple': anniv.phoneNumberofCouple,
          'emailofCouple': anniv.emailofCouple,
          'imageUrl': photoUrl,
        });
      }else{
        await anninvdatabaseRef.update({
          // 'calenderId': anniv.calenderId,
          'notes': anniv.notes,
          // 'setAlarmforAnniversary':
          // alarmstamp == null ? null : alarmstamp.toIso8601String(),
          'phoneNumberofCouple': anniv.phoneNumberofCouple,
          'emailofCouple': anniv.emailofCouple,
          'interestsofCouple': anniv.interestsofCouple
              .map((intr) => {
            'id': intr.id,
            'name': intr.name,
          })
              .toList(),
          'imageUrl': photoUrl,
        });
      }

      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> fetchAnniversary() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return false;
    }
    var _userID = _auth.currentUser.uid;
    DateTime dtnow = DateTime.now();

    // final url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$_userID.json');
    // try {
      // final response = await http.get(url);
      final List<Anniversary> _loadedAnniversaries = [];
    final List<Anniversary> _loadedUpcomingAnniversaries = [];
    final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('anniversaries')
          .child(_userID);
      final extractedAnniversaries = await databaseRef.once();
      // json.decode(response.body) as Map<String, dynamic>;
      if (extractedAnniversaries == null ||
          extractedAnniversaries.value == null) {
        _anniversaryList = _loadedAnniversaries;
        return true;
      }
      extractedAnniversaries.value.forEach((annivId, anniv) {
        // var dt = anniv['setAlarmforAnniversary'] == null
        //     ? null
        //     : DateTime.parse(anniv['setAlarmforAnniversary']);
        Anniversary fetchedAnniversary = Anniversary(
          anniversaryId: annivId,
          calenderId: anniv['calenderId'],
          husband_name: anniv['husband_name'],
          wife_name: anniv['wife_name'],
          notifId: anniv['notifId']!=null?anniv['notifId']:null,
          notes: anniv['notes'],
          yearofmarriageProvided: anniv['yearofmarriageProvided'],
          dateofanniversary: DateTime.parse(anniv['dateofanniversary']),
          // setAlarmforAnniversary:
          // dt == null ? null : TimeOfDay(hour: dt.hour, minute: dt.minute),
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
        );
        _loadedAnniversaries.add(fetchedAnniversary);
        Duration diff = fetchedAnniversary.dateofanniversary.difference(dtnow);
        if(diff.inDays>0&&diff.inDays<=30){
          _loadedUpcomingAnniversaries.add(fetchedAnniversary);
        }
      });
      _anniversaryList = _loadedAnniversaries;
      _anniversaryList
          .sort((a, b) => a.dateofanniversary.compareTo(b.dateofanniversary));
      _loadedUpcomingAnniversaries.sort((a, b) => a.dateofanniversary.compareTo(b.dateofanniversary));
      _upcomingAnniversaryList = _loadedUpcomingAnniversaries;
    notifyListeners();
      return true;
    // } catch (error) {
    //   print(error);
    //   throw error;
    // }
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
    if (_auth == null || _auth.currentUser == null) {
      return;
    }
    try {
      var _userID = _auth.currentUser.uid;

      // final url = Uri.parse(
      //     'https://yourday-306218-default-rtdb.firebaseio.com/anniversaries/$_userID/$anniversaryid.json');
      final existingBdayIndex = _anniversaryList
          .indexWhere((element) => element.anniversaryId == anniversaryid);
      _anniversaryList.removeAt(existingBdayIndex);
      final anninvdatabaseRef = FirebaseDatabase.instance
          .reference()
          .child('anniversaries')
          .child(_userID); //database reference object
      await anninvdatabaseRef.child(anniversaryid).remove();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
