import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yday/services/message_handler.dart';
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
    try{
      final taskdatabaseRef = FirebaseDatabase.instance.reference().child('tasks').child(_userID); //database reference object
      await taskdatabaseRef.child(taskid).remove();
    }catch(error){}
    // final url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$_userID/$taskid.json');
    final existingBdayIndex =
    _taskList.indexWhere((element) => element.taskId == taskid);
    // var existingBday = _taskList[existingBdayIndex];
    _taskList.removeAt(existingBdayIndex);
    notifyListeners();
    // http.delete(url).then((value) => {existingBday = null}).catchError((error) {
    //   _taskList.insert(existingBdayIndex, existingBday);
    //   notifyListeners();
    // });
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
    // final url = Uri.parse(
    //     'https://yourday-306218-default-rtdb.firebaseio.com/tasks/$_userID.json');
    try{
      // final response = await http.get(url);
      final List<Task> _loadedTask = [];
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('tasks')
          .child(_userID);
      final extractedTasks = await databaseRef.once();
      // json.decode(response.body) as Map<String, dynamic>;
      if (extractedTasks == null||extractedTasks.value==null) {
        _taskList = _loadedTask;
        return true;
      }
      extractedTasks.value.forEach((taskId, task) {
        var dt = task['setAlarmforTask'] == null? null :DateTime.parse(task['setAlarmforTask']);
        _loadedTask.add(Task(
          taskId: taskId,
          calenderId: task['calenderId'],
          title: task['title'],
          description: task['description'],
          startdate: DateTime.parse(task['startdate']),
          // enddate: DateTime.parse(task['enddate']),
          // setalarmfortask: dt==null?null:TimeOfDay(hour:dt.hour,minute :dt.minute),
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
      return false;
    }
    var _userID = _auth.currentUser.uid;
    // final alarmstamp = task.setalarmfortask==null? null:DateTimeField.combine(task.startdate, task.setalarmfortask);
    try {
      String str = DateFormat('ddyyhhmm')
          .format(task.startdate);
      int dtInt= int.parse(str);
      await NotificationsHelper.setNotificationForTask(task.startdate ,dtInt,task.title,task.description).then((value) => print(task.startdate));

      final taskdatabaseRef = FirebaseDatabase.instance.reference().child('tasks').child(_userID); //database reference object
      var res = taskdatabaseRef.push();
      await res.set({
        'calenderId': task.calenderId,
        'title': task.title,
        'description': task.description,
        'startdate': task.startdate.toIso8601String(),
        // 'enddate': task.enddate.toIso8601String(),
        'levelofpriority': task.priorityLevelText,
        // 'setAlarmforTask': alarmstamp == null? null:alarmstamp.toIso8601String(),
      });
    final newTask = Task(
      taskId: res.key,
      calenderId: task.calenderId,
      title: task.title,
      description: task.description,
      startdate: task.startdate,
      // enddate: task.enddate,
      levelofpriority: task.levelofpriority,
      // setalarmfortask: task.setalarmfortask,
    );
    _taskList.add(newTask);
    notifyListeners();
    return true;
    } catch (error) {
      print(error);
      throw error;
    }
  }
  List<Task> findByDate(DateTime tasktime){
    // fetchTask();
    return _taskList.where((element) => element.startdate.day==tasktime.day&&element.startdate.month==tasktime.month&&element.startdate.year==tasktime.year).toList();
  }

}