import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
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
    Color _categoryColor = categoryColor(loadedAnniversary.categoryofCouple);
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
                      backgroundImage: loadedAnniversary.imageUrl == null
                          ? AssetImage('assets/images/userimage.png')
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
                        Text(getAge()==0?'Today':'${getAge().toString()} days left'),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(padding: EdgeInsets.all(4.0)),
              ListTile(
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text('Husband\'s Name',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
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
                title: Text('Wife\'s Name',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
                subtitle: Text(
                  loadedAnniversary.wife_name,
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.supervisor_account_rounded,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text('Relation',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
                subtitle: Text(
                  loadedAnniversary.relation,
                  //textScaleFactor: 1.4,
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
                title: Text('Anniversary Date',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
                subtitle: loadedAnniversary.yearofmarriageProvided
                    ? Text(
                  DateFormat('dd / MM / yyyy')
                      .format(loadedAnniversary.dateofanniversary),
                  //textScaleFactor: 1.4,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                )
                    : Text(DateFormat('dd / MM ')
                    .format(loadedAnniversary.dateofanniversary)),
              ),
              ListTile(
                leading: Icon(
                  Icons.watch_later_outlined,
                  color: _categoryColor,
                  size: 28.0,
                ),
                title: Text(
                  'Alarm Set',
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
                  maxLines: 5,
                )
                    : Text('No'),
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
                  loadedAnniversary.notes,
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
                subtitle: Text(
                  loadedAnniversary.phoneNumberofCouple,
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
                  loadedAnniversary.emailofCouple,
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
                  width: MediaQuery.of(context).size.width *
                      0.70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return InterestOfPerson(loadedAnniversary.interestsofCouple[i].name
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
