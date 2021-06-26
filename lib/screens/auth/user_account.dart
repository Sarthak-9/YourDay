import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yday/models/constants.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/widgets/auth/user_not_loggedin.dart';
import 'package:provider/provider.dart';
import 'package:yday/widgets/maindrawer.dart';

import 'user_edit_profile_screen.dart';

class UserAccountScreen extends StatefulWidget {
  static const routeName = '/user-account-screen';

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  String _username=' ';
  String _userGender = ' ';
  String _userEmailId=' ';
  String _userPhone = ' ';
  String _userProfilePhoto = null;
  bool _isLoading = true;
  bool _loggedIn = true;
  bool _loggingOut = false;
  bool _logOut = false;
  final storage = new FlutterSecureStorage();
  DateTime _userDob = null;

  @override
  void initState()  {
    // TODO: implement initState
    _fetchProfile();
    super.initState();
  }
  // @override
  // void didUpdateWidget(covariant UserAccount oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   // _fetchProfile();
  //
  //   // Future.delayed(Duration.zero).then((value) => _fetchProfile());
  //   super.didUpdateWidget(oldWidget);
  //   // _fetchProfile();
  // }

  Future<void> _fetchProfile()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth == null||_auth.currentUser==null){
      setState(() {
        _loggedIn = false;
      });
    }else{
      setState(() {
        _loggedIn = true;
      });
    }
    if(_loggedIn){
      setState(() {
        _isLoading = true;
      });
    var _userID = _auth.currentUser.uid;
    var _user =_auth.currentUser;
    await Provider.of<UserData>(context,listen: false).fetchUser();
    var currentUser = Provider.of<UserData>(context,listen: false).userData;
    _username = currentUser.userName;
    _userGender = currentUser.userGender;
    _userEmailId = currentUser.userEmail;
    _userPhone = currentUser.userPhone;
    _userDob = currentUser.dateofBirth;
    _userProfilePhoto = currentUser.profilePhotoLink;
    }

    // _userDob = _userProfile['userDOB'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          'YourDay',
          style: TextStyle(
            // fontFamily: "Kaushan Script",
            fontSize: 28,
          ),
        ),
        // centerTitle: true,
        // automaticallyImplyLeading: false,
        actions: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(UserAccountEditScreen.routename);
                }),
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
        child: _isLoading? Center(
          child: CircularProgressIndicator(
          ),
        ) :
            _loggedIn ?
        SingleChildScrollView(
          child : Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'My Profile',
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Libre Baskerville'
                  //color: Colors.white
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                // backgroundImage: loadedBirthday.imageofPerson == null

                backgroundImage: _userProfilePhoto != null? NetworkImage(_userProfilePhoto) :   AssetImage('assets/images/userimage.png'),
                    //: FileImage(loadedBirthday.imageofPerson),
                radius: MediaQuery.of(context).size.width * 0.18,
              ),

              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black54
                    )
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.person_outline_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Name',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _username,
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person_pin_circle_sharp,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Gender',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _userGender,
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Birth Date',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: _userDob!=null
                          ? Text(
                        DateFormat('MMM dd, yyyy')
                            .format(_userDob),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      )
                          : Text('None'),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.account_circle_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Email',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _userEmailId,
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Phone',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _userPhone!=null?_userPhone:'None',
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  minimumSize: Size(100,40)
                ),
                onPressed: logoutUser,
                child:_loggingOut? CircularProgressIndicator(): Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ):UserNotLoggedIn(),
      ),
    );
  }
  Future<void> logoutUser()async{
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out'),
        content: Text('Are you sure you want to Logout from YourDay'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              _logOut = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if(_logOut){
      setState(() {
        _loggingOut = true;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      await Provider.of<GoogleAccountRepository>(context, listen: false).googleLogout();
      await _auth.signOut();
      await storage.write(key: "signedIn",value: "false");
      // await Constants.prefs.setBool("loggedIn", false);
      setState(() {
        _loggingOut = false;
      });
      // await Provider.of<GoogleSignInAccount>(context,listen: false).clearAuthCache();
      // Navigator.of(context).
      Navigator.of(context).pushReplacementNamed(LoginPage.routename);
    }
    }
}
