import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/screens/anniversaries/all_anniversary_screen.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/screens/auth/user_account.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/frames/all_festivals_screen.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/screens/tasks/all_task_screen.dart';
import 'package:yday/services/google_signin_repository.dart';

class MainDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final  statusBarHeight = MediaQuery.of(context).padding.top;
    var currentUser = Provider.of<UserData>(context, listen: false).userData;
    return Drawer(
      child: Container(
        // color: Colors.blue,
        padding:  EdgeInsets.symmetric(vertical: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   height: statusBarHeight,
              //   color: Theme.of(context).primaryColor,
              // ),
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: currentUser.profilePhotoLink != null
                      ? NetworkImage(currentUser.profilePhotoLink)
                      : AssetImage('assets/images/userimage.png'),
                ),

                accountName: Text(currentUser.userName,
                  style: TextStyle(fontSize: 18),),
                accountEmail: Text(currentUser.userEmail,
                  style: TextStyle(fontSize: 15),),
                onDetailsPressed: () => Navigator.of(context)
                    .pushNamed(UserAccountScreen.routeName),

                // decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Colors.green, Colors.lightGreen
                //       ],
                //     )
                // ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home_rounded,
                  size: 30,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                tabNumber: 0,
                              )));
                },
              ),
              // Divider(),
              ListTile(
                leading: SizedBox(height: 30,width: 30,child: Image.asset('assets/images/anniversary.png'),),
                title: Text(
                  "Anniversaries",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AllAnniversaryScreen.routeName);
                },
              ),
              ListTile(
                leading: SizedBox(height: 30,width: 30,child: Image.asset('assets/images/cake.png'),),
                title: Text(
                  "Birthdays",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AllBirthdayScreen.routeName);
                },
              ),
              ListTile(
                leading: SizedBox(height: 30,width: 30,child: Image.asset('assets/images/completed-task.png'),),
                title: Text(
                  "Tasks",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AllTaskScreen.routeName);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Text(
                    'F',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  "Festivals",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AllFestivalScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.account_circle_rounded,
                  size: 30,
                ),
                title: Text(
                  "My Account",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () => Navigator.of(context)
                    .pushNamed(UserAccountScreen.routeName),
              ),
              ListTile(
                leading: Icon(
                  Icons.email_rounded,
                  size: 28,
                ),
                title: Text(
                  "Help and Feedback",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  size: 28,
                ),
                title: Text(
                  "Share",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 28,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () => logoutUser(context),
              ),
              AboutListTile(
                applicationName: 'YourDay',
                icon: Icon(
                  Icons.info_outline,
                  size: 28,
                ),
                applicationLegalese:
                    'This Application is designed and developed by YourDay.',
                applicationVersion: '1.0.0+1',
                child: Text(
                  'About',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    bool _logOut = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out'),
        content: Text('Are you sure you want to logout?'),
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
              _logOut = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if (_logOut) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await Provider.of<GoogleAccountRepository>(context, listen: false).googleLogout();
      await _auth.signOut();
      Provider.of<UserEvents>(context, listen: false).userEventList.clear();

      await storage.write(key: "signedIn", value: "false");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
    }
  }
}
