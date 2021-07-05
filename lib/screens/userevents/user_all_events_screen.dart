import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/widgets/maindrawer.dart';
import 'package:yday/widgets/userevents/user_event_widget.dart';
import 'package:googleapis/drive/v3.dart' as gd;

import 'add_user_event_screen.dart';

class UserAllEventsScreen extends StatefulWidget {
  static const routeName = '/user-all-events-screen';
  @override
  _UserAllEventsScreenState createState() => _UserAllEventsScreenState();
}

class _UserAllEventsScreenState extends State<UserAllEventsScreen> {
  final storage = FlutterSecureStorage();
  TextEditingController searchTextController = TextEditingController();
  gd.FileList photoList;
  String rootFolderId = '';
  // List<gd.File> userAllEvents = [];
  bool signedIn = true;
  bool _isLoading = false;
  bool _driveStarted = true;
  bool newUserStatus = false;
  bool userDriveStatus = false;
  GoogleSignInAccount googleUser;
  UserDataModel driveUser;
  gd.DriveApi api;
  bool initStatus = false;
  bool _isSearching;
  String _searchText = "";
  List<UserEvent> searchResult = [];
  List<UserEvent> allEvents = [];
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
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
    // if (Provider.of<UserData>(context).userData == null) {
    //   await Provider.of<UserData>(context, listen: false).fetchUser();
    //   await Provider.of<GoogleAccountRepository>(context, listen: false)
    //       .loginWithGoogle();
    // }
    googleUser = Provider.of<GoogleAccountRepository>(context, listen: false)
        .googleSignInAccount;
    _driveStarted =
        Provider.of<UserData>(context).userData.userRootDriveId != null;
    if (_driveStarted) {
      await fetchAllEvents();
    } else {
      // await createDrive();
    }
    setState(() {
      _isLoading = false;
    });
  }

  _UserAllEventsScreenState() {
    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = searchTextController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   title: Text(
        //     'YourDay',
        //     style: TextStyle(
        //       fontFamily: "Kaushan Script",
        //       fontSize: 28,
        //     ),
        //   ),
        //   centerTitle: true,
        //   // automaticallyImplyLeading: false,
        //   actions: [
        //     // if (selectedTab == 0)
        //     IconButton(
        //         icon: Icon(Icons.add),
        //         onPressed: ()async {
        //
        //           Navigator.of(context).pushNamed(AddUserEventScreen.routeName);
        //         }),
        //     // if (selectedTab == 4)
        //     //   IconButton(
        //     //       icon: Icon(Icons.edit),
        //     //       onPressed: () {
        //     //         Navigator.of(context)
        //     //             .pushNamed(UserAccountEditScreen.routename);
        //     //       }),
        //   ],
        // ),
        // drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !_driveStarted
              ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(120, 50)),
                    child: Text('Proceed to Google Drive'),
                    onPressed: createDrive,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await fetchAllEvents();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Events',
                          style: TextStyle(
                              fontSize: 30.0, fontFamily: 'Libre Baskerville'
                              //color: Colors.white
                              ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        TextButton(
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: UserEventSearch(allEvents));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search),
                                Text(
                                  '  Search Event',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                  ),
                                ),
                              ],
                            )),
                        Divider(),
                        (allEvents == null || allEvents.isEmpty)
                            ? Center(
                                child: Text(
                                  'You have no events,\n add some.',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allEvents.length,
                                itemBuilder: (ctx, i) => UserEventWidget(
                                    allEvents[i].folderId,
                                    allEvents[i].userEventName),
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> fetchAllEvents() async {
    // var currentUser = Provider.of<UserData>(context, listen: false).userData;
    // String userRootDriveId = currentUser.userRootDriveId;
    // GoogleDriveRepository googleDriveRepository =
    //     GoogleDriveRepository(googleUser);
    // userAllEvents =
    //     await googleDriveRepository.findFilesInFolder(userRootDriveId);

    await Provider.of<UserEvents>(context, listen: false).fetchUserEvent();
    allEvents = Provider.of<UserEvents>(context, listen: false).userEventList;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> createDrive() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<GoogleAccountRepository>(context, listen: false)
        .loginDriveWithGoogle();
    // if(!newUserStatus){
    GoogleDriveRepository gdrepo = GoogleDriveRepository(googleUser);
    var fileId = await gdrepo.createRootFolder();
    // UserDataModel newUser = UserDataModel(userEmail: driveUser.email, userPhone: driveUser.phoneNumber, userName: driveUser.displayName, dateofBirth: null, userRootDriveId: fileId);
    await Provider.of<UserData>(context, listen: false).updateDrive(fileId);
    userDriveStatus = true;
    print('ml');
    await fetchAllEvents();

    setState(() {
      _isLoading = false;
      _driveStarted = true;
    });
  }
}

class UserEventSearch extends SearchDelegate<String> {
  List<UserEvent> events;

  UserEventSearch(this.events);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<UserEvent> suggestionList = query.isEmpty
        ? []
        : events.where((event) {
            return event.userEventName
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => UserEventWidget(
          suggestionList[i].folderId, suggestionList[i].userEventName),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserEvent> suggestionList = query.isEmpty
        ? []
        : events.where((event) {
            return event.userEventName
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => UserEventWidget(
          suggestionList[i].folderId, suggestionList[i].userEventName),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
