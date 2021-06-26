import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yday/services/message_handler.dart';

class UserDataModel with ChangeNotifier {
  final String userFId;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userGender;
  final DateTime dateofBirth;
  String userRootDriveId;
  final int userRole;
  final String profilePhotoLink;

  UserDataModel(
      {this.userFId,
      @required this.userEmail,
      @required this.userPhone,
      @required this.userName,
        @required this.userGender,
        @required this.dateofBirth,
      @required this.userRootDriveId,
        this.userRole,
      this.profilePhotoLink});
}

class UserData with ChangeNotifier {
  UserDataModel _userData;

  UserDataModel get userData => _userData;

  Future<void> addUser(UserDataModel newUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String _userID = _auth.currentUser.uid;
    try {
      String fid;
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('user')
          .child(_userID);
      // final pushRef = databaseRef.push();
      // await pushRef.set({

      await databaseRef.set({
        'userEmail': newUser.userEmail,
        'userName': newUser.userName,
        'userGender': newUser.userGender,
        'userPhone': newUser.userPhone,
        'userDOB': newUser.dateofBirth != null
            ? newUser.dateofBirth.toIso8601String()
            : null,
        'userRootDriveId': newUser.userRootDriveId,
        'userRole': 4,
        'profilePhotoLink': newUser.profilePhotoLink
      });
      String str = DateFormat('ddyyhhmm')
          .format(newUser.dateofBirth);
      int dtInt= int.parse(str);
      String bdayWish = 'Happy Birthday '+newUser.userName;
      await NotificationsHelper.setNotification(newUser.dateofBirth ,dtInt,bdayWish,'Wish Happy Birthday').then((value) => print(newUser.dateofBirth));

      String userEmail = _auth.currentUser.email;
      String splitEmail = userEmail.replaceAll( RegExp('@gmail.com'),'' );
      // print(userEmail);
      final emailDataRef = FirebaseDatabase.instance
          .reference()
          .child('useremaildata')
          .child(splitEmail);
      await emailDataRef.set({
        'userEmail': userEmail,
        'userId': _userID,
        'userRootDriveId': null,
      });

      final user = UserDataModel(
          userFId: databaseRef.key,
          userEmail: newUser.userEmail,
          userPhone: newUser.userPhone,
          userName: newUser.userName,
          userRole: 4,
          dateofBirth: newUser.dateofBirth,
          userRootDriveId: newUser.userRootDriveId,
          profilePhotoLink: newUser.profilePhotoLink);
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserDataModel updateUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String _userID = _auth.currentUser.uid;
    String userFid = _userData.userFId;
    try {
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('user')
          .child(_userID);
          // .child(userFid); //database reference object
      await databaseRef.update({
        // 'userEmail': updateUser.userEmail,
        // 'userName': updateUser.userName,
        'userPhone': updateUser.userPhone,
        'userDOB': updateUser.dateofBirth != null
            ? updateUser.dateofBirth.toIso8601String()
            : null,
        // 'userRootDriveId': updateUser.userRootDriveId,
        'profilePhotoLink': updateUser.profilePhotoLink
      });

      final user = UserDataModel(
          userFId: userFid,
          userEmail: updateUser.userEmail,
          userPhone: updateUser.userPhone,
          userGender: updateUser.userGender,
          userName: updateUser.userName,
          dateofBirth: updateUser.dateofBirth,
          userRootDriveId: updateUser.userRootDriveId,
          profilePhotoLink: updateUser.profilePhotoLink);
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> fetchUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return false;
    }
    _auth.currentUser.refreshToken;
    String _userID = _auth.currentUser.uid;
    // var url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
    // print(_userID);
    try {
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('user')
          .child(_userID);
      // final response = await http.get(url);
      if (databaseRef == null) {
        return false;
      }
      UserDataModel _loadedUser;
      var extractedUser =await databaseRef.once();// json.decode(response.body) as Map<String, dynamic>;
      // extractedUser.forEach((key, userdata) {
      var data = extractedUser.value;
        _loadedUser = UserDataModel(
          userFId: extractedUser.key,
          userEmail: data['userEmail'],
          userPhone: data['userPhone'],
          userName: data['userName'],
          userGender: data['userGender'],
          userRole: data['userRole']!=null?data['userRole']:4,
          dateofBirth: data['userDOB'] != null
              ? DateTime.parse(data['userDOB'])
              : null,
          userRootDriveId: data['userRootDriveId'],
          profilePhotoLink: data['profilePhotoLink'],
        );
        // print(_loadedUser.userName);
      // });
      _userData = _loadedUser;
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateDrive(String driveId)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(_userID);//.child(userData.userFId);

    await databaseRef.update({
      'userRootDriveId':driveId
    });
    String userEmail = _auth.currentUser.email;
    String splitEmail = userEmail.replaceAll( RegExp('@gmail.com'),'' );

    final emailDataRef = FirebaseDatabase.instance
        .reference()
        .child('useremaildata')
        .child(splitEmail);
    final ref =await emailDataRef.once();
    if(ref!=null){
      await emailDataRef.update({
        'userRootDriveId': driveId,
      });
    }
    _userData.userRootDriveId = driveId;
    notifyListeners();
  }
  }

