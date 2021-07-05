import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/task.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/tasks/all_task_screen.dart';
import 'package:yday/services/google_signin_repository.dart';
import 'package:yday/services/message_handler.dart';

import '../all_event_screen.dart';
import '../homepage.dart';

class TaskDetailScreen extends StatefulWidget {
  // static const routeName = '/task-detail-screen';
  String taskId;
  TaskDetailScreen(this.taskId);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task loadedTask ;
  @override
  void didChangeDependencies() {
  loadedTask =  Provider.of<Tasks>(context, listen: false).findById(widget.taskId);

  // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    Color _categoryColor = loadedTask.priorityLevelColor;
    final format = DateFormat("dd / MM / yyyy -- HH:mm");
    bool isToday = false;
    int getAge() {
      int daysLeftFortask = 0;
      DateTime b;
      var dtnow = DateTime.now();
      var dt = loadedTask.startdate;
      if(dt.year == dtnow.year&&dt.month==dtnow.month&&dt.day==dtnow.day){
        isToday = true;
      }
      b = DateTime.utc(dtnow.year, dt.month, dt.day);
      Duration years;
      if(b.isAfter(dtnow)) {
        years = b.difference(dtnow);
        daysLeftFortask = years.inDays;
      }else{
        years = dtnow.difference(b);
        daysLeftFortask =365- years.inDays;
      }
      // print(years.inDays+1);
      return daysLeftFortask;
    }

    return Scaffold(
        appBar: AppBar(
          title:  GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
              child: Image.asset(
                "assets/images/Main_logo.png",
                height: 60,
                width: 100,
              )),
          titleSpacing: 0.1,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete the Task'),
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
                        onPressed: () async{
                          Navigator.of(ctx).pop();
                          Provider.of<Tasks>(context, listen: false)
                              .completeEvent(widget.taskId);
                          Navigator.of(context)
                              .pushReplacementNamed(AllTaskScreen.routeName);                        },
                      )
                    ],
                  ),
                );
                // Provider.of<Tasks>(context,listen: false).completeEvent(taskId);
                // Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                // Text(
                //   'Task Details',
                //   style: TextStyle(
                //     fontSize: 24.0,
                //   ),
                // ),
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
                Text(getAge()!=0&&isToday
                    ? 'Today'
                    : '${getAge().toString()} days left'),
                Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: Icon(
                    Icons.person_outline_rounded,
                    color: _categoryColor,
                    size: 28.0,
                  ),
                  title: Text(
                    'Title',
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                      color: _categoryColor,
                    ),
                  ),
                  subtitle: Text(
                    loadedTask.title,
                    //textScaleFactor: 1.4,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.note_outlined,
                    color: _categoryColor,
                    size: 28.0,
                  ),
                  title: Text(
                    'Description',
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                      color: _categoryColor,
                    ),
                  ),
                  subtitle: Text(
                    loadedTask.description.isNotEmpty?loadedTask.description:'None',
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
                    title: Text(
                      'Start Time',
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        color: _categoryColor,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('EEEE, dd / MM / yyyy  --  HH:mm')
                          .format(loadedTask.startdate),
                      //textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    )),
                // ListTile(
                //     leading: Icon(
                //       Icons.calendar_today_rounded,
                //       color: _categoryColor,
                //       size: 28.0,
                //     ),
                //     title: Text(
                //       'End Time',
                //       textAlign: TextAlign.left,
                //       textScaleFactor: 1.3,
                //       style: TextStyle(
                //         color: _categoryColor,
                //       ),
                //     ),
                //     subtitle: Text(
                //       DateFormat('dd / MM / yyyy  --  HH:mm')
                //           .format(loadedTask.enddate),
                //       //textScaleFactor: 1.4,
                //       textAlign: TextAlign.start,
                //       overflow: TextOverflow.ellipsis,
                //     )),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => Theme.of(context).primaryColor)),
                  // color: Theme.of(context).primaryColor,
                  // textColor: Colors.white,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Mark as complete'),
                        content:
                            Text('Are you sure you have completed this task ?'),
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
                                  .format(loadedTask.startdate);
                              int dtInt= int.parse(str);
                              await NotificationsHelper.cancelTaskNotification(dtInt);
                              Provider.of<Tasks>(context, listen: false)
                                  .completeEvent(widget.taskId);
                              Navigator.of(context)
                                  .pushReplacementNamed(AllTaskScreen.routeName);                             },
                          )
                        ],
                      ),
                    );
                    // Navigator.of(context).pop();
                    // Provider.of<Tasks>(context,listen: false).completeEvent(taskId);
                    // Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mark as Completed',
                  ),
                ),
                // Divider(),
              ],
            ),
          ),
        ));
  }
}
