import 'package:dot_pagination_swiper/dot_pagination_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
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
  // final _loginkey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  String _userEmail = '';
  String _userPassword = '';
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent
          // ),
          // backgroundColor: primaryColor,
          body: Container(
        padding: EdgeInsets.all(10.0),
        height: deviceHeight,
        width: MediaQuery.of(context).size.width,
        // color: Theme.of(context).primaryColor,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/bg7.jpg'),
            fit: BoxFit.fill,
            alignment:Alignment.topCenter,
          ),
        ),
        // margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          // alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  // width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/Main_logo.png",
                    // height: 80,
                    // width: 200,
                  ),
                ),
                ElevatedButton(onPressed: (){}, child: Text('Help',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor
                ),)
              ],
            ),
        SizedBox(height: 10,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.75,
          child: DotPaginationSwiper(
          children: <Widget>[
          Card(
          elevation:5.0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/1498.gif',
                    placeholderScale: 3,
                    imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                      return Icon(Icons.do_not_disturb);
                    },
                    image: categories[0].image, // After image load
                  ),
            ),
          ),
            Card(
              elevation:5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/1498.gif',
                  placeholderScale: 3,
                  imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    return Icon(Icons.do_not_disturb);
                  },
                  image: categories[1].image, // After image load
                ),
              ),
            ),
            Card(
              elevation:5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/1498.gif',
                  placeholderScale: 3,
                  imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    return Icon(Icons.do_not_disturb);
                  },
                  image: categories[2].image, // After image load
                ),
              ),
            ),
            Card(
              elevation:5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/1498.gif',
                  placeholderScale: 3,
                  imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    return Icon(Icons.do_not_disturb);
                  },
                  image: categories[3].image, // After image load
                ),
              ),
            ),

          ],
      ),
        ),
            // LiquidSwipe.builder(
            //   waveType: WaveType.circularReveal,
            //   itemCount: categories.length,
            //   itemBuilder: (context, index) {
            //     final category = categories[index];
            //     return FadeInImage.assetNetwork(
            //       placeholder: 'assets/images/1498.gif',
            //       placeholderScale: 3,
            //       imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
            //         return Icon(Icons.do_not_disturb);
            //       },
            //       image: category.image, // After image load
            //     );
            //   },
            // ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: MaterialButton(
                elevation: 5.0,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                onPressed: _signInWithGoogle,
                color: Theme.of(context).primaryColor,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.account_circle),
                          SizedBox(width: 10),
                          Text('Sign-in using Google',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ],
                      ),
                textColor: Colors.white,
              ),
            ),

          ],
        ),
      )),
    );
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
      if(googleUser == null){
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential loginCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult =
          await _firebaseAuthLogin.signInWithCredential(loginCredential);
      // final User user = authResult.user;
      bool userStatus =
          await Provider.of<UserData>(context, listen: false).fetchUser();
      if (userStatus) {
        await storage.write(key: "signedIn", value: "true");
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        // await Provider.of<Festivals>(context, listen: false).fetchFestival();
      } else {
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
    Category(
        image:
            "https://firebasestorage.googleapis.com/v0/b/yourday-306218.appspot.com/o/App%20Data%2F20210720_161103_0000.png?alt=media&token=0706a69e-6cfc-49ae-a3e3-bae684cf97e5",
        name: "Feature"),
    Category(
        image:
            "https://firebasestorage.googleapis.com/v0/b/yourday-306218.appspot.com/o/App%20Data%2F20210720_161103_0001.png?alt=media&token=b2ce7a8b-7634-4645-ac9e-b3ec9a9016d9",
        name: "Feature"),
    Category(
        image:
            "https://firebasestorage.googleapis.com/v0/b/yourday-306218.appspot.com/o/App%20Data%2F20210720_161103_0002.png?alt=media&token=e30bf34f-11a7-45f8-8534-5298a947317e",
        name: "Feature"),
    Category(
        image:
            "https://firebasestorage.googleapis.com/v0/b/yourday-306218.appspot.com/o/App%20Data%2F20210720_161103_0003.png?alt=media&token=ab8c997e-54b2-4917-a120-7813ab74fafc",
        name: "Feature"),
  ];
}

class Category {
  final String image;
  final String name;

  Category({@required this.image, @required this.name});
}
