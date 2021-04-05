import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:popover/popover.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/auth/user_account.dart';
import 'package:yday/screens/calender.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/widgets/add_popover_widget.dart';
import 'package:yday/widgets/task_widget.dart';

import 'add_task.dart';
import 'frames/festival_list.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Your Day'),
          automaticallyImplyLeading: false,centerTitle: true,
      ),
      body: tabsWidget(),

      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Colors.green,
        // height:50,
        // top: -30,
        curveSize: 75,
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.insert_drive_file_outlined, title: 'Drive'),
          TabItem(icon: Icons.photo_album_rounded, title: 'Frames'),
          TabItem(icon: Icons.calendar_today_rounded, title: 'Calender'),
          TabItem(icon: Icons.event_available_rounded, title: 'Events'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: selectedTab,
        //optional, default as 0
        onTap: (tab)  {
        setState(() {
          selectedTab = tab;
        });
        //if(selectedTab==2){
      //     showPopover(
      //     context: context,
      //     bodyBuilder: (context) => const ListItems(),
      //     onPop: () => print('Popover was popped!'),
      //     direction: PopoverDirection.top,
      //     width: 200,
      //     height: 400,
      //     arrowHeight: 15,
      //     arrowWidth: 30,
      // );
          //}
      },
      ),
    );
  }

Widget tabsWidget() {
  switch (selectedTab) {
    case 0:
      return Center(
        child: Text('My Drive'),
      );

    case 1:
      return FestivalList();

    case 2:
      return AllEventPopUp();

    case 3:
      return EventScreen();
    //
    case 4:
      return UserAccount();
  // case 4:
  //   return UserProfile();

    default:
      return Calendar();
  }
}
}
//
//
