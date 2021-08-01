import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:yday/models/frames/festival.dart';
import 'package:http/http.dart' as http;

class Festivals with ChangeNotifier {
  List<Festival> _festivals = [];
  List<Festival> _yearFestivals = [];
  List<Festival> _upcomingFestivals = [];

  List<Festival> get yearFestivals => _yearFestivals;

  List<Festival> get upcomingFestivals => _upcomingFestivals;
  final databaseRef = FirebaseDatabase.instance.reference();
  final firestoreInstance = FirebaseFirestore.instance;
  List<Festival> get festivals {
    return [..._festivals];
  }

  Festival findById(String festivalId) {
    return _festivals
        .firstWhere((_festivals) => _festivals.festivalId == festivalId);
  }

  Future<bool> fetchFestival() async {
    DateTime dtnow = DateTime.now();
    String year = DateTime.now().year.toString();
    // final url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/festivals.json');
    // try {
      final festivalRef= await firestoreInstance.collection('festivals').get();
      final List<Festival> _loadedFestival = [];
      final List<Festival> _loadedYearFestival = [];
      final List<Festival> _loadedUpcomingFestival = [];
      // var snapshot = await databaseRef.child('festivals').once();
      var ref = festivalRef.docs;
      if (ref != null) {
        // var str;
         ref.forEach((festival) {
           Map<String,DateTime> loadedDateTime = {};
           Map<String,dynamic> fetchedMap = festival.data()['festivalDate'];
           if(fetchedMap!=null){
            fetchedMap.forEach((key, value) {
              loadedDateTime[key] = DateTime.parse(value);
            });
          }
          Festival fetchedFestival = Festival(
            festivalId: festival.id,
            festivalName: festival.data()['festivalName'],
            festivalDescription: festival.data()['festivalDescription'],
            // festivalDate: festival.data()['festivalDate'] !=null?(festival.data()['festivalDate']as Map<String,dynamic>).map((key, value) =>(value as DateTime.parse(value))):null,//DateTime.parse(festival.data()['festivalDate'])
            festivalDate: loadedDateTime,
            festivalImageUrl:
                (festival.data()['festivalImageUrl'] as List<dynamic> != null
                    ? (festival.data()['festivalImageUrl'] as List<dynamic>)
                        .map((tag) => tag.toString())
                        .toList()
                    : null),
          );
          _loadedFestival.add(fetchedFestival);
          if(fetchedFestival.festivalDate!=null&&fetchedFestival.festivalDate.isNotEmpty){
            _loadedYearFestival.add(fetchedFestival);

            Duration diff = fetchedFestival.festivalDate[year].difference(dtnow);
            if(diff.inDays>0&&diff.inDays<=30){
              _loadedUpcomingFestival.add(fetchedFestival);
            }
          }
        });
         _loadedFestival.sort((a,b)=>a.festivalDate!=null&&b.festivalDate!=null&&a.festivalDate[year]!=null&&b.festivalDate[year]!=null?a.festivalDate[year].compareTo(b.festivalDate[year]):0);
         _loadedUpcomingFestival.sort((a,b)=>a.festivalDate!=null&&b.festivalDate!=null&&a.festivalDate[year]!=null&&b.festivalDate[year]!=null?a.festivalDate[year].compareTo(b.festivalDate[year]):0);
         _loadedYearFestival.sort((a,b)=>a.festivalDate!=null&&b.festivalDate!=null&&a.festivalDate[year]!=null&&b.festivalDate[year]!=null?a.festivalDate[year].compareTo(b.festivalDate[year]):0);

         _festivals = _loadedFestival;
        _upcomingFestivals = _loadedUpcomingFestival;
        _yearFestivals = _loadedYearFestival;

        notifyListeners();
        return true;
      }
    // }
    // catch (error) {
    //   throw error;
    // }
  }

  Future<bool> addFestival(Festival newfestival,Map<String, dynamic> dtMap) async {
    try {
      String festivalKey = '';
    final festivalRef= await firestoreInstance.collection('festivals').add({
        'festivalName': newfestival.festivalName,
        'festivalDate': dtMap,//!=null?newfestival.festivalDate.toIso8601String():null,
        'festivalDescription': newfestival.festivalDescription,
        'festivalImageUrl':newfestival.festivalImageUrl,//newUser.profilePhotoLink,
      }).then((value) =>festivalKey = value.id);

      final newFestival = Festival(
        festivalId: festivalKey,
        festivalDate: newfestival.festivalDate,
        festivalDescription: newfestival.festivalDescription,
        festivalImageUrl: newfestival.festivalImageUrl,
        festivalName: newfestival.festivalName,
      );
      _festivals.add(newFestival);
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }
  Festival findFestivalById(String festivalId){
    return festivals.firstWhere((fest) => fest.festivalId == festivalId);
  }

  Future<bool> addFramesInFestival(Festival
      editFestival,Map<String, dynamic> dtMap) async {
    try {
      Festival fest = findById(editFestival.festivalId);
      if(editFestival.festivalDate==null){
        editFestival.festivalDate = fest.festivalDate;
      }
      if(editFestival.festivalDescription == null){
        editFestival.festivalDescription = fest.festivalDescription;
      }
 
      if(editFestival.festivalImageUrl==null||editFestival.festivalImageUrl.isEmpty){
        final festivalRef= await firestoreInstance.collection('festivals').doc(editFestival.festivalId).update({
          'festivalDate': dtMap,//editFestival.festivalDate.toIso8601String(),
          'festivalDescription': editFestival.festivalDescription,
          // 'festivalImageUrl': FieldValue.arrayUnion(editFestival.festivalImageUrl),//newUser.profilePhotoLink,
        });
      }else{
        final festivalRef= await firestoreInstance.collection('festivals').doc(editFestival.festivalId).update({
          'festivalDate': dtMap,//editFestival.festivalDate,
          'festivalDescription': editFestival.festivalDescription,
          'festivalImageUrl': FieldValue.arrayUnion(editFestival.festivalImageUrl),//newUser.profilePhotoLink,
        });
      }
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }
  Future<void> deleteFrameCategory(
      String festivalId,int festivalIndex) async {
    try {
      // final storageInstance = FirebaseStorage.instanceFor(bucket: "gs://yourday-306218.appspot.com");
 
      final festivalRef= await firestoreInstance.collection('festivals').doc(festivalId).delete();
          // .update({
        // 'festivalImageUrl': FieldValue.arrayRemove(removeRef),//newUser.profilePhotoLink,
      // });
      festivals.removeAt(festivalIndex);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  Future<bool> deleteFrame(
      String festivalId,String photoUrl) async {
    try {
      var removeRef = [];
      removeRef.add(photoUrl);
     // await FirebaseStorage.instance.refFromURL(photoUrl).delete();
      final festivalRef= await firestoreInstance.collection('festivals').doc(festivalId).update({
        'festivalImageUrl': FieldValue.arrayRemove(removeRef),//newUser.profilePhotoLink,
      });
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }
  List<Festival> findByDate(DateTime birthdayDateTime) {
    // fetchBirthday();
    List<Festival> searchedFestival = [];
    _festivals.forEach((element) {
      if(element.festivalDate[birthdayDateTime.year.toString()]!=null){
          if(element.festivalDate[birthdayDateTime.year.toString()].day == birthdayDateTime.day &&
              element.festivalDate[birthdayDateTime.year.toString()].month == birthdayDateTime.month&&
              element.festivalDate[birthdayDateTime.year.toString()].year == birthdayDateTime.year){
              searchedFestival.add(element);
          }
      }
    });
    return searchedFestival;
    // return festivals
    //     .where((element) =>
    // element.festivalDate[birthdayDateTime.year.toString()].day == birthdayDateTime.day &&
    //     element.festivalDate[birthdayDateTime.year.toString()].month == birthdayDateTime.month)
    //     .toList();
  }
}
