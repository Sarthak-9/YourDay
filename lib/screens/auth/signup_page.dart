import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:account_picker/account_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/userdata.dart';
import 'package:http/http.dart' as http;
import 'package:yday/screens/auth/login_page.dart';
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

  final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordVerifyController =
      TextEditingController();
  final phoneFocus = FocusNode();
  DateTime dateTime = null;
  final storage = new FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  bool _isSuccess;
  String _userEmail = '';
  String _userPassword = '';
  String _username = '';
  String _userPhoneNumber = '';
  String _userGender='Male';
  Timer timer;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    _username = user.displayName;
    pickPhone();
    super.initState();
  }
  void pickPhone()async{
    final String phone = await AccountPicker.phoneHint();
    setState(() {
      _phoneNumberController.text = phone;
    });
  }

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
        // backgroundColor: primaryColor,
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/bg7.jpg'),
          fit: BoxFit.fill,
          // alignment:Alignment.topCenter,
        ),
      ),
      // alignment: Alignment.center,
      // margin: EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _signupKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 70),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/YD.png',
                    height: 100,
                  ),
                ),
                SizedBox(height: 30),
                CircleAvatar(
                  backgroundImage: user.photoURL == null
                      ? AssetImage('assets/images/userimage.png')
                      : NetworkImage(user.photoURL),
                  radius: MediaQuery.of(context).size.width * 0.18,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Enter your details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 2)),
                  child: TextFormField(
                    initialValue: user.displayName,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _username = value;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.black),
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: primaryColor,
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
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 2.0)),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    focusNode: phoneFocus,
                    validator: (value) {
                      // if (value.isEmpty ) {
                      // }
                       if(value.contains('+91')&&value.length==13)
                        return null;
                      else if(value.length==10)
                      return null;
                      return 'Please enter a valid phone number';
                    },
                    // onTap: () async {
                    //   final String phone = await AccountPicker.phoneHint();
                    //   setState(() {
                    //     _phoneNumberController.text = phone;
                    //   });
                    // },
                    onSaved: (value) {
                      _userPhoneNumber = value;
                    },
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black),

                    decoration: InputDecoration(
                      suffixIcon: IconButton(icon: Icon(Icons.contact_page_outlined),
                      onPressed: () async {
                        final String phone = await AccountPicker.phoneHint();
                        setState(() {
                          _phoneNumberController.text = phone;
                        });
                      },),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: primaryColor),
                        icon: Icon(
                          Icons.phone,
                          color: primaryColor,
                        ),
                        // prefix: Icon(icon),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 130,
                      //    50 double.maxFinite, //MediaQuery.of(context).size.width*0.7,
                      // height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        // color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 2.0)
                      ),
                      child: TextButton(
                        child: Text(
                          dateTime!=null
                              ? DateFormat('dd  MMM  yyyy').format(dateTime)
                              : 'Date of Birth',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              // fontWeight: FontWeight.w800
                          ),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          dateTime = await PlatformDatePicker.showDate(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 100),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 2),
                              builder: (context, child) => Theme(
                                data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child,
                              ));
                          // if (dateTime != null) {
                            setState(() {
                            });
                          // }
                        },
                      ),
                    ),
                    Container(
                      width: 130,
                      alignment: Alignment.center,
                      // color: Theme.of(context).primaryColor,
                      decoration: BoxDecoration(
                          color: Colors.blue,

                          // color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue, width: 2.0)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: _userGender,
                        icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black, fontSize: 16,),
                        underline: Container(
                          // height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _userGender = newValue;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.green,width: 2.0),
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: MaterialButton(
                    // elevation: 0,
                    minWidth: double.maxFinite,
                    height: 60,
                    onPressed: _registerAccount,
                    color: Colors.green,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Proceed to YourDay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                    textColor: Colors.white,
                  ),
                ),
                // SizedBox(height: 20),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _registerAccount() async {
    FocusScope.of(context).unfocus();
    var isValid = _signupKey.currentState.validate();
    if (dateTime == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Date of Birth !!'),
          content: Text('Please enter a valid Date of Birth.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
      return;
    }
    if (!isValid) {
      return;
    }
    _signupKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      _userEmail = auth.currentUser.email;
      UserDataModel newUser = UserDataModel(
          userEmail: user.email,
          userPhone: _userPhoneNumber,
          userName: _username,
          userGender: _userGender,
          dateofBirth: dateTime,
          userRootDriveId: null,
          profilePhotoLink: user.photoURL);
      await Provider.of<UserData>(context, listen: false).addUser(newUser);
      // if(_auth ==null||_auth.currentUser==null){
      //   return false ;
      // }
      // try{
      // UserDataModel newUser = UserDataModel(userEmail: _userEmail, userPhone: _userPhoneNumber, userName: _username, dateofBirth: dateTime, userRootDriveId: null);
      // await Provider.of<UserData>(context,listen: false).addUser(newUser);
      await storage.write(key: "signedIn", value: "true");
      // } catch (error) {
      //   throw error;
      // }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      // }
      // });
      // }
      // } else {
      //   _isSuccess = false;
      // }
      // setState(() {
      //   _isLoading = false;
      // });
    } catch (error) {
      throw error;
    }
  }
}
