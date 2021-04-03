
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/constants.dart';

import '../homepage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
    static const routename = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color primaryColor = Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _loginkey = GlobalKey<FormState>();

  String _userEmail = '';
  String _userPassword = '';
  var _isLoading = false;
  final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

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
                icon: Icon(Icons.cancel_outlined), onPressed: (){
              Constants.prefs.setBool("loggedIn", true);
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            }),
          ],
        ),
        backgroundColor: primaryColor,
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _loginkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:Image.asset(
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
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                        icon: Icon(
                          Icons.account_circle,
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
                      color: secondaryColor, border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be atleast 7 charachters';
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
                  SizedBox(height: 30),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: _submitAuthFormLogin,
                    color: Colors.green,
                    child: _isLoading ? CircularProgressIndicator(): Text('Login',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: _signInWithGoogle,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.assignment_ind),
                        SizedBox(width: 10),
                        Text('Sign-in using Google',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    textColor: Colors.white,
                  ),
                  // OutlinedButton(onPressed: (){}),
                  SizedBox(height: 10),
                  OutlinedButton(
                    child: Text(
                    "  New here ? Sign Up  ",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUp.routename);
                    //Navigator.pushNamed(context, SignUp.routename);
                  },
                ),
                  SizedBox(height: 10),
                TextButton(
                  onPressed:_resetPassword,
                  child: Text(
                    "Forgot Password ? Need help ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                ],
              ),
            ),
          ),
        ));
  }

  _signInWithGoogle()async{
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential loginCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);
    final User user = (await _firebaseAuthLogin.signInWithCredential(loginCredential)).user;

    if(user!=null){
      Constants.prefs.setBool("loggedIn", true);
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  void _submitAuthFormLogin() async {
    FocusScope.of(context).unfocus();
    var isValid = _loginkey.currentState.validate();
    if (isValid) {
      _loginkey.currentState.save();
    }
    setState(() {
      _isLoading = true;
    });
    var message = 'An error occured, please check your credentials';
    UserCredential authResult;
    try {
      if (isValid){
        authResult = await _firebaseAuthLogin.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        Constants.prefs.setBool("loggedIn", true);
        // final prefs = await SharedPreferences.getInstance();
        // if(!prefs.containsKey('userData')){
        //   prefs.setString('userData', _emailController.text);
        // }
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    } on PlatformException catch (error) {
      if (error.message != null) message = error.message;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
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
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
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
    }
    catch (err) {
      message = 'An error occured. Please try again';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
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
    }
    setState(() {
      _isLoading = false;
    });
    // if(!isValid){
    //   print('11');
    //   // Scaffold.of(context).showSnackBar(SnackBar(
    //   //   content: Text('message'),
    //   //   backgroundColor: Theme.of(context).errorColor,
    //   // ));
    // }
  }
  void _resetPassword()async{
    if(_emailController.text.isEmpty||!_emailController.text.contains('@')){
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Enter a valid email'),
          content: Text(
              'Unable to reset password to as email address is not valid.'),
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
      return;
    }
    await _firebaseAuthLogin.sendPasswordResetEmail(email: _emailController.text);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Password reset link sent'),
        content: Text(
            'A password reset link has been sent to your email. Please follow the steps to reset your password.'),
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