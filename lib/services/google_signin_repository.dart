import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GoogleAccountRepository with ChangeNotifier{
  final storage = new FlutterSecureStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive','https://www.googleapis.com/auth/calendar']);//'https://www.googleapis.com/auth/drive.appdata',
  final GoogleSignIn googleSignInDrive =
  GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);//'https://www.googleapis.com/auth/drive.appdata',

  GoogleSignInAccount googleSignInAccount;
  AuthCredential credential;
  UserCredential authResult;
  // GoogleDriveRepository googleDriveRepository;
  User user;
  // ga.FileList list;
  bool signedIn = false;

  Future<void> loginWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount googleSignInAccount) async {
      if (googleSignInAccount != null) {
        afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignIn.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storage.write(key: "signedIn", value: "false").then((value) {
          // setState(() {
            signedIn = false;
          // });
        });
      }
    } else {
      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();
      afterGoogleLogin(googleSignInAccount);
    }
    // googleDriveRepository = GoogleDriveRepository(googleSignInAccount);
  }

  Future<void> loginDriveWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
    googleSignInDrive.onCurrentUserChanged
        .listen((GoogleSignInAccount googleSignInAccount) async {
      if (googleSignInAccount != null) {
        afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignInDrive.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storage.write(key: "signedIn", value: "false").then((value) {
          // setState(() {
          signedIn = false;
          // });
        });
      }
    } else {
      final GoogleSignInAccount googleSignInAccount =
      await googleSignInDrive.signIn();
      afterGoogleLogin(googleSignInAccount);
    }
    // googleDriveRepository = GoogleDriveRepository(googleSignInAccount);
  }

  Future<void> afterGoogleLogin(GoogleSignInAccount gSA) async {
    googleSignInAccount = gSA;
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

     credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    authResult = await auth.signInWithCredential(credential);
    user = authResult.user;

  }
  Future<void> googleLogout() async {
    await googleSignIn.signOut();
}}
