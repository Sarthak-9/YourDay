import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:path/path.dart' as path;
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:yday/models/userevents/google_auth_client.dart';

class ADD extends StatefulWidget {
  @override
  _ADDState createState() => _ADDState();
}

class _ADDState extends State<ADD> {
  final storage = new FlutterSecureStorage();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn =
  GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);

  GoogleSignInAccount googleSignInAccount;

  ga.FileList list;

  var signedIn = false;

  var _yourDayFolder;

  DateTime dateTime;

  var _dateSelected = false;
  var _eventName = '';
  var _eventNotes = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Text('Add photos of your event'),
          TextFormField(
            decoration: InputDecoration(labelText: 'Name of Event'),
          ),

          TextFormField(
            decoration:
            InputDecoration(labelText: 'Notes'),
            textInputAction: TextInputAction.next,
            // focusNode: _husbandnameFocusNode,
            onFieldSubmitted: (_) {
              // FocusScope.of(context)
              //     .requestFocus(_wifenameFocusNode);
            },
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,

            onSaved: (value) {
            },
          ),
          OutlineButton(
            child: Text(
              _dateSelected
                  ? DateFormat('dd / MM / yyyy').format(dateTime)
                  : 'Select Date',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            color: Colors.red.shade50,
            splashColor: Colors.red.shade50,
            focusColor: Colors.red,
            onPressed: () async {
              dateTime = await PlatformDatePicker.showDate(
                context: context,
                firstDate: DateTime(DateTime.now().year - 50),
                initialDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 2),
                builder: (context, child) => Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: const Color(0xFF8CE7F1),
                    accentColor: const Color(0xFF8CE7F1),
                    colorScheme: ColorScheme.light(
                        primary: const Color(0xFF8CE7F1)),
                    buttonTheme: ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  child: child,
                ),
              );
              if (dateTime != null) {

              }
            },
          ),
          OutlinedButton(onPressed: _uploadFileToGoogleDrive, child: Text('Pick Photos')),
        ],
      ),
    );
  }

  _uploadFileToGoogleDrive() async {
    var login = false;
    var auth = await googleSignInAccount.authHeaders;
    if(auth==null){
      login = await _loginWithGoogle();
    }
    if(login){
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.File fileToUpload = ga.File();
    // fileToUpload.parents = ['New1'];
    var _createFolder = await drive.files.create(
      ga.File()
        ..name = 'YourDay'
      // ..parents = ['1f4tjhpBJwF5t6FpYvufTljk8Gapbwajc'] // Optional if you want to create subfolder
        ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
    );
    // drive.files.
    var pickedFile = await ImagePicker().getImage(
      source: ImageSource
          .gallery,
      imageQuality: 60,
    );
    var file = File(pickedFile.path);
    fileToUpload.parents = [_createFolder.id];
    // fileToUpload.
    fileToUpload.name = path.basename(file.absolute.path);
    var response = await drive.files.create(
      fileToUpload,
      uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
    );
    // ga.User newUser = ga.User();
    // newUser.emailAddress = 'sarthaksaxena9@gmail.com';
    // newUser.displayName = 'Sarthak Saxena';
    // // newUser.emailAddress.
    // await response.owners.add(newUser);
    // // response.owners.add();
    // print(response.owners[0]);
    // print(response.owners[1]);
    // googleSignInAccount.email.
    // final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;
    // _firebaseAuthLogin.app.options/.
    // _listGoogleDriveFiles();
  }}

  Future<bool> _loginWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
    setState(() {

    });
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount googleSignInAccount) async {
      if (googleSignInAccount != null) {
        _afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignIn.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storage.write(key: "signedIn", value: "false").then((value) {
          setState(() {
            signedIn = false;
          });
        });
      }
    } else {
      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();
      _afterGoogleLogin(googleSignInAccount);
    }
  }

  Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
    googleSignInAccount = gSA;
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    if (authResult.additionalUserInfo.isNewUser) {
      var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
      var drive = ga.DriveApi(client);
      // ga.File fileToUpload = ga.File();
      // fileToUpload.parents = ['New1'];
      _yourDayFolder = await drive.files.create(
        ga.File()
          ..name = 'YourDay'
        // ..parents = ['1f4tjhpBJwF5t6FpYvufTljk8Gapbwajc'] // Optional if you want to create subfolder
          ..mimeType = 'application/vnd.google-apps.folder',  // this defines its folder
      );
    }
    // print(user.emailVerified);
    // user.providerData.add(User)
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    storage.write(key: "signedIn", value: "true").then((value) {
      setState(() {
        signedIn = true;
      });
    });
  }
}
