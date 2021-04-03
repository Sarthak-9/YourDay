import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yday/models/constants.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/widgets/auth/user_not_loggedin.dart';


class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  String _username=' ';
  String _userEmailId=' ';
  String _userPhone = ' ';
  var _isLoading = true;
  var _loggedIn = false;
  var _loggingOut = false;
  var _logOut = false;
  var _userEmail;
  DateTime _userDob = null;
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
      var _userID = _auth.currentUser.uid;
      var _user =_auth.currentUser;
      if(_user.displayName == null){
        var url = Uri.parse(
            'https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
        final response = await http.get(url);
        final _userProfile =await json.decode(response.body) as Map<String, dynamic>;
        // var str = json.decode(response.body)['name'];
        var _userData = _userProfile.values.elementAt(0);
        // _userProfile.forEach((key, _userData) {
          _username = _userData['userName'];
          _userEmailId = _userData['userEmail'];
          _userPhone = _userData['userPhone'];
          _userDob = _userData['userDOB']!=null?DateTime.parse(_userData['userDOB']):null;
        // });
      }else{
        _username = _user.displayName;
        _userEmailId = _user.email;
        _userPhone = _user.phoneNumber;
      }
    }
    // _userDob = _userProfile['userDOB'];
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState()  {
    // TODO: implement initState
    _fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Container(
      // alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
      child: _isLoading? Center(
        child: CircularProgressIndicator(
        ),
      ) :
          _loggedIn ?
      Column(
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              //backgroundImage: loadedBirthday.imageofPerson == null
              backgroundImage:   AssetImage('assets/images/userimage.png'),
                  //: FileImage(loadedBirthday.imageofPerson),
              radius: MediaQuery.of(context).size.width * 0.18,
            ),
          ),
          SizedBox(height: 20,),
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
              DateFormat('dd / MM / yyyy')
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
          SizedBox(height: 24,),
          MaterialButton(
            elevation: 0,
            // minWidth: double.maxFinite,
            height: 50,
            onPressed: logoutUser,
            color: Colors.green,
            child:_loggingOut? CircularProgressIndicator(): Text('Logout',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            textColor: Colors.white,
          ),
        ],
      ):UserNotLoggedIn(),
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
            child: Text('Yes'),
            onPressed: () {
              _logOut = true;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    if(_logOut){
      setState(() {
        _loggingOut = true;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      await Constants.prefs.setBool("loggedIn", false);
      setState(() {
        _loggingOut = false;
      });
      Navigator.of(context).pushReplacementNamed(LoginPage.routename);
    }
    }
}
