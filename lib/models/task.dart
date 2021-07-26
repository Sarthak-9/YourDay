import 'package:flutter/material.dart';

enum PriorityLevel {
  Normal,
  Important,
  Urgent,
}

class Task {
  final String taskId;
  final String calenderId;
  final String title;
  final String description;
  final DateTime startdate;
  final String frequency;
  final int notifId;
  final PriorityLevel levelofpriority;

  Task({this.taskId,this.calenderId,this.title, this.description,this.startdate,this.notifId,
    this.frequency,
    this.levelofpriority});

  String get priorityLevelText {
    switch(levelofpriority){
      case PriorityLevel.Urgent :
        return 'Urgent';
        break;
      case PriorityLevel.Important :
        return 'Important';
        break;
      case PriorityLevel.Normal :
        return 'Normal';
        break;
      default:
        return 'Normal';
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
        return Colors.red;
        break;
      case PriorityLevel.Important :
        return Colors.amber;
        break;
      case PriorityLevel.Normal :
        return Colors.green;
        break;
      default:
        return Colors.lightBlue;
    }
  }
}

PriorityLevel getPriorityLevel(String priorityLevel){
  switch(priorityLevel){
    case 'Normal' :
      return PriorityLevel.Normal;
      break;
    case 'Important' :
      return PriorityLevel.Important;
      break;
      case 'Urgent' :
    return PriorityLevel.Urgent;
    break;
    default:
      return PriorityLevel.Normal;
  }
}

// class EventList {
//   List<Task> taskList;
//

// }