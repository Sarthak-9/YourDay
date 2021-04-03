// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:yday/screens/auth/signup_page.dart';
// import 'package:yday/screens/homepage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class LoginPage extends StatefulWidget {
//   static const routename = '/login';
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _loginkey = GlobalKey<FormState>();
//   final _authLogin = FirebaseAuth.instance;
//
//   String _userEmail = '';
//   String _userPassword = '';
//
//   void _trySubmit() {}
//   void _submitAuthFormLogin(String email,
//       String password,BuildContext ctx) async {
//
//     UserCredential authResult;
//     try {
//         authResult = await _authLogin.signInWithEmailAndPassword(
//             email: _userEmail, password: _userPassword);
//         // Navigator.of(context).pushNamed(HomePage.routeName);
//     } on PlatformException catch (error) {
//       var message = 'An error occured, please check your credentials';
//       if (error.message != null) message = error.message;
//       Scaffold.of(ctx).showSnackBar(SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ));
//     }on FirebaseAuthException catch (e) {
//       var message;
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided for that user.';
//       }
//       Scaffold.of(ctx).showSnackBar(SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ));
//     }
//     catch (err) {
//       print(err);
//     }
//     // if(!isValid){
//     //   Scaffold.of(ctx).showSnackBar(SnackBar(
//     //     content: Text('message'),
//     //     backgroundColor: Theme.of(ctx).errorColor,
//     //   ));
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mdq = MediaQuery.of(context);
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         //alignment: Alignment.topCenter,
//         width: mdq.size.width,
//         height: mdq.size.height,
//         color: Theme.of(context).primaryColor,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 60.0),
//               ),
//               // CircleAvatar(
//               //   backgroundImage: AssetImage("assets/images/YD.png"), //,
//               //   backgroundColor: Colors.white,
//               //   radius: 60.0,
//               // ),
//               Card(
//                 child: Image(
//                   image: AssetImage("assets/images/YD.png"),
//                   width: 200,
//                   height: 100,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.all(8.0)),
//               Text(
//                 'Your Day',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 28.0,
//                 ),
//               ),
//               Padding(padding: EdgeInsets.all(4.0)),
//               Text(
//                 "Enter your details here",
//                 style: TextStyle(fontSize: 15.0, color: Colors.white),
//               ),
//               Padding(padding: EdgeInsets.all(10.0)),
//               AuthWidget(_submitAuthFormLogin),
//               Padding(padding: EdgeInsets.all(4.0)),
//               OutlineButton(
//                 child: Text(
//                   "  New here ? Sign Up  ",
//                   style: TextStyle(
//                     color: Theme.of(context).accentColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(SignUp.routename);
//                   //Navigator.pushNamed(context, SignUp.routename);
//                 },
//                 textColor: Colors.amber,
//               ),
//               Padding(padding: EdgeInsets.all(4.0)),
//
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(HomePage.routeName);
//                   //Navigator.pushReplacementNamed(context, MainHomePage.id);
//                 },
//                 child: Text(
//                   "Forgot Password ? Need help ",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               ),
//               // Padding(padding: EdgeInsets.all(2.0)),
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(HomePage.routeName);
//                   //Navigator.pushReplacementNamed(context, MainHomePage.id);
//                 },
//                 child: Text(
//                   "Skip this step",
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AuthWidget extends StatefulWidget {
//   final void Function(String email,
//       String password,BuildContext ctx) submitFn;
//
//   AuthWidget(this.submitFn);
//
//   @override
//   _AuthWidgetState createState() => _AuthWidgetState();
// }
//
// class _AuthWidgetState extends State<AuthWidget> {
//   final _loginkey = GlobalKey<FormState>();
//   // final _authLogin = FirebaseAuth.instance;
//
//   String _userEmail = '';
//   String _userPassword = '';
//   void _trySubmit(){
//     FocusScope.of(context).unfocus();
//     var isValid = _loginkey.currentState.validate();
//     if (isValid) {
//       _loginkey.currentState.save();
//     }
//     widget.submitFn(_userEmail,_userPassword,context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _loginkey,
//       child: Column(
//         children: [
//           Card(
//             borderOnForeground: false,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: EdgeInsets.symmetric(horizontal: 8.0),
//             child:
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.0),
//               child: Row(children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 2.0,
//                   ),
//                 ),
//                 Icon(
//                   Icons.email_sharp,
//                   color: Colors.green,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 2.0,
//                   ),
//                 ),
//                 Flexible(
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value.isEmpty || !value.contains('@')) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _userEmail = value;
//                     },
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       labelText: " Email / Phone ",
//                       hintText: " Email or Phone",
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: EdgeInsets.all(8.0),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.0),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 2.0,
//                     ),
//                   ),
//                   Icon(
//                     Icons.archive_outlined,
//                     color: Colors.green,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 2.0,
//                     ),
//                   ),
//                   Flexible(
//                     child: TextFormField(
//                       validator: (value) {
//                         if (value.isEmpty || value.length < 7) {
//                           return 'Password must be atleast 7 charachters';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _userPassword = value;
//                       },
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         labelText: " Password",
//                         hintText: " Password",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(padding: EdgeInsets.all(4.0)),
//           RaisedButton(
//             child: Text(
//               'Sign In',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             onPressed: _trySubmit,
//             color: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
