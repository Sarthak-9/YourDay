import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/add_anniversary.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/add_task.dart';
import 'package:yday/screens/all_event_screen.dart';
import 'package:yday/screens/anniversary_detail.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/screens/auth/signup_page.dart';
import 'package:yday/screens/birthday_detail_screen.dart';
import 'package:yday/screens/calender.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/screens/task_detail_screen.dart';
import 'package:yday/screens/todays_events.dart';
import 'package:yday/testfile.dart';
import './screens/homepage.dart';
import './providers/tasks.dart';
import 'models/calenderId.dart';
import 'widgets/add_popover_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs= await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers :[
          ChangeNotifierProvider(
          create: (ctx)=> Tasks(),),
          ChangeNotifierProvider(
            create: (ctx)=> Birthdays(),
          ),
          ChangeNotifierProvider(create: (ctx)=> Anniversaries(),),
          ChangeNotifierProvider(create: (ctx)=> UserData(),),
        ] ,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Constants.prefs.getBool("loggedIn")==true? HomePage() : LoginPage(),
            routes: {
              LoginPage.routename:(ctx)=> LoginPage(),
              SignUp.routename: (ctx)=> SignUp(),
              HomePage.routeName: (ctx)=> HomePage(),
              EventScreen.routeName :(ctx)=>EventScreen(),
              AddBirthday.routeName: (ctx)=>AddBirthday(),
              BirthdayDetailScreen.routeName : (ctx)=> BirthdayDetailScreen(),
              AddAnniversary.routeName: (ctx)=> AddAnniversary(),
              AnniversaryDetailScreen.routeName: (ctx)=> AnniversaryDetailScreen(),
              AddTask.routeName: (ctx)=> AddTask(),
              TaskDetailScreen.routeName: (ctx)=> TaskDetailScreen(),
              TodaysEventScreen.routeName: (ctx)=> TodaysEventScreen(),
              AllEvents.routeName: (ctx) => AllEvents(),
            },
            theme: ThemeData(
              primaryColor: const Color(0xFF305496),
              fontFamily: 'Lato',
              accentColor: Colors.amber,
              //canvasColor: Colors.green,
              highlightColor: Colors.lightBlueAccent,

              //cardColor: Colors.green,
              // disabledColor: Colors.red,
              // chipTheme: ChipThemeData(
              //   backgroundColor: Colors.grey,
              // ),
            ),
          ),
       // ),
      //);}
    );
  }
}
