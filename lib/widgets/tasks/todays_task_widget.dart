import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/tasks/all_task_screen.dart';
import 'package:yday/screens/tasks/task_detail_screen.dart';
import 'package:yday/widgets/tasks/task_widget.dart';

class TodaysTaskWidget extends StatefulWidget {
  final selectedDate;

  TodaysTaskWidget(this.selectedDate);

  @override
  _TodaysTaskWidgetState createState() => _TodaysTaskWidgetState();
}

class _TodaysTaskWidgetState extends State<TodaysTaskWidget> {
  var _isLoading = false;

  @override
  void initState() {
    // didUpdate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final tasklist = Provider.of<Tasks>(context);
    final tasks = tasklist.findByDate(widget.selectedDate);
    return  LimitedBox(
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : tasks.isEmpty?SizedBox()
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 30,width: 30,child: Image.asset('assets/images/completed-task.png'),),
                        Text('    Tasks',style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                          textAlign: TextAlign.left,),
                      ],
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context)
                          .pushNamed(AllTaskScreen.routeName);

                    }, child: Text('Show All',style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),))
                  ],
                ),
                Divider(),
                ListView.builder(
              shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
              ],
            ),
          ),
    );
  }
}
