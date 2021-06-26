import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/services/google_calender_repository.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/services/message_handler.dart';
import 'package:yday/testfile.dart';

import '../all_event_screen.dart';
import 'edit_birthday_screen.dart';

class BirthdayDetailScreen extends StatefulWidget {
  static const routeName = '/birthday-detail-screen';

  @override
  _BirthdayDetailScreenState createState() => _BirthdayDetailScreenState();
}

class _BirthdayDetailScreenState extends State<BirthdayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final birthdayId = ModalRoute.of(context).settings.arguments as String;
    final loadedBirthday =
        Provider.of<Birthdays>(context, listen: false).findById(birthdayId);
    Color _categoryColor = categoryColor(loadedBirthday.categoryofPerson);
    int daysLeftforBirthday;
    bool isToday = false;
    bool phoneNumber = loadedBirthday.phoneNumberofPerson.isNotEmpty;
    int getAge() {
      DateTime b;
      var dtnow = DateTime.now();
      var dt = loadedBirthday.dateofbirth;
      b = DateTime.utc(dtnow.year, dt.month, dt.day);
      Duration years;
      if (dt.year == dtnow.year &&
          dt.month == dtnow.month &&
          dt.day == dtnow.day) {
        isToday = true;
      }
      if (b.isAfter(dtnow)) {
        years = b.difference(dtnow);
        daysLeftforBirthday = years.inDays;
      } else {
        years = dtnow.difference(b);
        daysLeftforBirthday = 365 - years.inDays;
      }
      // print(years.inDays+1);
      return daysLeftforBirthday;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YourDay',
          style: TextStyle(
            // fontFamily: "Kaushan Script",
            fontSize: 28,
          ),
        ),
        // centerTitle: true,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBirthdayScreen(
                          loadedBirthday
                      ))), icon: Icon(Icons.edit)),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Delete this birthday'),
                  content: Text(
                      'Are you sure you want to delete this Birthday permanently?'),
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
                        String str = DateFormat('ddyyhhmm')
                            .format(loadedBirthday.dateofbirth);
                        int dtInt= int.parse(str);
                        await NotificationsHelper.cancelNotification(dtInt);
                        // if (loadedBirthday.calenderId != null) {
                        //   GoogleSignInAccount account =
                        //       Provider.of<GoogleAccountRepository>(context,
                        //               listen: false)
                        //           .googleSignInAccount;
                        //   CalendarClient cal = CalendarClient();
                        //   await cal.deleteEvent(
                        //       account, loadedBirthday.calenderId);
                        // }
                        Provider.of<Birthdays>(context, listen: false)
                            .completeEvent(birthdayId);

                        Navigator.of(context).pushReplacementNamed(
                            AllBirthdayScreen.routeName);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
              Text(
                'Birthday Details',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: loadedBirthday.imageUrl == null?AssetImage('assets/images/userimage.png')
                          :loadedBirthday.gender==null? AssetImage('assets/images/userimage.png')
                          :loadedBirthday.gender == 'Male'? AssetImage('assets/images/bday_male_placeholder.jpeg'):loadedBirthday.gender == 'Female'? AssetImage('assets/images/bday_female_placeholder.jpeg'):NetworkImage(loadedBirthday.imageUrl),
                      radius: MediaQuery.of(context).size.width * 0.18,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                    Column(
                      children: [
                        Chip(
                          label: Text(
                            categoryText(loadedBirthday.categoryofPerson),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          backgroundColor: _categoryColor,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                        Text(getAge() != 0 && isToday
                            ? 'Today'
                            : '${getAge().toString()} days left'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>FestivalImageScreen(festivalId: 'uPH2o2eH5rxai7msQ7yi',year: DateTime.now().year.toString(),)));

                // Navigator.of(context).pushNamed(FestivalImageScreen.routeName,arguments: 'uPH2o2eH5rxai7msQ7yi');
                //
                //V3ul6xRpnzqHw5LRMm2A

              }, child: Text('Send Wishes',style: TextStyle(
                fontSize: 18
              ),),style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor,
                minimumSize: Size(MediaQuery.of(context).size.width*0.8,45)
              ),
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(phoneNumber)
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Theme.of(context).primaryColor,
                      // size: 10,
                    ),
                    onPressed: () async {
                      String phoneNumber =
                          loadedBirthday.phoneNumberofPerson;
                      String url = 'tel:$phoneNumber';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  if(phoneNumber)
                    IconButton(
                      icon:
                        FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),                        color: Theme.of(context).primaryColor,
                        // size: 10,
                      onPressed: () async {
                        String phoneNumber =
                            loadedBirthday.phoneNumberofPerson;
                        var whatsappUrl ="whatsapp://send?phone=+91$phoneNumber";
                        if (await canLaunch(whatsappUrl)) {
                          await launch(whatsappUrl);
                        } else {
                          throw 'Could not launch $whatsappUrl';
                        }
                      },
                    ),
                  if(phoneNumber)
                    IconButton(
                    icon: Icon(
                      Icons.message,
                      color: Theme.of(context).primaryColor,
                      // size: 10,
                    ),
                    onPressed: () async {
                      String phoneNumber =
                          loadedBirthday.phoneNumberofPerson;
                      String url = 'sms:$phoneNumber';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  if(loadedBirthday.emailofPerson.isNotEmpty)
                    IconButton(
                    icon: Icon(
                      Icons.email_rounded,
                      color: Theme.of(context).primaryColor,
                      // size: 10,
                    ),
                    onPressed: () async {
                      String email =
                          loadedBirthday.emailofPerson;
                      String url = 'mailto:$email';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Name',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.nameofperson,
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_pin_circle_sharp,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Gender',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.gender,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Birth Date',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: loadedBirthday.yearofBirthProvidedStatus
                    ? Text(
                        DateFormat('EEEE, MMM dd, yyyy')
                            .format(loadedBirthday.dateofbirth),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(DateFormat('EEEE, MMM dd')
                        .format(loadedBirthday.dateofbirth)),
              ),
              ListTile(
                leading: Icon(
                  Icons.watch_later_outlined,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Event Time',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: loadedBirthday.setAlarmforBirthday != null
                    ? Text(
                        loadedBirthday.setAlarmforBirthday.format(context),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      )
                    : Text('None'),
              ),
              ListTile(
                leading: Icon(
                  Icons.insert_emoticon_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Zodiac Sign',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.zodiacSign,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.phone_android_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Phone',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.phoneNumberofPerson.isNotEmpty
                      ? loadedBirthday.phoneNumberofPerson
                      : 'None',
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.email_outlined,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Email',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.emailofPerson.isNotEmpty
                      ? loadedBirthday.emailofPerson
                      : 'None',
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.note_outlined,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Notes',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedBirthday.notes.isNotEmpty
                      ? loadedBirthday.notes
                      : 'None',
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite_border_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Interests',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: (loadedBirthday.interestsofPerson == null ||
                        loadedBirthday.interestsofPerson.isEmpty)
                    ? Container(
                        child: Text('None'),
                      )
                    : Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return InterestOfPerson(loadedBirthday
                                .interestsofPerson[i].name
                                .toString());
                          },
                          itemCount: loadedBirthday.interestListSize(),
                          shrinkWrap: true,
                          dragStartBehavior: DragStartBehavior.start,
                          physics: ClampingScrollPhysics(),
                          //padding: const EdgeInsets.all(10),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InterestOfPerson extends StatelessWidget {
  String _interestOfPerson;

  InterestOfPerson(this._interestOfPerson);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        backgroundColor: Colors.amber,
        label: Text(
          _interestOfPerson,
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
