import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/frames/festivals.dart';
import '../homepage.dart';
import 'signup_page.dart';
import 'package:yday/services/google_signin_repository.dart';

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
  final storage = new FlutterSecureStorage();

  String _userEmail = '';
  String _userPassword = '';
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        // backgroundColor: primaryColor,
        body: Container(
          height: deviceHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/bg4.jpg'),
              fit: BoxFit.fill,
              // alignment:Alignment.topCenter,
            ),
          ),
          // margin: EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: _loginkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      'Explore Features',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ScaledList(
                      cardWidthRatio: 0.8,
                      selectedCardHeightRatio: 0.8,
                      unSelectedCardHeightRatio: 0.75,
                      itemCount: categories.length,
                      itemColor: (index) {
                        return kMixedColors[index % kMixedColors.length];
                      },
                      itemBuilder: (index, selectedIndex) {
                        final category = categories[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: selectedIndex == index ? deviceHeight*0.35 : deviceHeight*0.35,
                              child: Image.asset(category.image),
                            ),
                            SizedBox(height: 15),
                            Text(
                              category.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: selectedIndex == index ? 25 : 25),
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: _signInWithGoogle,
                      color: Theme.of(context).primaryColor,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.assignment_ind),
                                SizedBox(width: 10),
                                Text('Sign-in using Google',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                      textColor: Colors.white,
                    ),
                    // OutlinedButton(onPressed: (){}),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<GoogleAccountRepository>(context, listen: false)
          .loginWithGoogle();
      final GoogleSignInAccount googleUser =
          Provider.of<GoogleAccountRepository>(context, listen: false)
              .googleSignInAccount;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential loginCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult =
          await _firebaseAuthLogin.signInWithCredential(loginCredential);
      // final User user = authResult.user;
      bool userStatus = await Provider.of<UserData>(context,listen: false).fetchUser();
      if(userStatus){
        await storage.write(key: "signedIn", value: "true");
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        // await Provider.of<Festivals>(context, listen: false).fetchFestival();
      }
      else{
      Navigator.of(context).pushReplacementNamed(SignUp.routename);
      }
      setState(() {
        _isLoading = false;
      });
      // FirebaseAuth.instance.app.options.
    } catch (error) {
      print(error);
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
      if (isValid) {
        authResult = await _firebaseAuthLogin.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        await storage.write(key: "signedIn", value: "true");
        // await storage.write(key: "emailsignin",value: "true");

        // storage.write(key: "driveStarted", value: "false");
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
          content: Text(message),
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(message),
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
    } catch (err) {
      message = 'An error occured. Please try again';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(message),
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
    setState(() {
      _isLoading = false;
    });
  }

  final List<Color> kMixedColors = [
    Color(0xff71A5D7),
    Color(0xff72CCD4),
    Color(0xffFBAB57),
    Color(0xffF8B993),
    Color(0xff962D17),
    Color(0xffc657fb),
    Color(0xfffb8457),
  ];

  final List<Category> categories = [
    Category(image: "assets/images/bday.jpg", name: "Feature"),
    Category(image: "assets/images/bday.jpg", name: "Feature"),
    Category(image: "assets/images/bday.jpg", name: "Feature"),
    Category(image: "assets/images/bday.jpg", name: "Feature"),
    Category(image: "assets/images/bday.jpg", name: "Feature"),
  ];
}

class Category {
  final String image;
  final String name;

  Category({@required this.image, @required this.name});
}
