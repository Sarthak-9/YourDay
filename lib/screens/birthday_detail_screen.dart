import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/testfile.dart';

class BirthdayDetailScreen extends StatefulWidget {
  static const routeName = '/birthday-detail-screen';

  @override
  _BirthdayDetailScreenState createState() => _BirthdayDetailScreenState();
}

class _BirthdayDetailScreenState extends State<BirthdayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final birthdayId = ModalRoute.of(context).settings.arguments as String;
    final loadedBirthday = Provider.of<Birthdays>(context,listen: false).findById(birthdayId);
    Color _categoryColor = categoryColor(loadedBirthday.categoryofPerson);
    int daysLeftforBirthday;

    int getAge() {
      int daysLeftforBirthday = loadedBirthday.dateofbirth.day - DateTime.now().day;
      //daysLeftforBirthday = dateTime.inDays;
      if (daysLeftforBirthday < 0) {
        if (DateTime.now().year.toInt() % 4 == 0)
          daysLeftforBirthday = 367 - daysLeftforBirthday;
        else
          daysLeftforBirthday = 366 - daysLeftforBirthday;
      }

      return daysLeftforBirthday;
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
                        title: Text('Delete this birthday'),
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
                              Provider.of<Birthdays>(context,listen: false).completeEvent(birthdayId);
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
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
                      backgroundImage: loadedBirthday.imageUrl == null
                          ? AssetImage('assets/images/userimage.png')
                          : NetworkImage(loadedBirthday.imageUrl),
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
                title: Text('Name',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
                subtitle: Text(
                  loadedBirthday.nameofperson,
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
                  loadedBirthday.relation,
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
                title: Text('Birth Date',textAlign: TextAlign.left,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: _categoryColor,
                  ),),
                subtitle: loadedBirthday.yearofBirthProvidedStatus
                    ? Text(
                    DateFormat('dd / MM / yyyy')
                        .format(loadedBirthday.dateofbirth),
                    //textScaleFactor: 1.4,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                )
                    : Text(DateFormat('dd / MM ')
                    .format(loadedBirthday.dateofbirth)),
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
                subtitle: loadedBirthday.setAlarmforBirthday != null
                    ? Text(
                  loadedBirthday.setAlarmforBirthday
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
                  loadedBirthday.notes,
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
                  loadedBirthday.phoneNumberofPerson,
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
                  loadedBirthday.emailofPerson,
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
                  width: MediaQuery.of(context).size.width *
                      0.70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return InterestOfPerson(loadedBirthday
                          .interestsofPerson[i].name
                          .toString());
                    },
                    itemCount:
                    loadedBirthday.interestListSize(),
                    shrinkWrap: true,
                    dragStartBehavior:
                    DragStartBehavior.start,
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

