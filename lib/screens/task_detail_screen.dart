import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/tasks.dart';

class TaskDetailScreen extends StatefulWidget {
  static const routeName = '/task-detail-screen';

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context).settings.arguments as String;
    final loadedTask = Provider.of<Tasks>(context).findById(taskId);
    Color _categoryColor = loadedTask.priorityLevelColor;
    int daysleftforTask;

    int getAge() {
      Duration dateTime = loadedTask.enddate.difference(DateTime.now());
      daysleftforTask = dateTime.inDays;
      if (daysleftforTask < 0) {
        if (DateTime.now().year.toInt() % 4 == 0)
          daysleftforTask = 367 - daysleftforTask;
        else
          daysleftforTask = 366 - daysleftforTask;
      }

      return daysleftforTask;
    }

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                Chip(
                  label: Text(
                    loadedTask.priorityLevelText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  backgroundColor: _categoryColor,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text('${getAge().toString()} days left'),
                Padding(padding: EdgeInsets.all(8.0)),
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
                                'Title',
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
                                  loadedTask.title,
                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                'Description',
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
                                  loadedTask.description,
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
                              'Start Date',
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
                                  DateFormat('dd / MM / yyyy')
                                      .format(loadedTask.startdate),
                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                )),
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
                              'End Date',
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
                                DateFormat('dd / MM / yyyy')
                                    .format(loadedTask.enddate),
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
                                child: loadedTask.setalarmfortask != null
                                    ? Text(
                                        loadedTask.setalarmfortask
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

                // Divider(),
              ],
            ),
          ),
        ));
  }
}
//
// class InterestOfPerson extends StatelessWidget {
//   String _interestOfPerson;
//
//   InterestOfPerson(this._interestOfPerson);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//       child: Chip(
//         backgroundColor: Colors.amber,
//         label: Text(
//           _interestOfPerson,
//           style: TextStyle(
//             color: Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
// // Chip(
// // label: Text(_interestOfPerson),
// // );
//
// // Expanded(
// // child: ListView.builder(
// // scrollDirection: Axis.horizontal,
// // itemBuilder: (ctx, i) {
// // return InterestOfPerson(loadedBirthday
// //     .interestsofPerson[i].name
// //     .toString());
// // },
// // itemCount:
// // loadedBirthday.interestListSize(),
// // shrinkWrap: true,
// // physics: ClampingScrollPhysics(),
// // padding: const EdgeInsets.all(10),
// // // gridDelegate: SliverGridRegularTileLayout(crossAxisStride: null
// // //
// // //  // crossAxisCount: 2,
// // //   //crossAxisSpacing: 10,
// // //   //childAspectRatio: 3 / 3,
// // //   //mainAxisSpacing: 10,
// // // ),
// // ),
// // ),