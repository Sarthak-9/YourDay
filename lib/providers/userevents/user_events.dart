
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class UserEvents with ChangeNotifier {
  List<UserEvent> _userEventList=[];

  List<UserEvent> get userEventList => [..._userEventList];

  Future<bool> addUserEvent(UserEvent userEvent) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false;
    }
    String _userID = _auth.currentUser.uid;
    userEvent.memberEmails.add(_auth.currentUser.email);
    try {
      final eventdatabaseRef = FirebaseDatabase.instance.reference().child('userevents').child(_userID); //database reference object
      final eventdatabasePush = eventdatabaseRef.push();
      eventdatabasePush.set({
        'userEventName': userEvent.userEventName,
        'authorName': userEvent.authorName,
        'authorId': _userID,
        'memberEmails':userEvent.memberEmails,
        'userEventNotes': userEvent.userEventNotes,
        'userDateOfEvent': userEvent.userDateOfEvent.toIso8601String(),
        'folderId': userEvent.folderId,
      });

      final newEvent = UserEvent(
        userEventId: eventdatabasePush.key,
        userEventName: userEvent.userEventName,
        userDateOfEvent: userEvent.userDateOfEvent,
        userEventNotes: userEvent.userEventNotes,
        folderId: userEvent.folderId,
      );
      _userEventList.add(newEvent);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> fetchUserEvent() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false ;
    }
    var _userID = _auth.currentUser.uid;
    final emailDataRef = FirebaseDatabase.instance
        .reference()
        .child('userevents')
        .child(_userID);
    final ref =await emailDataRef.once();
    if(ref == null){
      return true;
    }
    // final url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/userevents/$_userID.json');
    try{
      // final response = await http.get(url);
      final List<UserEvent> _loadedUserEvents = [];
      final extractedUserEvent =await ref.value;
      // json.decode(response.body) as Map<String, dynamic>;
      if (extractedUserEvent == null) {
        return true;
      }
      extractedUserEvent.forEach((userEventId, userEvent) {
        _loadedUserEvents.add(
        UserEvent(
          folderId: userEvent['folderId'],
          userEventName: userEvent['userEventName'],
          authorName: userEvent['authorName'],
          authorId:userEvent['authorId'],
          userEventNotes: userEvent['userEventNotes'],
          userDateOfEvent: DateTime.parse(userEvent['userDateOfEvent']),
          userEventId: userEventId,
        )
        );
      });
      _loadedUserEvents.sort((a,b)=>a.userDateOfEvent.compareTo(b.userDateOfEvent));
      _userEventList = _loadedUserEvents;
      notifyListeners();
      return true;
    }catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<String>> fetchMembersList(String friendId,String eventId)async{

    final emailDataRef =await FirebaseDatabase.instance
        .reference()
        .child('userevents')
        .child(friendId).child(eventId).once();
    final List<String> membersList =emailDataRef.value["memberEmails"]!=null? (emailDataRef.value["memberEmails"] as List<dynamic>).map((email)=>
      email.toString())
        .toList():null;
    return membersList;
  }

  Future<List<String>> addMembersList(String friendId,String eventId,List<String> memberEmails)async{
    final emailDataRef = await FirebaseDatabase.instance
        .reference()
        .child('userevents')
        .child(friendId).child(eventId).once();
    final membersList =await emailDataRef.value["memberEmails"];
    return membersList;
  }

  Future<String> checkExistingDriveUser(String userEmail)async{
    String splitEmail = userEmail.replaceAll( RegExp('@gmail.com'),'' );
    final emailDataRef = FirebaseDatabase.instance
        .reference()
        .child('useremaildata')
        .child(splitEmail);
    // print(splitEmail);
    String friendId,userDriveId;
    var ref = await emailDataRef.once();
    if(ref!=null){
      // await ref.value.forEach((key,values){
      final dataValue =await ref.value;
      if(dataValue!=null){
        friendId = dataValue['userId'];
        userDriveId = dataValue['userRootDriveId'];
        // print(friendId);
      }
      // });
    }
    if(friendId==null||userDriveId==null){
      return null;
    }
    else{
      return friendId;
    }
  }

  Future<void> addFriendToDrive(UserEvent userEvent,String friendId)async{

    if(friendId!=null){
      // userEvent.
      final eventdatabaseRef = FirebaseDatabase.instance.reference().child('userevents').child(friendId).child(userEvent.userEventId); //database reference object
      // final eventdatabasePush = eventdatabaseRef.push();
      eventdatabaseRef.set({
        'userEventName': userEvent.userEventName,
        'userEventNotes': userEvent.userEventNotes,
        'authorName': userEvent.authorName,
        'userDateOfEvent': userEvent.userDateOfEvent.toIso8601String(),
        'folderId': userEvent.folderId,
        'eventId':userEvent.userEventId,
        'authorId':userEvent.authorId
      });
      final authordatabaseRef = FirebaseDatabase.instance.reference().child('userevents').child(userEvent.authorId).child(userEvent.userEventId);
      await authordatabaseRef.update({
        "memberEmails": userEvent.memberEmails
      });//database reference object

    }
  }

  Future<void> deleteEvent(int eventIndex,String eventId)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    String _userID = _auth.currentUser.uid;
    if(_userEventList[eventIndex].authorId == _userID){
      await Future.forEach(_userEventList[eventIndex].memberEmails, (member)async {
        String friendId = await checkExistingDriveUser(member);
        await FirebaseDatabase.instance.reference().child('userevents').child(friendId).child(eventId).remove(); //database reference object
      });
    }
    await FirebaseDatabase.instance.reference().child('userevents').child(_userID).child(eventId).remove(); //database reference object
    _userEventList.removeAt(eventIndex);
    // await fetchUserEvent();
  }
}