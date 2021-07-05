import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/displayvideo/v1.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/screens/calender.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/widgets/maindrawer.dart';
import 'package:yday/screens/all_event_popup.dart';

import 'auth/user_edit_profile_screen.dart';
import 'frames/festival_list.dart';
import 'photos/photo_screen.dart';
import 'userevents/add_user_event_screen.dart';
import 'userevents/user_all_events_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  static const routeName1 = '/home1';
  static const routeName2 = '/home2';

  int tabNumber;
  HomePage({this.tabNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  var _pageController;
  bool isLoading = true;
  bool driveStarted = false;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  void initState() {
    var currentUser = Provider.of<UserData>(context, listen: false).userData;
    if (currentUser == null) {
      initsignin();
    }

    // fetchUser();
    _controller.index = selectedTab;
    driveStarted = currentUser.userRootDriveId != null;
    // var str = FirebaseMessaging.instance.getToken();
    // print(str);
    selectedTab = widget.tabNumber;
    _pageController = PageController(initialPage: selectedTab);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   // initsignin();
  //   // fetchUser();
  //
  //   super.didChangeDependencies();
  // }
  void fetchUser() async {
    // await Provider.of<Festivals>(context, listen: false).fetchFestival();

    // await Provider.of<UserData>(context, listen: false).fetchUser();
    // await Provider.of<GoogleAccountRepository>(context, listen: false)
    //     .loginWithGoogle();
    // setState(() {
    //   isLoading = false;
    // });
    // await Provider.of<Birthdays>(context,listen: false).fetchBirthday();
    // await Provider.of<Anniversaries>(context,listen: false).fetchAnniversary();
    // await Provider.of<Tasks>(context, listen: false).fetchTask();
  }

  void initsignin() async {
    // var str =await FirebaseMessaging.instance.getToken();
    // print(str);
    // final storage = new FlutterSecureStorage();
    // bool signin = await storage.read(key: "signedIn") == "true" ? true : false;
    // if(signin){
    // await Provider.of<UserData>(context,listen: false).fetchUser();
    await Provider.of<GoogleAccountRepository>(context, listen: false)
        .loginWithGoogle();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Image.asset("assets/images/Main_logo.png",height: 60,width: 100,),
        titleSpacing: 0.1,
        centerTitle: true,
        // automaticallyImplyLeading: true,
        actions: [
          if (selectedTab == 2)
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  Navigator.of(context).pushNamed(AddUserEventScreen.routeName);
                }),
          if (selectedTab == 4)
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(UserAccountEditScreen.routename);
                }),
        ],
      ),
      drawer: MainDrawer(),
      body: PageView(
          controller: _pageController,
          onPageChanged: (tab) {
            setState(() {
              // print(tab);
              selectedTab = tab;
            });
          },
          children: [
            AllEventPopUp(),
            FestivalList(),
            UserAllEventsScreen(),
          ]),
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: primaryColor,
        strokeColor: Color(0x30040307),
        unSelectedColor: Color(0xffacacac),
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset('assets/images/calender_icon.png'),
              ],
            ),//Icon(Icons.insert_drive_file_rounded),
            title: Text("Calendar",style: TextStyle(
              color: selectedTab==0?primaryColor:Colors.black,
              fontWeight:selectedTab==0? FontWeight.bold:FontWeight.normal
            ),),
          ),
          CustomNavigationBarItem(
            icon: Image.asset('assets/images/greeting_icon.png'),//Icon(Icons.insert_drive_file_rounded),
            title: Text("Greetings",style: TextStyle(
                color: selectedTab==1?primaryColor:Colors.black,
                fontWeight:selectedTab==1? FontWeight.bold:FontWeight.normal
            ),),
          ),
          CustomNavigationBarItem(
            icon: Image.asset('assets/images/drive_icon.png'),//Icon(Icons.insert_drive_file_rounded),
            title: Text("Photo Sharing",style: TextStyle(
                color: selectedTab==2?primaryColor:Colors.black,
                fontWeight:selectedTab==2? FontWeight.bold:FontWeight.normal
            ),),
          ),
        ],
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() => selectedTab = index);
          _pageController.jumpToPage(index);
          // setState(() {
          //   selectedTab = index;
          // });
        },
      ),
    );
  }

  Widget tabsWidget() {
    switch (selectedTab) {
      case 0:
        return AllEventPopUp(); //UserAllEventsScreen();

      case 1:
        return UserAllEventsScreen();

      case 2:
        return FestivalList();

      default:
        return AllEventPopUp();
    }
  }
}

