import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/constants.dart';
import 'package:file/file.dart' as fl;
import 'package:yday/models/userevents/auth_manager.dart';
import 'package:yday/models/userevents/google_auth_client.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/services/google_signin_repository.dart';

class AddUserEventScreen extends StatefulWidget {
  static const routeName = '/add-user-event-screen';
  @override
  _AddUserEventScreenState createState() => _AddUserEventScreenState();
}

class _AddUserEventScreenState extends State<AddUserEventScreen> {
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
  GoogleSignInAccount googleSignInAccount;
  ga.FileList list;
  // var signedIn = false;
  // var _yourDayFolder;
  var userEventName = '';
  var userEventDescription = '';
  var userEventNameController = TextEditingController();
  var userEventDescriptionController = TextEditingController();
  DateTime dateTime;
  double percent = 0;
  int imageCount = 0;
  int imagesLength = 0;
  bool isLoading = false;
  bool driveStarted = false;
  List<Asset> images = <Asset>[];
  UserDataModel currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    checkInit();
    super.didChangeDependencies();
  }

  void checkInit() async {
     currentUser = Provider.of<UserData>(context, listen: false).userData;
     driveStarted = currentUser.userRootDriveId !=null;
    // if(!driveStarted){
    //   await showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: Text('Drive not enabled!'),
    //       content: Text('Please proceed to Google Drive first'),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('Okay'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             // Navigator.of(ctx).pop();
    //           },
    //         )
    //       ],
    //     ),
    //   );
    //   return;
    // }
    googleSignInAccount =
        Provider.of<GoogleAccountRepository>(context).googleSignInAccount;
    // print(googleSignInAccount.authHeaders);
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'YourDay',
            style: TextStyle(
              // fontFamily: 'Kaushan Script',
              fontSize: 28,
            ),
          ),
        ),
        body:driveStarted? SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height*1.2,
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Add Event',
                    style: TextStyle(
                        fontSize: 26.0, fontFamily: 'Libre Baskerville'
                        //color: Colors.white
                        ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Event Name',
                    ),
                    controller: userEventNameController,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (value) {
                      userEventName = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Event Description',
                    ),
                    controller: userEventDescriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (value) {
                      userEventDescription = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: Text(
                        dateTime!=null
                            ? DateFormat('dd / MM ').format(dateTime)
                            : 'Select Date',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                          primary: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).accentColor)),
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
                        setState(() {});
                      }
                      // },
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text("Pick Images"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // if (states.contains(MaterialState.pressed))
                              return themeColor;
                              return null; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: loadAssets,
                      ),
                      ElevatedButton(
                        child: Text("Upload Images"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // if (states.contains(MaterialState.pressed))
                              return themeColor;
                              return null; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: saveForm,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (isLoading)
                    Text('Please wait while your event is being created.'),
                  SizedBox(
                    height: 10,
                  ),
                  if (isLoading)
                    FAProgressBar(
                      currentValue: percent.toInt(),
                      // backgroundColor: Theme.of(context).primaryColor,
                      progressColor: Theme.of(context).primaryColor,
                      displayText: '%',
                      displayTextStyle: TextStyle(color: Colors.white),
                      direction: Axis.horizontal,
                    ), //CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  LimitedBox(child: buildGridView()),
                  SizedBox(
                    height: 30,
                  )
                ],
              )),
        ):Container(
          alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Text('Google Drive not enabled.\n Enable it to add events.',textAlign: TextAlign.center,style: TextStyle(
          fontSize: 20.0,

          //color: Colors.white
        ),)));
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "YourDay",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  Future<void> saveForm() async {
    // if (images.isEmpty) {
    //   await showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: Text('Select Photos'),
    //       content: Text('Please select at least one photo.'),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('Okay'),
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //         )
    //       ],
    //     ),
    //   );
    //   return;
    // }
    if (userEventNameController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Name'),
          content: Text('Please enter a valid name.'),
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
    if (dateTime == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Date!'),
          content: Text('Enter a valid Date of Event.'),
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
    setState(() {
      isLoading = true;
    });
    await uploadImage();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(tabNumber: 2,)), (route) => false);

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //       builder: (context) => HomePage(
    //         tabNumber: 0,
    //       ),),
    // );
    setState(() {
      isLoading = false;
    });

  }

  Future<void> uploadImage() async {
    // var _user = _auth.currentUser;
    userEventName = userEventNameController.text;
    userEventDescription = userEventDescriptionController.text;
    // if (_user != null) {
    //   var _userID = _auth.currentUser.uid;
    //   var url = Uri.parse(
    //       'https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
    //   final response = await http.get(url);
    //   final _userProfile =
    //       await json.decode(response.body) as Map<String, dynamic>;
    //   var _userData = _userProfile.values.elementAt(0);
      var userRootDriveId = currentUser.userRootDriveId;//_userData['userRootDriveId'];
      imagesLength = images.length;
      GoogleDriveRepository googleDriveRepository =
          GoogleDriveRepository(googleSignInAccount);
      var eventFolder = await googleDriveRepository.createFolder(
          userEventName, userRootDriveId, userEventDescription);
      UserEvent newEvent = UserEvent(
          userDateOfEvent: dateTime,
          userEventNotes: userEventDescription,
          authorName: currentUser.userName,
          userEventName: userEventName,
          folderId: eventFolder.id);
      await Provider.of<UserEvents>(context, listen: false)
          .addUserEvent(newEvent);
      await Future.forEach(images, (uploadImage) async {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(uploadImage.identifier);
        await googleDriveRepository.savePicture(
            uploadImage.name, eventFolder.id, filePath);
        imageCount++;
        percent = ((imageCount * 100) / imagesLength);
        setState(() {});
      });
    // }
  }
}
