import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get taskList => [..._taskList];

  void completeEvent(String taskid){
    final url =
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$taskid.json';
    final existingBdayIndex =
    _taskList.indexWhere((element) => element.taskId == taskid);
    var existingBday = _taskList[existingBdayIndex];
    _taskList.removeAt(existingBdayIndex);
    notifyListeners();
    http.delete(url).then((value) => {existingBday = null}).catchError((error) {
      _taskList.insert(existingBdayIndex, existingBday);
      notifyListeners();
    });
  }

  Task findById(String taskid) {
    return _taskList.firstWhere((task) => task.taskId == taskid);
  }

  Future<void> fetchTask() async{
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks.json';
    try{
      final response = await http.get(url);
      final List<Task> _loadedTask = [];
      final extractedTasks =
      json.decode(response.body) as Map<String, dynamic>;
      if (extractedTasks == null) {
        return;
      }
      extractedTasks.forEach((taskId, task) {
        _loadedTask.add(Task(
          taskId: taskId,
          title: task['title'],
          description: task['description'],
          startdate: DateTime.parse(task['startdate']),
          enddate: DateTime.parse(task['enddate']),
          levelofpriority: getPriorityLevel(task['levelofpriority']),
        ));
      });
      _taskList = _loadedTask;
      notifyListeners();
    }catch (error) {
    throw error;
    }
  }

  Future<void> addTask (Task task) async {
    const url =
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'startdate': task.startdate.toIso8601String(),
          'enddate': task.enddate.toIso8601String(),
          'levelofpriority': task.priorityLevelText,
          // setalarmfortask: task.setalarmfortask,
           }),
      );
    final newTask = Task(
      taskId: json.decode(response.body)['name'],
      title: task.title,
      description: task.description,
      startdate: task.startdate,
      enddate: task.enddate,
      levelofpriority: task.levelofpriority,
      setalarmfortask: task.setalarmfortask,
    );
    _taskList.add(newTask);
    notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  List<Task> findByDate(DateTime tasktime){
    return _taskList.where((element) => element.startdate.day==tasktime.day&&element.startdate.month==tasktime.month&&element.startdate.year==tasktime.year).toList();
  }

}