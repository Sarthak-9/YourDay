// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:google_sign_in/google_sign_in.dart' as signIn;
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:http/io_client.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http_parser/http_parser.dart';
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Drive',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: PhotoScreen(title: 'Google Drive'),
//     );
//   }
// }
//
// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;
//
//   GoogleHttpClient(this._headers) : super();
//
//   @override
//   Future<http.StreamedResponse> send1(http.BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));
//
//   @override
//   Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }
//
// class PhotoScreen extends StatefulWidget {
//   PhotoScreen({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _PhotoScreenState createState() => _PhotoScreenState();
// }
//
// class _PhotoScreenState extends State<PhotoScreen> {
//   final storage = new FlutterSecureStorage();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn =
//   GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
//   GoogleSignInAccount googleSignInAccount;
//   ga.FileList list;
//   var signedIn = false;
//
//   Future<void> _loginWithGoogle() async {
//     signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
//     googleSignIn.onCurrentUserChanged
//         .listen((GoogleSignInAccount googleSignInAccount) async {
//       if (googleSignInAccount != null) {
//         _afterGoogleLogin(googleSignInAccount);
//       }
//     });
//     if (signedIn) {
//       try {
//         googleSignIn.signInSilently().whenComplete(() => () {});
//       } catch (e) {
//         storage.write(key: "signedIn", value: "false").then((value) {
//           setState(() {
//             signedIn = false;
//           });
//         });
//       }
//     } else {
//       final GoogleSignInAccount googleSignInAccount =
//       await googleSignIn.signIn();
//       _afterGoogleLogin(googleSignInAccount);
//     }
//   }
//
//   Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
//     googleSignInAccount = gSA;
//     final GoogleSignInAuthentication googleSignInAuthentication =
//     await googleSignInAccount.authentication;
//
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );
//
//     final authResult = await _auth.signInWithCredential(credential);
//     final user = authResult.user;
//
//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);
//
//     final currentUser = await _auth.currentUser;
//     assert(user.uid == currentUser.uid);
//
//     print('signInWithGoogle succeeded: $user');
//
//     storage.write(key: "signedIn", value: "true").then((value) {
//       setState(() {
//         signedIn = true;
//       });
//     });
//   }
//
//   void _logoutFromGoogle() async {
//     googleSignIn.signOut().then((value) {
//       print("User Sign Out");
//       storage.write(key: "signedIn", value: "false").then((value) {
//         setState(() {
//           signedIn = false;
//         });
//       });
//     });
//   }
//   Future<void> _listGoogleDriveFiles() async {
//     var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//     var drive = ga.DriveApi(client);
//     drive.files.list(spaces: 'appDataFolder').then((value) {
//       setState(() {
//         list = value;
//       });
//       for (var i = 0; i < list.files.length; i++) {
//         print("Id: ${list.files[i].id} File Name:${list.files[i].name}");
//       }
//     });
//   }
//   _uploadFileToGoogleDrive() async {
//     var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//     var drive1 = ga.DriveApi(client);
//     ga.File fileToUpload = ga.File();
//     // var file = await FilePicker.getFile();
//     var pickedFile = await ImagePicker().getImage(
//       source: ImageSource
//           .gallery,
//       imageQuality: 60,
//     ); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
//     if (pickedFile != null) {
//       var file = File(pickedFile.path);
//       // fileToUpload.parents = ["appDataFolder"];
//       fileToUpload.name = path.basename(file.absolute.path);
//       // File f1 = drive1.dr
//       var response = await drive1.files.create(
//         fileToUpload,
//         uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//       );
//       print(response);
//       var resp = await _listGoogleDriveFiles();
//     }}
//
//
//
//   Future<void> _downloadGoogleDriveFile(String fName, String gdID) async {
//     var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//     var drive = ga.DriveApi(client);
//     ga.Media file = await drive.files
//         .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia);
//     print(file.stream);
//
//     final directory = await getExternalStorageDirectory();
//     print(directory.path);
//     final saveFile = File('${directory.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
//     List<int> dataStore = [];
//     file.stream.listen((data) {
//       print("DataReceived: ${data.length}");
//       dataStore.insertAll(dataStore.length, data);
//     }, onDone: () {
//       print("Task Done");
//       saveFile.writeAsBytes(dataStore);
//       print("File saved at ${saveFile.path}");
//     }, onError: (error) {
//       print("Some Error");
//     });
//   }
//
//   List<Widget> generateFilesWidget() {
//     List<Widget> listItem = List<Widget>();
//     if (list != null) {
//       for (var i = 0; i < list.files.length; i++) {
//         listItem.add(Row(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width * 0.05,
//               child: Text('${i + 1}'),
//             ),
//             Expanded(
//               child: Text(list.files[i].name),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.3,
//               child: FlatButton(
//                 child: Text(
//                   'Download',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//                 color: Colors.indigo,
//                 onPressed: () {
//                   _downloadGoogleDriveFile(list.files[i].name, list.files[i].id);
//                 },
//               ),
//             ),
//           ],
//         ));
//       }
//     }
//     return listItem;
//   }
//   int _counter = 0;
//
//   Future<void> _incrementCounter() async {
//     setState(() {
//       _counter++;
//     });
//
//     final googleSignIn =
//     signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
//     final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
//
//     print("User account $account.email");
//
//     final authHeaders = await account.authHeaders;
//     final authenticateClient = GoogleAuthClient(authHeaders);
//     final driveApi = drive.DriveApi(authenticateClient);
//     // var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//     // var drive1 = ga.DriveApi(client);
//     ga.File fileToUpload = ga.File();
//     var pickedFile = await ImagePicker().getImage(
//       source: ImageSource
//           .gallery,
//       imageQuality: 60,
//     ); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
//     if (pickedFile != null) {
//       var file = File(pickedFile.path);
//       // fileToUpload.parents = ["appDataFolder"];
//       fileToUpload.name = path.basename(file.absolute.path);
//       var response = await driveApi.files.create(
//         fileToUpload,
//         uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//       );
//       print(response);}
//     // final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
//     // var media = new drive.Media(mediaStream, 2);
//     // var driveFile = new drive.File();
//     // driveFile.name = "hello_world.txt";
//     // final result = await driveApi.files.create(driveFile, uploadMedia: media);
//     // print("Upload result: $result");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YourDay'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             (signedIn
//                 ? FlatButton(
//               child: Text('Upload File to Google Drive'),
//               onPressed: _uploadFileToGoogleDrive,
//               color: Colors.green,
//             )
//                 : Container()),
//             (signedIn
//                 ? FlatButton(
//               child: Text('List Google Drive Files'),
//               onPressed: _listGoogleDriveFiles,
//               color: Colors.green,
//             )
//                 : Container()),
//             (signedIn
//                 ? Expanded(
//               flex: 10,
//               child: Column(
//                 children: generateFilesWidget(),
//               ),
//             )
//                 : Container()),
//             (signedIn
//                 ? FlatButton(
//               child: Text('Google Logout'),
//               onPressed: _logoutFromGoogle,
//               color: Colors.green,
//             )
//                 :
//             FlatButton(
//               child: Text('Google Login'),
//               onPressed: _uploadFileToGoogleDrive,
//               color: Colors.red,
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//   void myUpload() async{
//     await _loginWithGoogle();
//     var pickedFile = await ImagePicker().getImage(
//       source: ImageSource
//           .gallery,
//       imageQuality: 60,
//     ); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
//     // if (pickedFile != null)
//     var fileToUpload = File(pickedFile.path);
//     // fileToUpload.uri
//     final postUri = Uri.parse("https://www.googleapis.com/upload/drive/v3/files?uploadType=media");
//     // var response = await http.post(driveUrl,body: drive.Media(fileToUpload., file.));
//     var request = new http.MultipartRequest("POST", postUri);
//     request.fields['user'] = 'blah';
//     request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri(fileToUpload.uri).readAsBytes(),contentType: new MediaType('image', 'jpeg')) );
//     await request.send().then((response) {
//       if (response.statusCode == 200) print("Uploaded!");
//     });
//   }
//
// }
//
// // @override
// // Widget build(BuildContext context) {
// //   // TODO: implement build
// //   throw UnimplementedError();
// // };
// class GoogleAuthClient extends http.BaseClient {
//   final Map<String, String> _headers;
//
//   final http.Client _client = new http.Client();
//
//   GoogleAuthClient(this._headers);
//
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _client.send(request..headers.addAll(_headers));
//   }
// }

//import 'dart:io';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:yday/providers/photos/secure_storage.dart';
// import 'package:http/io_client.dart'as io;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:yday/providers/photos/google_drive_methods.dart';
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:http/io_client.dart';
// import 'package:path_provider/path_provider.dart';
// class PhotoScreen extends StatefulWidget {
//   @override
//   _PhotoScreenState createState() => _PhotoScreenState();
// }
//
// class _PhotoScreenState extends State<PhotoScreen> {
//   List<Asset> images = <Asset>[];
//   String _error = 'No Error Dectected';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return AssetThumb(
//           asset: asset,
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//   final drive = GoogleDrive();
//   final storage = new FlutterSecureStorage();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn =
//   GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
//   GoogleSignInAccount googleSignInAccount;
//   ga.FileList list;
//   var signedIn = false;
//   //
//   Future<void> _loginWithGoogle() async {
//     signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
//     googleSignIn.onCurrentUserChanged
//         .listen((GoogleSignInAccount googleSignInAccount) async {
//       if (googleSignInAccount != null) {
//         _afterGoogleLogin(googleSignInAccount);
//       }
//     });
//     if (signedIn) {
//       try {
//         googleSignIn.signInSilently().whenComplete(() => () {});
//       } catch (e) {
//         storage.write(key: "signedIn", value: "false").then((value) {
//           setState(() {
//             signedIn = false;
//           });
//         });
//       }
//     } else {
//       final GoogleSignInAccount googleSignInAccount =
//       await googleSignIn.signIn();
//       _afterGoogleLogin(googleSignInAccount);
//     }
//   }
//
//   Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
//     googleSignInAccount = gSA;
//     final GoogleSignInAuthentication googleSignInAuthentication =
//     await googleSignInAccount.authentication;
//
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );
//
//     final authResult = await _auth.signInWithCredential(credential);
//     final user = authResult.user;
//
//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);
//
//     final currentUser = await _auth.currentUser;
//     assert(user.uid == currentUser.uid);
//
//     print('signInWithGoogle succeeded: $user');
//
//     storage.write(key: "signedIn", value: "true").then((value) {
//       setState(() {
//         signedIn = true;
//       });
//     });
//   }
//   void _logoutFromGoogle() async {
//     googleSignIn.signOut().then((value) {
//       print("User Sign Out");
//       storage.write(key: "signedIn", value: "false").then((value) {
//         setState(() {
//           signedIn = false;
//         });
//       });
//     });
//   }
//
//   _uploadFileToGoogleDrive() async {
//     var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//     var drive = ga.DriveApi(client);
//     ga.File fileToUpload = ga.File();
//     // var file = await FilePicker.getFile();
//     var pickedFile = await ImagePicker().getImage(
//           source: ImageSource
//               .gallery,
//           // imageQuality: 60,
//         );
//         var file = File(pickedFile.path);
//     fileToUpload.parents = ["appDataFolder"];
//     fileToUpload.name = path.basename(file.absolute.path);
//     var response = await drive.files.create(
//       fileToUpload,
//       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//     );
//     print(response);
//     // _listGoogleDriveFiles();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//           children: <Widget>[
//             Center(child: Text('Error: $_error')),
//             ElevatedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             Expanded(
//               child: buildGridView(),
//             ),
//             FlatButton(
//                 child: Text("UPLOAD"),
//                 onPressed: _uploadFileToGoogleDrive,
//                 // onPressed: () async {
//                 //   var pickedFile = await ImagePicker().getImage(
//                 //     source: ImageSource
//                 //         .gallery,
//                 //     // imageQuality: 60,
//                 //   );
//                 //   File image = File(pickedFile.path);
//                 //   await drive.upload(image);
//                 // }
//                 )
//           ],
//     );
//   }
// }
// // class GoogleHttpClient extends io.IOClient {
// //   Map<String, String> _headers;
// //
// //   GoogleHttpClient(this._headers) : super();
// //
// //   @override
// //   Future<StreamedResponse> send1(BaseRequest request) async{super.send(request..headers.addAll(_headers));}
// //
// //   @override
// //   Future<Response> head(Object url, {Map<String, String> headers}) =>
// //       super.head(url, headers: headers..addAll(_headers));
// //
// // }
// class GoogleHttpClient extends io.IOClient {
//   Map<String, String> _headers;
//   GoogleHttpClient(this._headers) : super();
//   @override
//   Future<http.StreamedResponse> send1(http.BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));
//   @override
//   Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }
//
// // Future<void> uploadFile()async{
//   //   var pickedFile = await ImagePicker().getImage(
//   //     source: ImageSource
//   //         .gallery,
//   //     // imageQuality: 60,
//   //   );
//   //   var fileToUpload = File(pickedFile.path);
//   //   final FirebaseAuth _auth = FirebaseAuth.instance;
//   //   final GoogleSignIn googleSignIn = GoogleSignIn(
//   //     scopes: ['https://www.googleapis.com/auth/drive'],
//   //   );
//   //
//   //   final GoogleSignInAccount googleSignInAccount = await
//   //   googleSignIn.signIn();
//   //   final GoogleSignInAuthentication googleSignInAuthentication =
//   //   await googleSignInAccount.authentication;
//   //
//   //   final AuthCredential credential = GoogleAuthProvider.credential(
//   //     accessToken: googleSignInAuthentication.accessToken,
//   //     idToken: googleSignInAuthentication.idToken,
//   //   );
//   //
//   //   var authResult = await _auth.signInWithCredential(credential);
//   //
//   //   var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//   //
//   //   // var driveApi = drive.dr //DriveApi(client);
//   //   var driveApi = ga.DriveApi(client);
//   //   //File('aabb' + 'sfileName' + '.jpg');
//   //
//   //   var response = await driveApi.files.create(ga.File()..name = 'my_file.jpg',
//   //       uploadMedia: ga.Media(fileToUpload.openRead(), fileToUpload.lengthSync()));
//   //
//   // }




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
