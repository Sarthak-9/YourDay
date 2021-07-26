import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/screens/anniversaries/add_anniversary.dart';
import 'package:yday/screens/anniversaries/all_anniversary_screen.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/tasks/add_task.dart';
import 'package:yday/screens/anniversaries/anniversary_detail.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/screens/auth/signup_page.dart';
import 'package:yday/screens/auth/user_edit_profile_screen.dart';
import 'package:yday/screens/birthdays/birthday_detail_screen.dart';
import 'package:yday/screens/calender.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/screens/photos/photo_screen.dart';
import 'package:yday/screens/tasks/all_task_screen.dart';
import 'package:yday/screens/tasks/task_detail_screen.dart';
import 'package:yday/services/google_signin_repository.dart';
import './screens/homepage.dart';
import './providers/tasks.dart';
import 'providers/frames/festivals.dart';
import 'screens/anniversaries/edit_anniversary_screen.dart';
import 'screens/auth/user_account.dart';
import 'screens/birthdays/edit_birthday_screen.dart';
import 'screens/frames/add_frames_category_screen.dart';
import 'screens/frames/add_images_to_category.dart';
import 'screens/frames/all_festivals_screen.dart';
import 'screens/frames/edit_frame_screen.dart';
import 'screens/userevents/add_images_to_user_events.dart';
import 'screens/userevents/add_user_event_screen.dart';
import 'screens/userevents/full_image_screen.dart';
import 'screens/userevents/user_all_events_screen.dart';
import 'services/message_handler.dart';
bool signin = false;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;
String initialRoute = HomePage.routeName1;//MaterialPageRoute(builder: (ctx)=> HomePage(tabNumber: 1,)) as String;
int initialPage = 0;
bool openNotification = false;
Future<void> main() async {
  final storage = new FlutterSecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
  signin = await storage.read(key: "signedIn") == "true" ? true : false;
  await Firebase.initializeApp();
  await NotificationsHelper.init();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails.didNotificationLaunchApp == false) {
    openNotification = false;
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = HomePage.routeName;// MaterialPageRoute(builder: (ctx)=> HomePage(tabNumber: 1,)) as String;
    initialPage = 0;
  }else{
    openNotification = true;
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = HomePage.routeName1;
    initialPage = 0;
  }

  // const AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('@mipmap/ic_launcher');
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //       if (payload != null) {
  //         debugPrint('notification payload: $payload');
  //       }
  //       selectedNotificationPayload = payload;
  //       selectNotificationSubject.add(payload);
  //     });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return MultiProvider(
        providers :[
          ChangeNotifierProvider(
          create: (ctx)=> Tasks(),),
          ChangeNotifierProvider(
            create: (ctx)=> Birthdays(),
          ),
          ChangeNotifierProvider(create: (ctx)=> Anniversaries(),),
          ChangeNotifierProvider(create: (ctx)=> Festivals(),),
          ChangeNotifierProvider(create: (ctx)=>UserEvents()),
          ChangeNotifierProvider(create: (ctx)=>UserData()),
          // ChangeNotifierProvider(create: (ctx)=>NotificationsHelper()),
          ChangeNotifierProvider(create: (ctx)=> GoogleAccountRepository())
        ] ,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CheckLogin(),//AddPhotoScreen(),//
            routes: {
              LoginPage.routename:(ctx)=> LoginPage(),
              SignUp.routename: (ctx)=> SignUp(),
              UserAccountScreen.routeName:(ctx)=>UserAccountScreen(),
              HomePage.routeName: (ctx)=> HomePage(tabNumber: 0,),
              HomePage.routeName1:(ctx)=> HomePage(tabNumber: 1,),
              HomePage.routeName2:(ctx)=> HomePage(tabNumber: 2,),
              AllFestivalScreen.routeName :(ctx)=>AllFestivalScreen(),
              AddBirthday.routeName: (ctx)=>AddBirthday(),
              AddAnniversary.routeName: (ctx)=> AddAnniversary(),
              // AnniversaryDetailScreen.routeName: (ctx)=> AnniversaryDetailScreen(),
              AddTask.routeName: (ctx)=> AddTask(),
              // TaskDetailScreen.routeName: (ctx)=> TaskDetailScreen(),
              // AllEvents.routeName: (ctx) => AllEvents(),
              AllBirthdayScreen.routeName:(ctx) => AllBirthdayScreen(),
              AllAnniversaryScreen.routeName:(ctx)=>AllAnniversaryScreen(),
              AllTaskScreen.routeName:(ctx)=> AllTaskScreen(),
              FestivalImageScreen.routeName: (ctx) => FestivalImageScreen(),
              AddUserEventScreen.routeName: (ctx) => AddUserEventScreen(),
              UserAllEventsScreen.routeName: (ctx) => UserAllEventsScreen(),
              UserAccountEditScreen.routename: (ctx) => UserAccountEditScreen(),
              FullImageScreen.routename:(ctx)=> FullImageScreen(),
              AddImageToEventScreen.routeName:(ctx) => AddImageToEventScreen(),
              AddFramesCategoryScreen.routeName:(ctx)=>AddFramesCategoryScreen(),
              AddImagesToCategoryScreen.routeName:(ctx)=>AddImagesToCategoryScreen(),
              // EditAnniversaryScreen.routeName:(ctx)=>EditAnniversaryScreen(),

            },
            // initialRout,
            theme: ThemeData(
              primaryColor: const Color(0xFF305496),
              fontFamily: 'Lato',
              accentColor: Colors.amber,
              //canvasColor: Colors.green,
              highlightColor: Colors.lightBlueAccent,
            ),
          ),
       // ),
      //);}
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key key}) : super(key: key);

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  bool isLoading = true;
  var route;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) => fetch());
    // fetch();
    super.initState();
  }
  void fetch() async {
    // await Provider.of<UserData>(context, listen: false).fetchUser().then((value) => print('22'));
    await Provider.of<UserData>(context, listen: false).fetchUser();
    if(signin){
      await Provider.of<GoogleAccountRepository>(context, listen: false)
          .loginWithGoogle();
      // await Provider.of<Festivals>(context, listen: false).fetchFestival();
    }
    if(openNotification){
      await checkNotifOpen();
    }
    // Future.delayed(Duration.zero).then((value) => print(1));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkNotifOpen()async{
    if(selectedNotificationPayload.startsWith('birthday')){
      List<String> split = selectedNotificationPayload.split('birthday');
      await Provider.of<Birthdays>(context, listen: false).fetchBirthday();
      route =BirthdayDetailScreen(split[1]);
    }else if(selectedNotificationPayload.startsWith('anniversary')){
      List<String> split = selectedNotificationPayload.split('anniversary');
      await Provider.of<Anniversaries>(context, listen: false)
          .fetchAnniversary();
      route =AnniversaryDetailScreen(split[1]);
    }else if(selectedNotificationPayload.startsWith('task')){
      List<String> split = selectedNotificationPayload.split('task');
      await Provider.of<Tasks>(context, listen: false).fetchTask();
      route =TaskDetailScreen(split[1]);
    }else if(selectedNotificationPayload.startsWith('selfbirthday')){
      // List<String> split = selectedNotificationPayload.split('selfbirthday');
      // await Provider.of<Tasks>(context, listen: false).fetchTask();
      route =UserAccountScreen();
    }else{
      route = HomePage(tabNumber: 1,);
    }
    await Provider.of<Festivals>(context, listen: false).fetchFestival();
  }
  @override
  Widget build(BuildContext context) {
    return  isLoading ? Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(16.0),
        child: Image.asset("assets/images/Main_logo.png"),):signin==true?openNotification?route:HomePage(tabNumber: initialPage,) : LoginPage();
    }
}
