import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yday/services/message_handler.dart';

class Birthdays with ChangeNotifier {
  List<BirthDay> _birthdayList = [];
  List<BirthDay> _upcomingBirthdayList = [];

  List<BirthDay> get upcomingBirthdayList => _upcomingBirthdayList;

  List<BirthDay> get birthdayList => [..._birthdayList];

  Future<bool> fetchBirthday() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth == null||_auth.currentUser==null ){
      return false;
    }
    _auth.currentUser.refreshToken;
    var _userID = _auth.currentUser.uid;
    DateTime dtnow = DateTime.now();
    // var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID.json');
    try {
      // final response = await http.get(url);
      final List<BirthDay> _loadedBirthday = [];
      final List<BirthDay> _loadedUpcomingBirthday = [];
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('birthdays')
          .child(_userID);
      final extractedBirthdays = await databaseRef.once();
      //     json.decode(response.body) as Map<String, dynamic>;
      if (extractedBirthdays == null||extractedBirthdays.value==null) {
        _birthdayList = _loadedBirthday;
        return true;
      }
      extractedBirthdays.value.forEach((bdayId, bday) {
       // var dt = bday['setAlarmforBirthday'] == null? null :DateTime.parse(bday['setAlarmforBirthday']);
       BirthDay fetchedBirthday = BirthDay(
         birthdayId: bdayId,
         calenderId: bday['calenderId'],
         nameofperson: bday['nameofperson'],
         gender: bday['gender']??'',
         notes: bday['notes'],
         zodiacSign: bday['zodiacSign']??'',
         dateofbirth: DateTime.parse(bday['birthdaystamp']),
         yearofbirthProvided: bday['yearofbirthProvided'],
         // setAlarmforBirthday: dt==null?null:TimeOfDay(hour:dt.hour,minute :dt.minute),
         categoryofPerson: getCategory(
             bday['categoryofPerson']), //CategoryofPerson.family,//,
         phoneNumberofPerson: bday['phoneNumberofPerson'],
         emailofPerson: bday['emailofPerson'],
         notifId: bday['notifId']!=null?bday['notifId']:null,
         interestsofPerson: bday['interestsofperson'] == null
             ? null
             : (bday['interestsofperson'] as List<dynamic>)
             .map((interest) =>
             Interest(id: interest['id'], name: interest['name']))
             .toList(),
         imageUrl: bday['imageUrl']  ,
       ) ;
       _loadedBirthday.add(fetchedBirthday);
       Duration diff = fetchedBirthday.dateofbirth
           .difference(dtnow);
       if(diff.inDays>0&&diff.inDays<=30){
         _loadedUpcomingBirthday.add(fetchedBirthday);
       }
      });
      _birthdayList = _loadedBirthday;
      _birthdayList.sort((a,b)=>a.dateofbirth.compareTo(b.dateofbirth));
      _loadedUpcomingBirthday.sort((a,b)=>a.dateofbirth.compareTo(b.dateofbirth));
      _upcomingBirthdayList = _loadedUpcomingBirthday;
      // print(_upcomingBirthdayList);
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
          storage.ref().child('birthdays').child(DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(bday.imageofPerson);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }
    // String zodiac = '';
    // switch (bday.dateofbirth){
    //   case bday.dateofbirth.isAfter(other)
    // }
    // var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID.json');

    // final alarmstamp = bday.setAlarmforBirthday==null? null:DateTimeField.combine(bday.dateofbirth, bday.setAlarmforBirthday);
    try {
      int dtSecond = DateTime.now().second;
      String str = DateFormat('ddyyhhmm')
          .format(bday.dateofbirth);
      int dtInt= int.parse(str)+dtSecond;
      // print(dtInt);
      String bdayWish = 'Happy Birthday '+bday.nameofperson;
      final bdaydatabaseRef = FirebaseDatabase.instance.reference().child('birthdays').child(_userID); //database reference object
      final bdaydatabasePush = bdaydatabaseRef.push();
      await bdaydatabasePush.set({
        'calenderId': bday.calenderId,
        'nameofperson': bday.nameofperson,
        'gender': bday.gender,
        'notes': bday.notes,
        'zodiacSign': zodiacSign(bday.dateofbirth),
        'yearofbirthProvided': bday.yearofbirthProvided,
        // 'setAlarmforBirthday': alarmstamp == null? null:alarmstamp.toIso8601String(),
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
        'notifId': dtInt
      });
      // DateTime dt = DateTime(dtnow.year,dtnow.month,dtnow.day,dtnow.hour,dtnow.minute+1,dtnow.second);
      // await NotificationsHelper.setNotification(dt ,dt.minute).then((value) => print(dt));
      final newBday = BirthDay(
        birthdayId: bdaydatabasePush.key,
        calenderId: bday.calenderId,
        nameofperson: bday.nameofperson,
        gender: bday.gender,
        notes: bday.notes,
        dateofbirth: bday.dateofbirth,
        yearofbirthProvided: bday.yearofbirthProvided,
        //interests: ['Music','Reading'],
        // setAlarmforBirthday: bday.setAlarmforBirthday,
        categoryofPerson: bday.categoryofPerson,
        interestsofPerson: bday.interestsofPerson,
        phoneNumberofPerson: bday.phoneNumberofPerson,
        emailofPerson: bday.emailofPerson,
        imageofPerson: bday.imageofPerson,
       imageUrl: photoUrl,
        notifId: dtInt,
        //catergory: CategoryofPerson.work,
      );
      _birthdayList.add(newBday);

      String payLoad = 'birthday'+bdaydatabasePush.key;
      await NotificationsHelper.setNotification(currentTime:bday.dateofbirth ,id:dtInt,title:bdayWish,body:'Wish Happy Birthday',payLoad: payLoad);
      // _birthdayList.sort((a,b)=>a.dateofbirth.compareTo(b.dateofbirth));
      notifyListeners();
      // return url;
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }
  Future<void> editBirthday(BirthDay bday) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false ;
    }
    String photoUrl = bday.imageUrl;
    var _userID = _auth.currentUser.uid;
    if(bday.imageofPerson!=null){
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
      storage.ref().child('birthdays').child(DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(bday.imageofPerson);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }

    // final alarmstamp = bday.setAlarmforBirthday==null? null:DateTimeField.combine(bday.dateofbirth, bday.setAlarmforBirthday);
    try {
      final bdaydatabaseRef = FirebaseDatabase.instance.reference().child('birthdays').child(_userID).child(bday.birthdayId); //database reference object
      if(bday.interestsofPerson==null||bday.interestsofPerson.isEmpty){
      await bdaydatabaseRef.update({
        // 'calenderId': bday.calenderId,
        // 'nameofperson': bday.nameofperson,
        // 'relation': bday.relation,
        'notes': bday.notes,
        'birthdaystamp': bday.dateofbirth.toIso8601String(),
        // 'yearofbirthProvided': bday.yearofbirthProvided,
        // 'setAlarmforBirthday': alarmstamp == null? null:alarmstamp.toIso8601String(),
        // 'categoryofPerson': categoryText(bday.categoryofPerson),
        'phoneNumberofPerson': bday.phoneNumberofPerson,
        'emailofPerson': bday.emailofPerson,
        // 'birthdaystamp': bday.dateofbirth.toIso8601String(),

        'imageUrl' : photoUrl,
      });}else{
        await bdaydatabaseRef.update({
          // 'calenderId': bday.calenderId,
          // 'nameofperson': bday.nameofperson,
          // 'relation': bday.relation,
          'notes': bday.notes,
          // 'yearofbirthProvided': bday.yearofbirthProvided,
          // 'setAlarmforBirthday': alarmstamp == null? null:alarmstamp.toIso8601String(),
          // 'categoryofPerson': categoryText(bday.categoryofPerson),
          'phoneNumberofPerson': bday.phoneNumberofPerson,
          'emailofPerson': bday.emailofPerson,
          'interestsofperson': bday.interestsofPerson
              .map((intr) => {
            'id': intr.id,
            'name': intr.name,
          })
              .toList(),
          'imageUrl' : photoUrl,
        });
      }

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
    // final url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/birthdays/$_userID/$birthdayid.json');
    final existingBdayIndex =
        _birthdayList.indexWhere((element) => element.birthdayId == birthdayid);
    // var existingBday = _birthdayList[existingBdayIndex];
    _birthdayList.removeAt(existingBdayIndex);
    final bdaydatabaseRef = FirebaseDatabase.instance.reference().child('birthdays').child(_userID); //database reference object
    await bdaydatabaseRef.child(birthdayid).remove();
    // if(_birthdayList[existingBdayIndex].imageUrl != null){
    //   Reference storageReference = FirebaseStorage.instance
    //       .refFromURL(_birthdayList[existingBdayIndex].imageUrl);
    //   await storageReference.delete();
    // }
    notifyListeners();
    // http.delete(url).then((value) => {existing
    // Bday = null}).catchError((error) {
    //   _birthdayList.insert(existingBdayIndex, existingBday);
    //   notifyListeners();
    // });
  }
}
