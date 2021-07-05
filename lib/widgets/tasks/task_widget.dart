import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/tasks/task_detail_screen.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  var _isLoading = false;
  var _loggedIn = true;

  Future<void> _refreshTask(BuildContext context) async {
    await Provider.of<Tasks>(context, listen: false).fetchTask();
  }
  Future<void> _fetch()async{
    // Future.delayed(Duration.zero).then((_) async {
      _loggedIn = await Provider.of<Tasks>(context, listen: false).fetchTask();
    // });
  }
  void didUpdate()async{
    await _fetch();
  }

  // @override
  // void initState() {
  //   // didUpdate();
  //   super.initState();
  // }
  @override
  void didUpdateWidget(covariant TaskWidget oldWidget) {
    // TODO: implement didUpdateWidget
    // this.widget.
    // if(_loggedIn){
    setState(() {
      _isLoading = true;
    });
      didUpdate();
      setState(() {
        _isLoading = false;
      });
    // }
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final tasklist = Provider.of<Tasks>(context);
    final tasks = tasklist.taskList;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () => _refreshTask(context),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !_loggedIn
              ? Center(
                  child: Text(
                    'You are not Logged-in',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : tasks.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        'No Tasks',
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
                          // tasks[i].enddate,
                          tasks[i].levelofpriority,
                          tasks[i].priorityLevelColor,
                          tasks[i].priorityLevelText),
                      itemCount: tasks.length,
                      //),
                    ),
    ));
  }
}

class TaskItem extends StatelessWidget {
  final String taskId;
  final String title;
  final DateTime startdate;
  // final DateTime enddate;
  final PriorityLevel prioritylevel;
  final Color taskColor;
  final String taskLevelText;

  TaskItem(
      this.taskId,
      this.title,
      this.startdate,
      // this.enddate,
      this.prioritylevel,
      this.taskColor,
      this.taskLevelText); //final PriorityLevel ,

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.blue.shade50,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>TaskDetailScreen(taskId))),
            onLongPress: () async {
              // Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Mark as complete'),
                  content: Text('Are you sure you have completed this task'),
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
                        //Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
              // Provider.of<Tasks>(context,listen: false).completeEvent(taskId);
            },
            child: ListTile(
              title: Text(title),
              trailing: TextButton(child: Text('View'),onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx)=>TaskDetailScreen(taskId)))),
              // trailing: Chip(
              //   label: Text(taskLevelText),
              // ),
              subtitle: Text(
                DateFormat('dd / MM / yyyy  --  HH:mm').format(startdate),
              ),
            ),
          ),
        ),
        // Divider(),
      ],
    );
  }
}
