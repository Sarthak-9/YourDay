import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _taskList = [
    Task(
      taskId: '1',
      title: 'Task1',
      description: 'This is task 1',
      startdate: DateTime.now(),
      enddate: DateTime.now().add(Duration(days: 1)),
      levelofpriority: PriorityLevel.Normal,
      // startdate: 15/02/2000
    ),
    Task(
      taskId: '2',
      title: 'Task1',
      description: 'This is task 2',
      startdate: DateTime.now(),
      enddate: DateTime.now().add(Duration(days: 1)),
      levelofpriority: PriorityLevel.Important,
      // startdate: 15/02/2000
    ),
    Task(
      taskId: '3',
      title: 'Task3',
      description: 'This is task 3',
      startdate: DateTime.now(),
      enddate: DateTime.now().add(Duration(days: 1)),
      levelofpriority: PriorityLevel.Urgent,
      // startdate: 15/02/2000
    ),
  ];

  List<Task> get taskList => [..._taskList];

  void addEvent(Task task){
    _taskList.add(task);
  }

  void removeEvent(Task task){
    _taskList.removeWhere((element) => task.enddate==DateTime.now());
  }

  void completeEvent(Task task){
    _taskList.remove(task);
  }

  Task findById(String taskid) {
    return _taskList.firstWhere((task) => task.taskId == taskid);
  }

  void addTask (Task task){
    final newTask = Task(
      taskId: DateTime.now().toString(),
      title: task.title,
      description: task.description,
      startdate: task.startdate,
      enddate: task.enddate,
      levelofpriority: task.levelofpriority,
    );
    _taskList.add(newTask);
    notifyListeners();
  }
}