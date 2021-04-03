import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get taskList => [..._taskList];

  void completeEvent(String taskid) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return ;
    }
    var _userID = _auth.currentUser.uid;
    final url = Uri.parse(
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$_userID/$taskid.json');
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

  Future<bool> fetchTask() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false ;
    }
    var _userID = _auth.currentUser.uid;
    final url = Uri.parse(
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$_userID.json');
    try{
      final response = await http.get(url);
      final List<Task> _loadedTask = [];
      final extractedTasks =
      json.decode(response.body) as Map<String, dynamic>;
      if (extractedTasks == null) {
        _taskList = _loadedTask;
        return true;
      }
      extractedTasks.forEach((taskId, task) {
        var dt = task['setAlarmforTask'] == null? null :DateTime.parse(task['setAlarmforTask']);
        _loadedTask.add(Task(
          taskId: taskId,
          title: task['title'],
          description: task['description'],
          startdate: DateTime.parse(task['startdate']),
          enddate: DateTime.parse(task['enddate']),
          setalarmfortask: dt==null?null:TimeOfDay(hour:dt.hour,minute :dt.minute),
          levelofpriority: getPriorityLevel(task['levelofpriority']),
        ));
      });
      _taskList = _loadedTask;
      _taskList.sort((a,b)=>a.startdate.compareTo(b.startdate));
      notifyListeners();
      return true;
    }catch (error) {
    throw error;
    }
  }

  Future<bool> addTask (Task task) async {

    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth ==null||_auth.currentUser==null){
      return false ;
    }
    var _userID = _auth.currentUser.uid;
    final url = Uri.parse(
        'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$_userID.json');
    final alarmstamp = task.setalarmfortask==null? null:DateTimeField.combine(task.enddate, task.setalarmfortask);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'startdate': task.startdate.toIso8601String(),
          'enddate': task.enddate.toIso8601String(),
          'levelofpriority': task.priorityLevelText,
          'setAlarmforTask': alarmstamp == null? null:alarmstamp.toIso8601String(),
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
    return true;
    } catch (error) {
      throw error;
    }
  }
  List<Task> findByDate(DateTime tasktime){
    // fetchTask();
    return _taskList.where((element) => element.startdate.day==tasktime.day&&element.startdate.month==tasktime.month&&element.startdate.year==tasktime.year).toList();
  }

}