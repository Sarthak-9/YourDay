import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/task_detail_screen.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final tasklist = Provider.of<Tasks>(context);
    final tasks = tasklist.taskList;
    return Expanded(
      child: tasks.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Text(
                'No Tasks Today',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
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

class TaskItem extends StatelessWidget {
  final String taskId;
  final String title;
  final DateTime startdate;
  final DateTime enddate;
  final PriorityLevel prioritylevel;
  final Color taskColor;
  final String taskLevelText;

  TaskItem(this.taskId,this.title,this.startdate, this.enddate, this.prioritylevel, this.taskColor,
      this.taskLevelText); //final PriorityLevel ,

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(TaskDetailScreen.routeName,arguments: taskId),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: taskColor,
              //child: Text(taskLevelText),
            ),
            title: Text(title),
            trailing: Chip(
              label: Text(taskLevelText),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //     border: BoxBorder.
            //   ),
            //child: Text(priorityLevelText,style: TextStyle(
            //),),
            // ),
            subtitle: Row(
              children: [
                Text(
                  DateFormat('dd / MM -- ').format(startdate),
                ),
                Text(
                  DateFormat('dd / MM').format(enddate),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}