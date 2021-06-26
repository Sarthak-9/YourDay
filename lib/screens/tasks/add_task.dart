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
  String _selectedCategory = 'ABC';
  List<String> _categories = ['Normal', 'Important', 'Urgent'];
  Color _categoryColor = Colors.red.shade50;
  bool _categoryBorder = true;
  bool isLoading = false;
  bool _categorySelected = false;
  bool _yearofBirthProvidedStat = true;
  PriorityLevel _levelofTask;
  BorderRadius _categoryborderRadius = BorderRadius.all(Radius.circular(40));
  DateTime _taskStartDate;
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
    if(_taskStartDate == null||_taskStartDate.isBefore(dtNow)){
      await showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
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
    if (!isValid ||_taskStartDate == null) {
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
    try{
      _newTask = Task(
        taskId: Id,
        // calenderId: calenderId,
        title: _newTask.title,
        description: _newTask.description,
        startdate: _newTask.startdate,
        // enddate: _newTask.enddate,
        // setalarmfortask: _newTask.setalarmfortask,
        levelofpriority: _newTask.levelofpriority,
      );
      _loggedIn = await Provider.of<Tasks>(context, listen: false).addTask(_newTask);
      setState(() {
        isLoading = false;
      });
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
      width: 150,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                !_categorySelected ? 'Level of Priority' : _selectedCategory,
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
        title: Text(
          'YourDay',
          style: TextStyle(
            // fontFamily: "Kaushan Script",
            fontSize: 28,
          ),
        ),
        // centerTitle: true,
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :  Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/Untitled design.jpg')
          ),
          // backgroundBlendMode: BlendMode.difference
        ),
            child: SingleChildScrollView(
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
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
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
                            // enddate: _newTask.enddate,
                            // setalarmfortask: _newTask.setalarmfortask,
                            levelofpriority: _newTask.levelofpriority,
                          );
                        },
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: Colors.amber,
                  //       width: 2.0,
                  //     ),
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   child: Column(children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 2.0,
                  //       ),
                  //     ),
                  //     Text(
                  //       'End Date',
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //       ),
                  //     ),
                  //     DateTimeField(
                  //       textAlign: TextAlign.center,
                  //       format: format,
                  //       decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //       ),
                  //       onShowPicker: (context, currentValue) async {
                  //         _taskEndDate = await showDatePicker(
                  //             context: context,
                  //             firstDate: DateTime(1900),
                  //             initialDate: currentValue ?? DateTime.now(),
                  //             lastDate: DateTime(2100));
                  //         if (_taskEndDate != null) {
                  //           final time = await showTimePicker(
                  //             context: context,
                  //             initialTime: TimeOfDay.fromDateTime(
                  //                 currentValue ?? DateTime.now()),
                  //           );
                  //           _taskEndDate = DateTimeField.combine(_taskEndDate, time);
                  //           return _taskEndDate;
                  //         } else {
                  //           return currentValue;
                  //         }
                  //       },
                  //
                  //       onSaved: (value) {
                  //         _newTask = Task(
                  //           taskId: Id,
                  //           title: _newTask.title,
                  //           description: _newTask.description,
                  //           startdate: _newTask.startdate,
                  //           // enddate: _taskEndDate,
                  //           setalarmfortask: _newTask.setalarmfortask,
                  //           levelofpriority: _newTask.levelofpriority,
                  //         );
                  //       },
                  //     ),
                  //   ]),
                  // ),
                  //BasicDateTimeField(''),
                  // SizedBox(
                  //   height: 12.0,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Switch(value: _addToGoogleCalender, onChanged: (status){
                  //       _addToGoogleCalender = status;
                  //       setState(() {
                  //
                  //       });
                  //
                  //     }),
                  //     Text('Add to Google Calender'),
                  //   ],
                  // ),
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
                    height: 12.0,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MenuButton(
                        child:
                            CategoryButton, // Widget displayed as the button
                        items: _categories, // List of your items
                        topDivider: true,
                        popupHeight:
                            165, // This popupHeight is optional. The default height is the size of items
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
                          FocusScope.of(context).unfocus();
                          if (value == 'Normal')
                            _levelofTask = PriorityLevel.Normal;
                          else if (value == 'Important')
                            _levelofTask = PriorityLevel.Important;
                          else if (value == 'Urgent')
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
                            // enddate: _newTask.enddate,
                            // setalarmfortask: _newTask.setalarmfortask,
                            levelofpriority: _levelofTask,
                          );
                          setState(() {});
                        },
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.0))),
                        itemBackgroundColor: Colors.amber.shade300,
                        menuButtonBackgroundColor: Colors.amber,
                        onMenuButtonToggle: (isToggle) {},
                      ),
                    ),
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
                      minimumSize: Size(100,40),
                      primary: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),),                      ),
                ],
              ),
            ),
        ),
      ),
          ),
    );
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