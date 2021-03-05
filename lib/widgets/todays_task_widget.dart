import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/task_detail_screen.dart';
import 'package:yday/widgets/task_widget.dart';

class TodaysTaskWidget extends StatefulWidget {
  final selectedDate;

  TodaysTaskWidget(this.selectedDate);

  @override
  _TodaysTaskWidgetState createState() => _TodaysTaskWidgetState();
}

class _TodaysTaskWidgetState extends State<TodaysTaskWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final tasklist = Provider.of<Tasks>(context);
    final tasks = tasklist.findByDate(widget.selectedDate);
    return tasks.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text(
              'No Tasks',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, i) => TaskItem(
                  tasks[i].taskId,
                  tasks[i].title,
                  tasks[i].startdate,
                  tasks[i].enddate,
                  tasks[i].levelofpriority,
                  tasks[i].priorityLevelColor,
                  tasks[i].priorityLevelText),
              itemCount: tasks.length,
              //),
            ),
          );
  }
}
