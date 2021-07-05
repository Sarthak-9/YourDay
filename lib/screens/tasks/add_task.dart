import 'dart:io';
import 'package:flutter/src/material/time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:menu_button/menu_button.dart';
import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/services/google_calender_repository.dart';
import 'package:yday/services/google_signin_repository.dart';
import '../../providers/tasks.dart';
import '../auth/login_page.dart';
import '../homepage.dart';

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
  bool _loggedIn = false;
  // bool _addToGoogleCalender = false;
  List<String> _categories = ['Normal', 'Important', 'Urgent'];
  Color _categoryColor = Colors.red.shade50;
  bool _categoryBorder = true;
  bool isLoading = false;
  bool _categorySelected = false;
  bool _yearofBirthProvidedStat = true;
  PriorityLevel _levelofTask;
  BorderRadius _categoryborderRadius = BorderRadius.all(Radius.circular(40));
  DateTime _taskStartDate;
  String _selectedCategory = 'Others';
  int categoryNumber = 3;
  // DateTime _taskEndDate;

  final format = DateFormat("dd / MM / yyyy -- HH:mm");

  var _newTask = Task(
    taskId: '',
    title: '',
    description: '',
    startdate: null,
    // enddate: null,
    // setalarmfortask: null,
    levelofpriority: null,
  );

  @override
  void initState() {
    super.initState();
  }

  void _saveForm() async {
    FocusScope.of(context).unfocus();
    DateTime dtNow = DateTime.now();
    if (_taskStartDate == null || _taskStartDate.isBefore(dtNow)) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Event!'),
          content: Text('Enter a future event.'),
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
      return;
    }
    final isValid = _form.currentState.validate();
    if (!isValid || _taskStartDate == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _form.currentState.save();
    // String calenderId = null;
    // if(_addToGoogleCalender){
    //   calenderId = await addCalender();
    // }
    try {
      _newTask = Task(
          taskId: Id,
          // calenderId: calenderId,
          title: _newTask.title,
          description: _newTask.description,
          startdate: _newTask.startdate,
          // enddate: _newTask.enddate,
          // setalarmfortask: _newTask.setalarmfortask,
          levelofpriority:
              getPriorityLevel(_selectedCategory) // _newTask.levelofpriority,
          );
      _loggedIn =
          await Provider.of<Tasks>(context, listen: false).addTask(_newTask);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
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
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
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
    return Scaffold(
      appBar: AppBar(
        title:  GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
            child: Image.asset(
              "assets/images/Main_logo.png",
              height: 60,
              width: 100,
            )),
        titleSpacing: 0.1,
        centerTitle: true,
        // centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
                      Card(
                        elevation: 5,
                        color: Colors.amber,
                        shape: Border.all(
                          color: Colors.amber,
                          width: 2.0,
                        ),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.amber,
                          //
                          //   border: Border.all(
                          //     color: Colors.amber,
                          //     width: 2.0,
                          //   ),
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                            ),
                            Text(
                              'Task Date',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            DateTimeField(
                              textAlign: TextAlign.center,
                              format: format,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onShowPicker: (context, currentValue) async {
                                _taskStartDate = await showDatePicker(
                                    context: context,
                                    builder: (context, child) => Theme(
                                          data: ThemeData(
                                            colorScheme: ColorScheme.light(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            buttonTheme: ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child,
                                        ),
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (_taskStartDate != null) {
                                  final _time = await showTimePicker(
                                    context: context,
                                    initialEntryMode: TimePickerEntryMode.input,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  );
                                  _taskStartDate = DateTimeField.combine(
                                      _taskStartDate, _time);
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
                                  // enddate: _newTask.enddate,
                                  // setalarmfortask: _newTask.setalarmfortask,
                                  levelofpriority: _newTask.levelofpriority,
                                );
                              },
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
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
                            // enddate: _newTask.enddate,
                            // setalarmfortask: _newTask.setalarmfortask,
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
                            // enddate: _newTask.enddate,
                            // setalarmfortask: _newTask.setalarmfortask,
                            levelofpriority: _newTask.levelofpriority,
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Category :',
                            style: TextStyle(fontSize: 16),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectCategory(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Normal',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: categoryNumber == 0
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectCategory(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Important',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: categoryNumber == 1
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectCategory(2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Urgent',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: categoryNumber == 2
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Add Task',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                          primary: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void selectCategory(int catNumber) {
    switch (catNumber) {
      case 0:
        _selectedCategory = 'Normal';
        break;
      case 1:
        _selectedCategory = 'Important';
        break;
      case 2:
        _selectedCategory = 'Urgent';
        break;
      // case 3:
      //   _selectedCategory = 'Others';
      //   break;
      default:
        _selectedCategory = 'Normal';
    }
    setState(() {
      categoryNumber = catNumber;
    });
  }
  // Future<String> addCalender()async{
  //   GoogleSignInAccount account = Provider.of<GoogleAccountRepository>(context,listen: false).googleSignInAccount;
  //   String title = _newTask.title;
  //   // var currentTime = _n;
  //   // DateTime startTime,endTime;
  //   // if(_editedBirthday.setAlarmforBirthday!=null) {
  //   //   var alarmTime = _editedBirthday.setAlarmforBirthday;
  //   //   startTime = DateTime(currentTime.year, currentTime.month, currentTime.day,alarmTime.hour,alarmTime.minute);
  //   // }else{
  //   //   startTime = DateTime(currentTime.year, currentTime.month, currentTime.day,10,00);
  //   // }
  //   // endTime = DateTime(startTime.year,startTime.month,startTime.day,(startTime.hour+1),startTime.minute,00);
  //   GoogleCalenderModel calenderModel = GoogleCalenderModel(title: title,description: _newTask.description,startTime: _newTask.startdate,
  //       // endTime: _newTask.enddate
  //   );
  //   CalendarClient cal = CalendarClient();
  //   String calId = await cal.insertCalender(account,calenderModel);
  //   return calId;
  // }
}
