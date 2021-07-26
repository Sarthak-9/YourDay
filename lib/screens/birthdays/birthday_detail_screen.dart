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
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/services/google_calender_repository.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/services/message_handler.dart';
import 'package:yday/testfile.dart';
import '../homepage.dart';
import 'edit_birthday_screen.dart';

class BirthdayDetailScreen extends StatefulWidget {
  // static const routeName = '/birthday-detail-screen';
  String birthdayId;

  BirthdayDetailScreen(this.birthdayId);

  @override
  _BirthdayDetailScreenState createState() => _BirthdayDetailScreenState();
}

class _BirthdayDetailScreenState extends State<BirthdayDetailScreen> {
  ConfettiController _controllerCenter;
  StreamController<Duration> durationStreamController =
      StreamController<Duration>.broadcast();
  Stream<Duration> durationStream;
  StreamSink<Duration> durationStreamSink;

  BirthDay loadedBirthday;
  // @override
  // void initState() {
  //   _controllerCenter =
  //       ConfettiController(duration: const Duration(seconds: 10));
  //   _controllerCenter.play();
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // birthdayId = ModalRoute.of(context).settings.arguments as String;
    loadedBirthday = Provider.of<Birthdays>(context, listen: false)
        .findById(widget.birthdayId);
    durationStream = durationStreamController.stream;
    durationStreamSink = durationStreamController.sink;
    // durationStream = Stream.periodic(timeLeft);
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime dt = loadedBirthday.dateofbirth;
      DateTime dtnow = DateTime.now();
      if (dt.isAfter(dtnow)) {
        dt = loadedBirthday.dateofbirth;
      } else {
        if (loadedBirthday.dateofbirth.isBefore(dtnow)) {
          dt = DateTime(dtnow.year, loadedBirthday.dateofbirth.month,
              loadedBirthday.dateofbirth.day);
        }
        if (dt.isBefore(dtnow)) {
          dt = DateTime(dtnow.year + 1, loadedBirthday.dateofbirth.month,
              loadedBirthday.dateofbirth.day);
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
  void dispose() {
    // TODO: implement dispose
    durationStreamSink.done;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dtnow = DateTime.now();
    bool isToday = loadedBirthday.dateofbirth.month == dtnow.month &&
        loadedBirthday.dateofbirth.day == dtnow.day;
    bool phoneNumber = loadedBirthday.phoneNumberofPerson.isNotEmpty;
    if (isToday) {
      _controllerCenter =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerCenter.play();
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
                          EditBirthdayScreen(loadedBirthday))),
              icon: Icon(Icons.edit)),
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
                        await NotificationsHelper.cancelNotification(
                            loadedBirthday.notifId);
                        Provider.of<Birthdays>(context, listen: false)
                            .completeEvent(widget.birthdayId);
                        Navigator.of(context)
                            .pushReplacementNamed(AllBirthdayScreen.routeName);
                      },
                    )
                  ],
                ),
              );
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/birthday_background.jpeg'),
                        Positioned(
                          top: 30,
                          // bottom: ,
                          child: CircleAvatar(
                            backgroundImage: loadedBirthday.imageUrl != null
                                ? NetworkImage(loadedBirthday.imageUrl)
                                : loadedBirthday.gender == null
                                    ? AssetImage('assets/images/userimage.png')
                                    : loadedBirthday.gender == 'Male'
                                        ? AssetImage(
                                            'assets/images/bday_male_placeholder.jpeg')
                                        : loadedBirthday.gender == 'Female'
                                            ? AssetImage(
                                                'assets/images/bday_female_placeholder.jpeg')
                                            : AssetImage(
                                                'assets/images/userimage.png'),
                            radius: MediaQuery.of(context).size.width * 0.14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FestivalImageScreen(
                                  festivalId: 'y1LJ9lNBEFVOnjXpjAiN',
                                  year: DateTime.now().year.toString(),
                                )));

                        // Navigator.of(context).pushNamed(FestivalImageScreen.routeName,arguments: 'uPH2o2eH5rxai7msQ7yi');
                        //
                        //V3ul6xRpnzqHw5LRMm2A
                      },
                      child: Text(
                        'Send Wishes',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.8, 45)),
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
                                  loadedBirthday.phoneNumberofPerson;
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
                                  loadedBirthday.phoneNumberofPerson;
                              print(phoneNumber);
                              String whatsappUrl =
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
                                  loadedBirthday.phoneNumberofPerson;
                              String url = 'sms:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        if (loadedBirthday.emailofPerson.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.email_rounded,
                              color: Theme.of(context).primaryColor,
                              // size: 10,
                            ),
                            onPressed: () async {
                              String email = loadedBirthday.emailofPerson;
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
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            loadedBirthday.nameofperson,
                            //textScaleFactor: 1.4,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          loadedBirthday.yearofBirthProvidedStatus
                              ? Text(
                                  DateFormat('EEEE, MMM dd, yyyy')
                                      .format(loadedBirthday.dateofbirth),
                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text(DateFormat('EEEE, MMM dd')
                                  .format(loadedBirthday.dateofbirth)),
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
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Zodiac Sign : ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryText(loadedBirthday.categoryofPerson),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            loadedBirthday.dateofbirth != null
                                ? Text(
                                    DateFormat('HH : mm')
                                        .format(loadedBirthday.dateofbirth),
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.start,
                                  )
                                : Text(
                                    'None',
                                    style: TextStyle(fontSize: 20),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              loadedBirthday.zodiacSign,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        zodiacTraits(loadedBirthday.dateofbirth),
                        textAlign: TextAlign.left,
                        maxLines: 5,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (loadedBirthday.interestsofPerson != null &&
                        loadedBirthday.interestsofPerson.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Interest :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),

                    if (loadedBirthday.interestsofPerson != null &&
                        loadedBirthday.interestsofPerson.isNotEmpty)
                      Container(
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
                    if (loadedBirthday.notes != null &&
                        loadedBirthday.notes.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Notes :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (loadedBirthday.notes != null &&
                        loadedBirthday.notes.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        loadedBirthday.notes,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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
