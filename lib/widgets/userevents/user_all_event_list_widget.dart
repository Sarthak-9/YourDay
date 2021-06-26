import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as v3;
import 'package:googleapis/run/v1.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/userevents/auth_manager.dart';
import 'package:yday/models/userevents/google_auth_client.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/screens/userevents/add_user_event_screen.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/widgets/userevents/user_event_widget.dart';
import 'package:googleapis/drive/v3.dart' as gd;
import 'package:http/http.dart' as http;
import 'package:file/file.dart' as fl;

import '../maindrawer.dart';

class UserEventListWidget extends StatefulWidget {
  @override
  _UserEventListWidgetState createState() => _UserEventListWidgetState();
}

class _UserEventListWidgetState extends State<UserEventListWidget> {
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
  GoogleSignInAccount googleSignInAccount;
  gd.FileList photoList;
  var rootFolderId = '';
  List<gd.File> userAllEvents = [];
  var signedIn = true;
  var _isLoading = true;
  // var loggedIn = true;
  var _driveStarted = true;
  var newUserStatus = false;
  gd.DriveApi api;

  @override
  void initState() {
    // TODO: implement initState
    // fetchInit();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UserEventListWidget oldWidget) {
    fetchInit();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void fetchInit() async {
    await fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'YourDay',
          style: TextStyle(
            fontFamily: "Kaushan Script",
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        actions: [
          // if (selectedTab == 0)
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Navigator.of(context).pushNamed(AddUserEventScreen.routeName);
              }),
          // if (selectedTab == 4)
          //   IconButton(
          //       icon: Icon(Icons.edit),
          //       onPressed: () {
          //         Navigator.of(context)
          //             .pushNamed(UserAccountEditScreen.routename);
          //       }),
        ],
      ),
      drawer: MainDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await fetchAllEvents();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Your Events',
                        style: TextStyle(
                            fontSize: 30.0, fontFamily: 'Libre Baskerville'
                            //color: Colors.white
                            ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      (userAllEvents == null || userAllEvents.isEmpty)
                          ? Center(
                              child: Text(
                                'You have no events,\n add some.',
                                style: TextStyle(
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userAllEvents.length,
                              itemBuilder: (ctx, i) => UserEventWidget(
                                  userAllEvents[i].id, userAllEvents[i].name),
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
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

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;
    //
    // assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);
    //
    // final User currentUser = await _auth.currentUser;
    // assert(user.uid == currentUser.uid);
    //
    // print('signInWithGoogle succeeded: $user');

    storage.write(key: "signedIn", value: "true").then((value) {
      setState(() {
        signedIn = true;
      });
    });
  }

  Future<void> fetchAllEvents() async {
    await _loginWithGoogle();
    // var _user = _auth.currentUser;
    // if (_user != null) {
    //   // Provider.of<UserData>(context).userData;
    //   var _userID = _auth.currentUser.uid;
    //   var url = Uri.parse(
    //       'https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
    // final response = await http.get(url);
    // final _userProfile =
    // await json.decode(response.body) as Map<String, dynamic>;
    // var _userData = _userProfile.values.elementAt(0);
    await Provider.of<UserData>(context, listen: false).fetchUser();
    var currentUser = Provider.of<UserData>(context, listen: false).userData;
    var userRootDriveId =
        currentUser.userRootDriveId; //_userData['userRootDriveId'];
    GoogleDriveRepository googleDriveRepository =
        GoogleDriveRepository(googleSignInAccount);
    userAllEvents =
        await googleDriveRepository.findFilesInFolder(userRootDriveId);
    await Provider.of<UserEvents>(context, listen: false).fetchUserEvent();
    setState(() {
      _isLoading = false;
    });
    // }
  }
}
