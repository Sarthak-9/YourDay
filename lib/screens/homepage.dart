import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/widgets/task_widget.dart';

import 'add_task.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 2;

  @override
  Widget build(BuildContext context) {
    int selectedTab = 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Your Day'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddTask.routeName);
            },
          ),
        ],
      ),
      drawer: Drawer(),
      body: EventScreen(),
      // floatingActionButton: IconButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(AddBirthday.routeName);
      //   },
      // ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Colors.green,
        height:50,
        top: -30,
        curveSize: 75,
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.calendar_today_rounded, title: 'Calender'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.photo_album_rounded, title: 'Frames'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: selectedTab,
        //optional, default as 0
        onTap: (tab) {
        setState(() {
        selectedTab = tab;
        });
      },
      ),
    );
  }
}
// Widget tabsWidget(int selectedTab) {
//   switch (selectedTab) {
//     case 0:
//       return TaskWidget();
//     //
//     // case 1:
//     //   return CategoryPage();
//
//     case 2:
//       return EventScreen();
//
//     // case 4:
//     //   return UserProfile();
//
//     default:
//       return HomePage();
//   }
// }
//
//
