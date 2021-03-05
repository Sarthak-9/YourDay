import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/testfile.dart';

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
    final loadedAnniversary =
        Provider.of<Anniversaries>(context,listen: false).findById(anniversaryId);
    Color _categoryColor = loadedAnniversary.categoryColor;
    int daysLeftforAnniversary;

    int getAge() {
      int daysLeftforAnniversary =
          loadedAnniversary.dateofanniversary.day - DateTime.now().day;
      //daysLeftforAnniversary = dateTime.inDays;
      if (daysLeftforAnniversary < 0) {
        if (DateTime.now().year.toInt() % 4 == 0)
          daysLeftforAnniversary = 367 - daysLeftforAnniversary;
        else
          daysLeftforAnniversary = 366 - daysLeftforAnniversary;
      }

      return daysLeftforAnniversary;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('YourDay'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()async{
              // Navigator.of(context).pop();
              await showDialog(
                  context: context,
                  builder: (ctx) =>
                  AlertDialog(
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
                        onPressed: () {
                          Provider.of<Anniversaries>(context,listen: false).completeEvent(anniversaryId);
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
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
                      backgroundImage: loadedAnniversary.imageofCouple == null
                          ? AssetImage('assets/images/userimage.png')
                          : FileImage(loadedAnniversary.imageofCouple),
                      radius: MediaQuery.of(context).size.width * 0.18,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                    Column(
                      children: [
                        Chip(
                          label: Text(
                            loadedAnniversary.categoryText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          backgroundColor: _categoryColor,
                        ),
                        Text(getAge()==0?'Today':'${getAge().toString()} days left'),
                      ],
                    ),
                  ],
                ),
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.person_outline_rounded,
              //     color: _categoryColor,
              //     size: 28.0,
              //   ),
              //   title: Text(
              //     'Husband\'s Name',
              //     textAlign: TextAlign.left,
              //     textScaleFactor: 1.3,
              //     style: TextStyle(
              //       color: _categoryColor,
              //     ),
              //   ),
              //   subtitle: Text(
              //     loadedAnniversary.husband_name,
              //     style: TextStyle(
              //       color: Colors.black
              //     ),
              //     //textScaleFactor: 1.4,
              //     textAlign: TextAlign.start,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              Padding(padding: EdgeInsets.all(4.0)),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: _categoryColor,
                      size: 28.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Husband\'s Name',
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              color: _categoryColor,
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              loadedAnniversary.husband_name,
                              //textScaleFactor: 1.4,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: _categoryColor,
                      size: 28.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wife\'s Name',
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              color: _categoryColor,
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              loadedAnniversary.husband_name,
                              //textScaleFactor: 1.4,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.supervisor_account_rounded,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Relation',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                loadedAnniversary.relation,
                                //textScaleFactor: 1.4,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: _categoryColor,
                      size: 28.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anniversary Date',
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              color: _categoryColor,
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: loadedAnniversary.yearofmarriageProvided
                                ? Text(
                                    DateFormat('dd / MM / yyyy').format(
                                        loadedAnniversary.dateofanniversary),
                                    //textScaleFactor: 1.4,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  )
                                : Text(DateFormat('dd / MM ').format(
                                    loadedAnniversary.dateofanniversary)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alarm Set',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: loadedAnniversary.setAlarmforAnniversary !=
                                      null
                                  ? Text(
                                      loadedAnniversary.setAlarmforAnniversary
                                          .format(context),
                                      //textScaleFactor: 1.4,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    )
                                  : Text('No'),
                            ),
                            //),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.note_outlined,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                loadedAnniversary.notes,
                                //textScaleFactor: 1.4,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_android_rounded,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                loadedAnniversary.phoneNumberofCouple==null?loadedAnniversary.phoneNumberofCouple:'None',
                                //textScaleFactor: 1.4,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
              Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                loadedAnniversary.emailofCouple==null?loadedAnniversary.emailofCouple:'None',
                                //textScaleFactor: 1.4,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
              Container(
                  //height: 200,
                  padding: EdgeInsets.all(5.0),
                  //width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        color: _categoryColor,
                        size: 28.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interests',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                color: _categoryColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0)),
                            (loadedAnniversary.interestsofCouple == null ||
                                    loadedAnniversary.interestsofCouple.isEmpty)
                                ? Container(
                                    child: Text('None'),
                                  )
                                : Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width *
                                        0.70,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, i) {
                                        return InterestOfPerson(
                                            loadedAnniversary
                                                .interestsofCouple[i].name
                                                .toString());
                                      },
                                      itemCount:
                                          loadedAnniversary.interestListSize(),
                                      shrinkWrap: true,
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      physics: ClampingScrollPhysics(),
                                      //padding: const EdgeInsets.all(10),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  )),
              Divider(),
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
// Chip(
// label: Text(_interestOfPerson),
// );

// Expanded(
// child: ListView.builder(
// scrollDirection: Axis.horizontal,
// itemBuilder: (ctx, i) {
// return InterestOfPerson(loadedBirthday
//     .interestsofPerson[i].name
//     .toString());
// },
// itemCount:
// loadedBirthday.interestListSize(),
// shrinkWrap: true,
// physics: ClampingScrollPhysics(),
// padding: const EdgeInsets.all(10),
// // gridDelegate: SliverGridRegularTileLayout(crossAxisStride: null
// //
// //  // crossAxisCount: 2,
// //   //crossAxisSpacing: 10,
// //   //childAspectRatio: 3 / 3,
// //   //mainAxisSpacing: 10,
// // ),
// ),
// ),
