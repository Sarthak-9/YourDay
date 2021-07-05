import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
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
import '../homepage.dart';
import 'edit_anniversary_screen.dart';

class AnniversaryDetailScreen extends StatefulWidget {
  // static const routeName = '/anniversary-detail-screen';
  String anniversaryId;

  AnniversaryDetailScreen(this.anniversaryId);

  @override
  _AnniversaryDetailScreenState createState() =>
      _AnniversaryDetailScreenState();
}

class _AnniversaryDetailScreenState extends State<AnniversaryDetailScreen> {
  ConfettiController _controllerCenter;
  StreamController<Duration> durationStreamController =
      StreamController<Duration>.broadcast();
  Stream<Duration> durationStream;
  StreamSink<Duration> durationStreamSink;
  Anniversary loadedAnniversary;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    loadedAnniversary = Provider.of<Anniversaries>(context, listen: false)
        .findById(widget.anniversaryId);
    durationStream = durationStreamController.stream;
    durationStreamSink = durationStreamController.sink;
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime dt = loadedAnniversary.dateofanniversary;
      DateTime dtnow = DateTime.now();
      if (dt.isAfter(dtnow)) {
        dt = loadedAnniversary.dateofanniversary;
      } else {
        if (loadedAnniversary.dateofanniversary.isBefore(dtnow)) {
          dt = DateTime(dtnow.year, loadedAnniversary.dateofanniversary.month,
              loadedAnniversary.dateofanniversary.day);
        }
        if (dt.isBefore(dtnow)) {
          dt = DateTime(
              dtnow.year + 1,
              loadedAnniversary.dateofanniversary.month,
              loadedAnniversary.dateofanniversary.day);
        }
      }
      Duration timeLeft;
      DateTime diff;
      timeLeft = dt.difference(dtnow);
      durationStreamSink.add(timeLeft);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final anniversaryId = ModalRoute.of(context).settings.arguments as String;
    Color _categoryColor = categoryColor(loadedAnniversary.categoryofCouple);
    int daysLeftforAnniversary;
    DateTime dtnow = DateTime.now();
    bool isToday = loadedAnniversary.dateofanniversary.month == dtnow.month &&
        loadedAnniversary.dateofanniversary.day == dtnow.day;
    if (isToday) {
      _controllerCenter =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerCenter.play();
    }
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
        title: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
            child: Image.asset(
              "assets/images/Main_logo.png",
              height: 60,
              width: 100,
            )),
        titleSpacing: 0.1,
        centerTitle: true,
        // centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditAnniversaryScreen(loadedAnniversary))),
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
                        await NotificationsHelper.cancelNotification(
                            loadedAnniversary.notifId);
                        Provider.of<Anniversaries>(context, listen: false)
                            .completeEvent(widget.anniversaryId);
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor,width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Column(
                  children: [
                    // Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    // Text(
                    //   'Anniversary Details',
                    //   style: TextStyle(
                    //     fontSize: 24.0,
                    //   ),
                    // ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/anniversary_background.jpeg'),
                        Positioned(
                          top: 30,
                          // bottom: ,
                          child: CircleAvatar(
                            backgroundImage: loadedAnniversary.imageUrl == null
                                ? AssetImage('assets/images/anniversary_logo.png')
                                : NetworkImage(loadedAnniversary.imageUrl),
                            radius: MediaQuery.of(context).size.width * 0.14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //jSmV4mdruiu9rH5YhEHF
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FestivalImageScreen(
                                  festivalId: 'jSmV4mdruiu9rH5YhEHF',
                                  year: DateTime.now().year.toString(),
                                )));
                      },
                      child: Text(
                        'Send Wishes',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width * 0.8, 45)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (phoneNumber)
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
                        if (phoneNumber)
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                            color: Theme.of(context).primaryColor,
                            // size: 10,
                            onPressed: () async {
                              String phoneNumber =
                                  loadedAnniversary.phoneNumberofCouple;
                              if (!phoneNumber.contains('+91')) {
                                phoneNumber = '+91' + phoneNumber;
                              }
                              var whatsappUrl =
                                  "whatsapp://send?phone=$phoneNumber";
                              if (await canLaunch(whatsappUrl)) {
                                await launch(whatsappUrl);
                              } else {
                                throw 'Could not launch $whatsappUrl';
                              }
                            },
                          ),
                        if (phoneNumber)
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
                        if (loadedAnniversary.emailofCouple.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.email_rounded,
                              color: Theme.of(context).primaryColor,
                              // size: 10,
                            ),
                            onPressed: () async {
                              String email = loadedAnniversary.emailofCouple;
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            loadedAnniversary.husband_name +
                                ' - ' +
                                loadedAnniversary.wife_name,
                            //textScaleFactor: 1.4,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          loadedAnniversary.yearofmarriageProvided
                              ? Text(
                                  DateFormat('EEEE, MMM dd, yyyy').format(
                                      loadedAnniversary.dateofanniversary),
                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text(DateFormat('EEEE, MMM dd')
                                  .format(loadedAnniversary.dateofanniversary)),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: StreamBuilder<Duration>(
                          stream: durationStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // Column(
                                      //   children: [
                                      //     Text(
                                      //       'Months',
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 16),
                                      //     ),
                                      //     SizedBox(
                                      //       height: 10,
                                      //     ),
                                      //     Text(snapshot.data.month.toString())
                                      //   ],
                                      // ),
                                      Column(
                                        children: [
                                          Text(
                                            'Days',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(snapshot.data.inDays.toString())
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Hours',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(snapshot.data.inHours
                                              .remainder(24)
                                              .toString())
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Minutes',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(snapshot.data.inMinutes
                                              .remainder(60)
                                              .toString())
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Seconds',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(snapshot.data.inSeconds
                                              .remainder(60)
                                              .toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else
                              return Container();
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category :',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Notification Time :',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryText(loadedAnniversary.categoryofCouple),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            loadedAnniversary.dateofanniversary != null
                                ? Text(
                                    DateFormat('HH : mm').format(
                                        loadedAnniversary.dateofanniversary),
                                    //textScaleFactor: 1.4,

                                    style: TextStyle(fontSize: 20),
                                    //textScaleFactor: 1.4,
                                    textAlign: TextAlign.start,
                                    // overflow: TextOverflow.ellipsis,
                                    // maxLines: 5,
                                  )
                                : Text(
                                    'None',
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (loadedAnniversary.interestsofCouple != null &&
                        loadedAnniversary.interestsofCouple.isEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Interest :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),

                    if (loadedAnniversary.interestsofCouple != null &&
                        loadedAnniversary.interestsofCouple.isEmpty)
                      Container(
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
                    if (loadedAnniversary.notes != null &&
                        loadedAnniversary.notes.isEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          loadedAnniversary.notes,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    //
                  ],
                ),
              ),
            ),
          ),
          if (isToday)
            ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Color(0xFF305496),
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar,
            ),
        ],
      ),
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
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
