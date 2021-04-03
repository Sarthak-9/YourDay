import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/userdata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../homepage.dart';

class SignUp extends StatefulWidget {
  static const routename = '/signup-page';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Color primaryColor = Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordVerifyController = TextEditingController();
  DateTime dateTime = null;
  bool _dateSelected = false;

  bool _isSuccess;
  String _userEmail='';
  String _userPassword = '';
  String _username='';
  String _userPhoneNumber='';
  Timer timer;
  var _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordVerifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                color: Colors.white70,
                // color: Theme.of(context).primaryColor,
                icon: Icon(Icons.cancel_outlined),
                onPressed: () {}),
          ],
        ),
        backgroundColor: primaryColor,
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _signupKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/YD.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Sign in to YourDay and continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    // style:
                    // GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: secondaryColor, border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // // _buildTextField(
                  // //     nameController, Icons.account_circle, 'Username'),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: secondaryColor, border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value.isEmpty || value.length!=10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPhoneNumber = value;
                      },
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // _buildTextField(
                  //     nameController, Icons.account_circle, 'Username'),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // _buildTextField(passwordController, Icons.lock, 'Password'),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: secondaryColor, border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      controller: _passwordVerifyController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be atleast 7 charachters';
                        }
                        if(value != _passwordController.text){
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _userPassword = value;
                      // },
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Verify Password',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.maxFinite,//MediaQuery.of(context).size.width*0.7,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Colors.blue)),
                    child: TextButton(
                      child: Text(
                        _dateSelected
                            ? DateFormat('dd / MM ').format(dateTime)
                            : 'Select your Date of Birth',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
                          setState(() {
                            _dateSelected = true;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: _registerAccount,
                    color: Colors.green,
                    child: _isLoading ? CircularProgressIndicator():Text('SignUp',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _registerAccount() async {
    FocusScope.of(context).unfocus();
    var isValid = _signupKey.currentState.validate();
    if (isValid) {
      _signupKey.currentState.save();
    }
    setState(() {
      _isLoading = true;
    });
    User user;
    try {
      if (isValid){
        user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ))
            .user;
      }
    } on FirebaseAuthException catch (signUpError) {
      if(signUpError.code == 'email-already-in-use'){
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Email already registered'),
            content: Text(
                'This email is already registered. Please login with your credentials'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (Navigator.canPop(context)) {
                    Navigator.of(ctx).pop();
                  }
                },
              )
            ],
          ),
        );
    }
    }

    if (isValid && user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        errorBar();

        bool _userVerified = await user.emailVerified;
        timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          user = _auth.currentUser;
          await user.reload();
          _userVerified = await user.emailVerified;
          if (_userVerified) {
            timer.cancel();
            Constants.prefs.setBool("loggedIn", true);
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.setString('userData', _emailController.text);
            // _userEmail = _emailController.text;
            FirebaseAuth _auth = FirebaseAuth.instance;
            if(_auth ==null||_auth.currentUser==null){
              return false ;
            }
            var _userID = _auth.currentUser.uid;
            var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
            try{
              if (isValid){
                final response = await http.post(url,
                    body: json.encode({
                      'userEmail': _userEmail,
                      'userName': _username,
                      'userPhone': _userPhoneNumber,
                      'userDOB' : dateTime !=null ? dateTime.toIso8601String():null,
                    }));
              }
            } catch (error) {
              throw error;
            }
            setState(() {
              _isLoading = false;
            });
            user.uid;
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          }
        });
      }
    } else {
      _isSuccess = false;
    }
    setState(() {
      _isLoading = false;
    });
  }
  void errorBar()async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Verify Email to proceed'),
        content: Text(
            'A verification link has been sent to your email. Please verify it to proceed further.'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
