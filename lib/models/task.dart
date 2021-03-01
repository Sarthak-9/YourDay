import 'package:flutter/material.dart';

enum PriorityLevel {
  Normal,
  Important,
  Urgent,
}

class Task {
  final String taskId;
  final String title;
  final String description;
  final DateTime startdate;
  final DateTime enddate;
  final TimeOfDay setalarmfortask;
  final PriorityLevel levelofpriority;

  Task({this.taskId,this.title, this.description,this.startdate, this.enddate,this.setalarmfortask, this.levelofpriority});

  String get priorityLevelText {
    switch(levelofpriority){
      case PriorityLevel.Urgent :
        return 'Necessary';
        break;
      case PriorityLevel.Important :
        return 'Important';
        break;
      case PriorityLevel.Normal :
        return 'Normal';
        break;
      default:
        return 'Unknown';
    }
  }
  String get priorityLevelRank {
    switch(levelofpriority){
      case PriorityLevel.Urgent :
        return 'I';
        break;
      case PriorityLevel.Important :
        return 'II';
        break;
      case PriorityLevel.Normal :
        return 'III';
        break;
      default:
        return 'IV';
    }
  }
  Color get priorityLevelColor {
    switch(levelofpriority){
      case PriorityLevel.Urgent :
        return Colors.deepOrange;
        break;
      case PriorityLevel.Important :
        return Colors.yellow;
        break;
      case PriorityLevel.Normal :
        return Colors.orangeAccent;
        break;
    }
  }
  // String get priorityText{
  //   switch(levelofpriority){
  //     case PriorityLevel.Normal:
  //       return 'Normal';
  //       break;
  //     case PriorityLevel.Necessary:
  //       return 'Necessary';
  //       break;
  //     case PriorityLevel.Important:
  //       return 'Important';
  //       break;
  //     default :
  //       return 'Normal';
  //   }
  // }
  //
  // Color get priorityColor{
  //   switch(levelofpriority){
  //     case PriorityLevel.Normal:
  //       return Colors.green;
  //       break;
  //     case PriorityLevel.Necessary:
  //       return Colors.red;
  //       break;
  //     case PriorityLevel.Important:
  //       return Colors.amber;
  //       break;
  //     default :
  //       return Colors.green;
  //   }
  // }
}

// class EventList {
//   List<Task> taskList;
//

// }