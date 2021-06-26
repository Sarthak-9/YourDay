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
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/anniversaries/all_anniversary_screen.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/services/google_calender_repository.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/services/message_handler.dart';
import 'package:yday/testfile.dart';

import '../all_event_screen.dart';
import 'edit_anniversary_screen.dart';

class AnniversaryDetailScreen extends StatefulWidget {
  static const routeName = '/anniversary-detail-screen';

  @override
  _AnniversaryDetailScreenState createState() =>
      _AnniversaryDetailScreenState();
}

class _AnniversaryDetailScreenState extends State<AnniversaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final anniversaryId = ModalRoute.of(context).settings.arguments as String;
    final loadedAnniversary = Provider.of<Anniversaries>(context, listen: false)
        .findById(anniversaryId);
    Color _categoryColor = categoryColor(loadedAnniversary.categoryofCouple);
    int daysLeftforAnniversary;
    bool isToday = false;
    bool phoneNumber = loadedAnniversary.phoneNumberofCouple.isNotEmpty;
    int getAge() {
      DateTime b;
      var dtnow = DateTime.now();
      var dt = loadedAnniversary.dateofanniversary;
      b = DateTime.utc(dtnow.year, dt.month, dt.day);
      Duration years;
      if (dt.year == dtnow.year &&
          dt.month == dtnow.month &&
          dt.day == dtnow.day) {
        isToday = true;
      }
      if (b.isAfter(dtnow)) {
        years = b.difference(dtnow);
        daysLeftforAnniversary = years.inDays;
      } else {
        years = dtnow.difference(b);
        daysLeftforAnniversary = 365 - years.inDays;
      }
      // print(years.inDays+1);
      return daysLeftforAnniversary;
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
              onPressed: () =>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditAnniversaryScreen(
                          loadedAnniversary))),
              icon: Icon(Icons.edit)),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Delete the Anniversary'),
                  content: Text('Are you sure you want to delete ?'),
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
                            .format(loadedAnniversary.dateofanniversary);
                        int dtInt= int.parse(str);
                        await NotificationsHelper.cancelNotification(dtInt);
                        Provider.of<Anniversaries>(context, listen: false)
                            .completeEvent(anniversaryId);
                        Navigator.of(context).pushReplacementNamed(
                            AllAnniversaryScreen.routeName);
                      },
                    )
                  ],
                ),
              );
              // Provider.of<Anniversaries>(context,listen: false).completeEvent(anniversaryId);
              // Navigator.of(context).pop();
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
                'Anniversary Details',
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
                      backgroundImage: loadedAnniversary.imageUrl == null
                          ? AssetImage('assets/images/anniversary_placeholder.jpeg')
                          : NetworkImage(loadedAnniversary.imageUrl),
                      radius: MediaQuery.of(context).size.width * 0.18,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                    Column(
                      children: [
                        Chip(
                          label: Text(
                            categoryText(loadedAnniversary.categoryofCouple),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          backgroundColor: _categoryColor,
                        ),
                        Text(getAge() != 0 && isToday
                            ? 'Today'
                            : '${getAge().toString()} days left'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){//jSmV4mdruiu9rH5YhEHF
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>FestivalImageScreen(festivalId: 'jSmV4mdruiu9rH5YhEHF',year: DateTime.now().year.toString(),)));

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
                            loadedAnniversary.phoneNumberofCouple;
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
                      FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),
                      color: Theme.of(context).primaryColor,
                      // size: 10,
                      onPressed: () async {
                        String phoneNumber =
                            loadedAnniversary.phoneNumberofCouple;
                        if(!phoneNumber.contains('+91')) {
                          phoneNumber = '+91' + phoneNumber;
                        }
                        var whatsappUrl ="whatsapp://send?phone=$phoneNumber";
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
                            loadedAnniversary.phoneNumberofCouple;
                        String url = 'sms:$phoneNumber';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  if(loadedAnniversary.emailofCouple.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.email_rounded,
                        color: Theme.of(context).primaryColor,
                        // size: 10,
                      ),
                      onPressed: () async {
                        String email =
                            loadedAnniversary.emailofCouple;
                        String url = 'mailto:$email';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                ],
              ),              ListTile(
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Husband\'s Name',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedAnniversary.husband_name,
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Wife\'s Name',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: Text(
                  loadedAnniversary.wife_name,
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.supervisor_account_rounded,
              //     color: _categoryColor,
              //     size: 28.0,
              //   ),
              //   title: Text(
              //     'Relation',
              //     textAlign: TextAlign.left,
              //     textScaleFactor: 1.3,
              //     style: TextStyle(
              //       color: _categoryColor,
              //     ),
              //   ),
              //   subtitle: Text(
              //     loadedAnniversary.relation,
              //     //textScaleFactor: 1.4,
              //     textAlign: TextAlign.start,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Anniversary Date',
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),
                ),
                subtitle: loadedAnniversary.yearofmarriageProvided
                    ? Text(
                        DateFormat('EEEE, MMM dd, yyyy')
                            .format(loadedAnniversary.dateofanniversary),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(DateFormat('MMM dd')
                        .format(loadedAnniversary.dateofanniversary)),
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
                subtitle: loadedAnniversary.setAlarmforAnniversary != null
                    ? Text(
                        loadedAnniversary.setAlarmforAnniversary
                            .format(context),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text('None'),
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
                  loadedAnniversary.notes.isNotEmpty
                      ? loadedAnniversary.notes
                      : 'None',
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
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
                // trailing: loadedAnniversary.phoneNumberofCouple.isNotEmpty
                //     ? SizedBox(
                //         width: 100,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             IconButton(
                //               icon: Icon(
                //                 Icons.call,
                //                 color: Theme.of(context).primaryColor,
                //               ),
                //               onPressed: () async {
                //                 String phoneNumber =
                //                     loadedAnniversary.phoneNumberofCouple;
                //                 String url = 'tel:$phoneNumber';
                //                 if (await canLaunch(url)) {
                //                   await launch(url);
                //                 } else {
                //                   throw 'Could not launch $url';
                //                 }
                //               },
                //             ),
                //             IconButton(
                //               icon: Icon(
                //                 Icons.message,
                //                 color: Theme.of(context).primaryColor,
                //               ),
                //               onPressed: () async {
                //                 String phoneNumber =
                //                     loadedAnniversary.phoneNumberofCouple;
                //                 String url = 'sms:$phoneNumber';
                //                 if (await canLaunch(url)) {
                //                   await launch(url);
                //                 } else {
                //                   throw 'Could not launch $url';
                //                 }
                //               },
                //             ),
                //           ],
                //         ),
                //       )
                //     : SizedBox(),
                subtitle: Text(
                  loadedAnniversary.phoneNumberofCouple.isNotEmpty
                      ? loadedAnniversary.phoneNumberofCouple
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
                // trailing: loadedAnniversary.emailofCouple.isNotEmpty
                //     ? IconButton(
                //         icon: Icon(
                //           Icons.email_rounded,
                //           color: Theme.of(context).primaryColor,
                //           // size: 10,
                //         ),
                //         onPressed: () async {
                //           String email = loadedAnniversary.emailofCouple;
                //           String url = 'mailto:$email';
                //           if (await canLaunch(url)) {
                //             await launch(url);
                //           } else {
                //             throw 'Could not launch $url';
                //           }
                //         },
                //       )
                //     : SizedBox(),
                subtitle: Text(
                  loadedAnniversary.emailofCouple.isNotEmpty
                      ? loadedAnniversary.emailofCouple
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
                subtitle: (loadedAnniversary.interestsofCouple == null ||
                        loadedAnniversary.interestsofCouple.isEmpty)
                    ? Container(
                        child: Text('None'),
                      )
                    : Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return InterestOfPerson(loadedAnniversary
                                .interestsofCouple[i].name
                                .toString());
                          },
                          itemCount: loadedAnniversary.interestListSize(),
                          shrinkWrap: true,
                          dragStartBehavior: DragStartBehavior.start,
                          physics: ClampingScrollPhysics(),
                          //padding: const EdgeInsets.all(10),
                        ),
                      ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}

class InterestOfPerson extends StatelessWidget {
  String _interestOfCouple;

  InterestOfPerson(this._interestOfCouple);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        backgroundColor: Colors.amber,
        label: Text(
          _interestOfCouple,
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
