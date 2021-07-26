import 'package:flutter/src/material/time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:menu_button/menu_button.dart';
import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
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
  final _descriptionController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  DateTime dateTime;
  var pickedFile;
  bool isLoading = false;
  bool _loggedIn = false;
  DateTime _taskStartDate;
  String _selectedCategory = 'Others';
  int categoryNumber = 3;
  String _selectedFrequency = 'Once';
  int frequencyNumber = 3;
  final format = DateFormat("dd / MM / yyyy -- HH:mm");
  Task _newTask = Task(
    taskId: '',
    title: '',
    description: '',
    startdate: null,
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
    try {
      _newTask = Task(
          taskId: Id,
          title: _newTask.title,
          description: _newTask.description,
          startdate: _newTask.startdate,
          frequency: _selectedFrequency,
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
                                  'Personal',
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
                                  'Home',
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
                                  'Work',
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
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){
                          if(_descriptionController.text.isNotEmpty) {
                          _descriptionController.text =
                              _descriptionController.text + '\n - ';
                          // _descriptionController.
                          // _descriptionFocusNode.requestFocus();
                          // _descriptionController.selection = TextSelection.collapsed(offset: _descriptionController.text.length);
                          _descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: _descriptionController.text.length));
                          } else {
                                _descriptionController.text =
                                    _descriptionController.text + ' - ';
                          // _descriptionController.selection =TextSelection.collapsed(
                          //     offset: _descriptionController.text.length);
                          _descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: _descriptionController.text.length));
                          }
                          _descriptionFocusNode.requestFocus();
                          // _descriptionFocusNode.requestFocus();
                          // setState(() {});
                        }, child: Text('Add Bullet')),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          // suffixIcon:
                        ),
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).dispose();
                        },
                        autofocus: true,
                        // scrollController: ScrollController,
                        maxLines: 3,
                        onSaved: (value) {
                          _newTask = Task(
                            taskId: Id,
                            title: _newTask.title,
                            description: value,
                            startdate: _newTask.startdate,
                            levelofpriority: _newTask.levelofpriority,
                          );
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0)),

                        child: Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                            ),
                          ),
                          Text(
                            'Select Date and Time',
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
                                levelofpriority: _newTask.levelofpriority,
                              );
                            },
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Frequency :',
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
                              selectFrequency(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Once',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: frequencyNumber == 0
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectFrequency(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Daily',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: frequencyNumber == 1
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectFrequency(2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Weekly',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: frequencyNumber == 2
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
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
        _selectedCategory = 'Personal';
        break;
      case 1:
        _selectedCategory = 'Home';
        break;
      case 2:
        _selectedCategory = 'Work';
        break;

      default:
        _selectedCategory = 'Normal';
    }
    setState(() {
      categoryNumber = catNumber;
    });
  }
  void selectFrequency(int freqNumber) {
    switch (freqNumber) {
      case 0:
        _selectedFrequency = 'Once';
        break;
      case 1:
        _selectedFrequency = 'Daily';
        break;
      case 2:
        _selectedFrequency = 'Weekly';
        break;

      default:
        _selectedFrequency = 'Once';
    }
    setState(() {
      frequencyNumber = freqNumber;
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
