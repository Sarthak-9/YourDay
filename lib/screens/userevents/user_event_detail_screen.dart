import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart' as sh;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/widgets/userevents/user_event_image_widget.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import '../homepage.dart';
import 'add_images_to_user_events.dart';

class UserEventDetailScreen extends StatefulWidget {
  final String folderId;
  UserEventDetailScreen(this.folderId);

  static const routeName = '/user-event-detail-screen';
  @override
  _UserEventDetailScreenState createState() => _UserEventDetailScreenState();
}

class _UserEventDetailScreenState extends State<UserEventDetailScreen> {
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
  GoogleSignInAccount googleSignInAccount;
  bool signedIn = false;
  bool _isLoading = false;
  // List<ga.File> userAllEvents = [];
  // List<fl.File> userFiles = [];
  List<String> members = [];
  List<ga.File> eventImages = [];
  final emailController = TextEditingController();
  final snackBar = SnackBar(content: Text('Friend Added Successfully'));
  final snackBar2 = SnackBar(content: Text('Your email should end with @gmail.com'));

  GoogleSignInAccount account;
  List<UserEvent> userEventList;
  int userEventIndex;
  // ga.DriveApi api;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () {
      fetchImages();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final userEventList = Provider.of<UserEvents>(context).userEventList;
    //  userEventIndex = userEventList.indexWhere((element) {
    //   return element.folderId == widget.folderId;
    // });
    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        title:  GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
            child: Image.asset(
              "assets/images/Main_logo.png",
              height: 60,
              width: 100,
            )),
        titleSpacing: 0.1,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddImageToEventScreen.routeName,
                    arguments: widget.folderId);
              }),
          IconButton(icon: Icon(Icons.delete), onPressed: deleteEvent),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userEventIndex < 0
              ? Center(
                  child: Text(
                    'No Photos',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 8,
                          shadowColor: Theme.of(context).primaryColor,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Text(
                                  userEventList[userEventIndex].userEventName,
                                  style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '- ' +
                                      userEventList[userEventIndex].authorName,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    // color: Colors.black87
                                  ),
                                  // textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat('dd / MM / yyyy').format(
                                        userEventList[userEventIndex]
                                            .userDateOfEvent),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                                if(members!=null&&members.isNotEmpty)
                                ElevatedButton(
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                                elevation: 5.0,
                                                insetAnimationCurve:
                                                    Curves.slowMiddle,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemBuilder: (ctx, i) =>
                                                        Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        members[i],
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    itemCount: members.length,
                                                  ),
                                                ),
                                              ));
                                      // var members =
                                      //     await Provider.of<UserEvents>(context,
                                      //             listen: false)
                                      //         .fetchMembersList(
                                      //             userEventList[userEventIndex]
                                      //                 .authorId,
                                      //             userEventList[userEventIndex]
                                      //                 .userEventId);
                                      // userEventList[userEventIndex].memberEmails = members;
                                      // print(members);
                                    },
                                    child: Text('Members')),
                                if (userEventList[userEventIndex]
                                        .userEventNotes !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      userEventList[userEventIndex]
                                          .userEventNotes,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: TextFormField(
                                    // key: formKey,
                                    controller: emailController,
                                    // focusNode: focusNode,
                                    decoration: InputDecoration(
                                        labelText: 'Add Friend (Email) ',
                                        hintText: 'Enter Email',
                                        border: InputBorder.none),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: addPermission),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        // UserEventImageList(
                        //   userEventList: userEventList,
                        //   eventImages: eventImages,
                        //   userEventIndex: userEventIndex,
                        // )
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: eventImages.length,
                          addAutomaticKeepAlives: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          itemBuilder: (ctx, i) => UserEventImageWidget(
                            // eventName: userEvent.da,
                            eventName:
                                userEventList[userEventIndex].userEventName,
                            eventDate:
                                userEventList[userEventIndex].userDateOfEvent,
                            imageId: eventImages[i].id,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> fetchImages() async {
    userEventList =
        Provider.of<UserEvents>(context, listen: false).userEventList;
    userEventIndex = userEventList.indexWhere((element) {
      return element.folderId == widget.folderId;
    });
    // userEventList[userEventIndex].
    // GoogleSignInAccount saccount;
    googleSignInAccount =
        Provider.of<GoogleAccountRepository>(context, listen: false)
            .googleSignInAccount;
    User _user = _auth.currentUser;
    String folderId = widget.folderId;
    print(folderId);
    if (_user != null) {
      GoogleDriveRepository googleDriveRepository =
          GoogleDriveRepository(googleSignInAccount);
      eventImages = await googleDriveRepository.findPicturesInFolder(folderId);

      members = await Provider.of<UserEvents>(context, listen: false)
          .fetchMembersList(userEventList[userEventIndex].authorId,
              userEventList[userEventIndex].userEventId);
      userEventList[userEventIndex].memberEmails = members;
      // print(members);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addPermission() async {
    FocusScope.of(context).unfocus();
    String email = emailController.text;
    if (!email.contains('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      return;
    }
    bool confirmAdd = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Friend'),
        content: Text('Are you sure you want to add friend?'),
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
              confirmAdd = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if (confirmAdd) {
      String friendId = await Provider.of<UserEvents>(context, listen: false)
          .checkExistingDriveUser(email);
      if (friendId != null) {
        userEventList[userEventIndex].memberEmails.add(email);
        await Provider.of<UserEvents>(context, listen: false)
            .addFriendToDrive(userEventList[userEventIndex], friendId);
        GoogleDriveRepository googleDriveRepository =
            GoogleDriveRepository(googleSignInAccount);
        await googleDriveRepository.addPermission(email, widget.folderId);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Friend not registered !!'),
            content: Text(
                'The email of friend you hve entered is not a user of YourDay or has not enabled Google Drive.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                child: Text('Share the App'),
                onPressed: () {
                  sh.Share.share(
                    'www.google.com',
                  );
                  Navigator.of(ctx).pop();
                },
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        );
      }
      emailController.clear();
      FocusScope.of(context).unfocus();
    } else {
      emailController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> deleteEvent() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete this Event'),
        content:
            Text('Are you sure you want to delete this event permanently ?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(ctx).pop();
                setState(() {
                  _isLoading = true;
                });
                FirebaseAuth _auth = FirebaseAuth.instance;
                var _userID = _auth.currentUser.uid;
                if(_userID==userEventList[userEventIndex].authorId) {
                  GoogleDriveRepository googleDriveRepository =
                      GoogleDriveRepository(googleSignInAccount);
                  await googleDriveRepository.deleteFolder(widget.folderId);
                }
                await Provider.of<UserEvents>(context, listen: false).deleteEvent(userEventIndex,userEventList[userEventIndex].userEventId);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(HomePage.routeName2, (route) => false);

                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => HomePage(
                //           tabNumber: 2,
                //         )));
                setState(() {
                  _isLoading = false;
                });
              })
        ],
      ),
    );
  }
}

class UserEventImageList extends StatelessWidget {
  List<UserEvent> userEventList;
  List<ga.File> eventImages = [];
  int userEventIndex = 0;

  UserEventImageList(
      {this.userEventList, this.eventImages, this.userEventIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: eventImages.length,
        addAutomaticKeepAlives: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        itemBuilder: (ctx, i) => UserEventImageWidget(
          // eventName: userEvent.da,
          eventName: userEventList[userEventIndex].userEventName,
          eventDate: userEventList[userEventIndex].userDateOfEvent,
          imageId: eventImages[i].id,
        ),
      ),
    );
  }
}
