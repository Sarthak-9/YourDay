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
    final loadedTask =
        Provider.of<Tasks>(context, listen: false).findById(taskId);
    Color _categoryColor = loadedTask.priorityLevelColor;
    int daysleftforTask;
    final format = DateFormat("dd / MM / yyyy -- HH:mm");

    int getAge() {
      int daysleftforTask = loadedTask.enddate.day - DateTime.now().day;
      //daysleftforTask = dateTime.inDays;
      if (daysleftforTask < 0) {
        if (DateTime.now().year.toInt() % 4 == 0)
          daysleftforTask = 367 - daysleftforTask;
        else
          daysleftforTask = 366 - daysleftforTask;
      }

      return daysleftforTask;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('YourDay'),
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
                        onPressed: () {
                          Provider.of<Tasks>(context, listen: false)
                              .completeEvent(taskId);
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
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
                Text(getAge() == 0
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
                    loadedTask.description,
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
                      DateFormat('dd / MM / yyyy  --  HH:mm')
                          .format(loadedTask.startdate),
                      //textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    )),
                ListTile(
                    leading: Icon(
                      Icons.calendar_today_rounded,
                      color: _categoryColor,
                      size: 28.0,
                    ),
                    title: Text(
                      'End Time',
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        color: _categoryColor,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd / MM / yyyy  --  HH:mm')
                          .format(loadedTask.enddate),
                      //textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    )),
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
                  subtitle: loadedTask.setalarmfortask != null
                      ? Text(
                          loadedTask.setalarmfortask.format(context),
                          //textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        )
                      : Text('No'),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
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
                            onPressed: () {
                              Provider.of<Tasks>(context, listen: false)
                                  .completeEvent(taskId);
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
                    // Navigator.of(context).pop();
                    // Provider.of<Tasks>(context,listen: false).completeEvent(taskId);
                    // Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mark as Complete',
                  ),
                ),
                // Divider(),
              ],
            ),
          ),
        ));
  }
}
