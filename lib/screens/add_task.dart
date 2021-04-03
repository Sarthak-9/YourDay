import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:menu_button/menu_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import 'package:yday/models/birthday.dart';
import 'package:yday/models/task.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/screens/homepage.dart';

import '../providers/tasks.dart';
import 'auth/login_page.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add-task-screen';

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  DateTime dateTime;
  TimeOfDay _alarmTime;
  File _imageofPersonToAdd = File(
    'assets/images/userimage.png',
  );
  var pickedFile;
  var _loggedIn = false;

  String _selectedCategory = 'ABC';
  List<String> _categories = ['Normal', 'Important', 'Urgent'];
  Color _categoryColor = Colors.red.shade50;
  bool _categoryBorder = true;

  bool _dateSelected = false;
  bool _categorySelected = false;
  bool _yearofBirthProvidedStat = true;
  PriorityLevel _levelofTask;
  BorderRadius _categoryborderRadius = BorderRadius.all(Radius.circular(40));
  DateTime _taskStartDate;
  DateTime _taskEndDate;

  final format = DateFormat("dd / MM / yyyy -- HH:mm");

  var _newTask = Task(
    taskId: '',
    title: '',
    description: '',
    startdate: null,
    enddate: null,
    setalarmfortask: null,
    levelofpriority: null,
  );

  @override
  void initState() {
    super.initState();
  }

  void _saveForm() async {
    FocusScope.of(context).unfocus();
    if(_taskStartDate == null||_taskEndDate == null||_taskEndDate.isBefore(_taskStartDate)){
      await showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text('Set Duration!'),
              content: Text('Enter a valid Duration.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
      );
    }
    final isValid = _form.currentState.validate();
    if (!isValid ||_taskStartDate == null||_taskEndDate == null||_taskEndDate.isBefore(_taskStartDate)) {
      return;
    }
    _form.currentState.save();
    try{
      _loggedIn = await Provider.of<Tasks>(context, listen: false).addTask(_newTask);
      if (_loggedIn == false) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'You are not Logged-In',
            ),
            content: Text(
                'Please Login with your credentials or Signup to YourDay to proceed'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushNamed(LoginPage.routename);
                },
                child: Text(
                  'Okay',
                ),
              ),
            ],
          ),
        );
      }
    }catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'An error occurred !',
          ),
          content: Text('Something went wrong'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
    }
    if(_loggedIn){
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget CategoryButton = Container(
      decoration: _categoryBorder
          ? BoxDecoration(
              color: _categoryColor, //Colors.red.shade50,
              //borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.red,
                width: 2,
              ),
            )
          : BoxDecoration(),
      //color: Colors.red.shade50,
      width: 150,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                //'Select Category',
                !_categorySelected ? 'Level of Priority' : _selectedCategory,
                //style: TextStyle(color: Colors.yellow),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 17,
              height: 17,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('YDay'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.amber,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.0,
                      ),
                    ),
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    DateTimeField(
                      textAlign: TextAlign.center,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        _taskStartDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (_taskStartDate != null) {
                          final _time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                        _taskStartDate = DateTimeField.combine(_taskStartDate, _time);
                        return _taskStartDate;
                        } else {
                          return currentValue;
                        }
                      },
                      onSaved: (value) {
                        _newTask = Task(
                          taskId: Id,
                          title: _newTask.title,
                          description: _newTask.description,
                          startdate: _taskStartDate,
                          enddate: _newTask.enddate,
                          setalarmfortask: _newTask.setalarmfortask,
                          levelofpriority: _newTask.levelofpriority,
                        );
                      },
                    ),
                  ]),
                ),
                //BasicDateTimeField('Start Time'),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.amber,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.0,
                      ),
                    ),
                    Text(
                      'End Time',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    DateTimeField(
                      textAlign: TextAlign.center,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        _taskEndDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (_taskEndDate != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          _taskEndDate = DateTimeField.combine(_taskEndDate, time);
                          return _taskEndDate;
                        } else {
                          return currentValue;
                        }
                      },

                      onSaved: (value) {
                        _newTask = Task(
                          taskId: Id,
                          title: _newTask.title,
                          description: _newTask.description,
                          startdate: _newTask.startdate,
                          enddate: _taskEndDate,
                          setalarmfortask: _newTask.setalarmfortask,
                          levelofpriority: _newTask.levelofpriority,
                        );
                      },
                    ),
                  ]),
                ),
                //BasicDateTimeField(''),
                Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a valid name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newTask = Task(
                      taskId: Id,
                      title: value,
                      description: _newTask.description,
                      startdate: _newTask.startdate,
                      enddate: _newTask.enddate,
                      setalarmfortask: _newTask.setalarmfortask,
                      levelofpriority: _newTask.levelofpriority,
                    );
                  },
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).dispose();
                  },
                  maxLines: 2,
                  onSaved: (value) {
                    _newTask = Task(
                      taskId: Id,
                      title: _newTask.title,
                      description: value,
                      startdate: _newTask.startdate,
                      enddate: _newTask.enddate,
                      setalarmfortask: _newTask.setalarmfortask,
                      levelofpriority: _newTask.levelofpriority,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                ),
                //RaisedButton(onPressed: (){},child: Text('Start Time'),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MenuButton(
                          child:
                              CategoryButton, // Widget displayed as the button
                          items: _categories, // List of your items
                          topDivider: true,
                          popupHeight:
                              160, // This popupHeight is optional. The default height is the size of items
                          scrollPhysics:
                              AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
                          itemBuilder: (value) => Container(
                              width: 100,
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                  value)), // Widget displayed for each item
                          toggledChild: Container(
                            child:
                                CategoryButton, // Widget displayed as the button,
                          ),
                          divider: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          onItemSelected: (value) {
                            if (value == 'Normal')
                              _levelofTask = PriorityLevel.Normal;
                            else if (value == 'Important')
                              _levelofTask = PriorityLevel.Important;
                            else if (value == 'Work')
                              _levelofTask = PriorityLevel.Urgent;
                            _selectedCategory = value.toString();
                            setState(() {
                              _categorySelected = true;
                              _categoryColor = Colors.amber;
                              _categoryBorder = false;
                            });
                            _newTask = Task(
                              taskId: Id,
                              title: _newTask.title,
                              description: _newTask.description,
                              startdate: _newTask.startdate,
                              enddate: _newTask.enddate,
                              setalarmfortask: _newTask.setalarmfortask,
                              levelofpriority: _levelofTask,
                            );
                            setState(() {});
                          },
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3.0))),
                          itemBackgroundColor: Colors.amber,
                          menuButtonBackgroundColor: Colors.amber,
                          onMenuButtonToggle: (isToggle) {
                            print(isToggle);
                          },
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                    RaisedButton(
                        child: Text(_alarmTime == null
                            ? 'Set Alarm'
                            : _alarmTime.format(context)),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          _alarmTime = await showCustomTimePicker(
                              context: context,
                              // It is a must if you provide selectableTimePredicate
                              onFailValidation: (context) =>
                                  print('Unavailable selection'),
                              initialTime: TimeOfDay(hour: 0, minute: 0));
                          //     selectableTimePredicate: (time) =>
                          //     time.hour > 1 &&
                          //         time.hour < 14 &&
                          //         time.minute % 10 == 0).then((time) =>
                          //     setState(() => selectedTime = time?.format(context))
                          // );
                          _newTask = Task(
                            taskId: Id,
                            title: _newTask.title,
                            description: _newTask.description,
                            startdate: _newTask.startdate,
                            enddate: _newTask.enddate,
                            setalarmfortask: _alarmTime,
                            levelofpriority: _newTask.levelofpriority,
                          );
                          setState(() {});
                        }),
                  ],
                ),

                RaisedButton(
                  onPressed: _saveForm,
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  final String typeofTask;

  BasicDateTimeField(this.typeofTask);

  @override
  Widget build(BuildContext context) {
    //return
  }
}