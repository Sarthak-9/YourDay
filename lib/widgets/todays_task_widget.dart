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
  var _isLoading = false;

  Future<void> _fetch()async{
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Tasks>(context, listen: false).fetchTask();
      setState(() {
        _isLoading = false;
      });
    });
  }
  @override
  void initState() {
    _fetch();
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
          : tasks.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Text(
                'No Tasks',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
        shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
