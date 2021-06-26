import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:menu_button/menu_button.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/services/google_calender_repository.dart';
import 'package:yday/services/google_signin_repository.dart';

import '../homepage.dart';

class EditBirthdayScreen extends StatefulWidget {
  static const routeName = '/edit-birthday-screen';
  BirthDay fetchedBirthday ;

  EditBirthdayScreen(this.fetchedBirthday);

  @override
  _EditBirthdayScreenState createState() => _EditBirthdayScreenState();
}

class _EditBirthdayScreenState extends State<EditBirthdayScreen> {
  final _notesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  DateTime dateTime;
  TimeOfDay _alarmTime;
  File _imageofPersonToAdd = File(
    'assets/images/userimage.png',
  );
  String birthdayId = '';
  String birthdayNotes = '';
  String birthdayPhone = '';
  String birthdayEmail = '';
  TimeOfDay birthdayTime;

  var pickedFile;
  var isLoading = false;
  List<Interest> _selectedInterests = [];
  final _items = interestsList
      .map((inter) => MultiSelectItem<Interest>(inter, inter.name))
      .toList();
  var _isInit = true;
  bool _addToGoogleCalender = false;
  CategoryofPerson _categoryofPerson;
  BirthDay _editedBirthday;
  @override
  void initState() {
    _editedBirthday = widget.fetchedBirthday;
    birthdayTime = _editedBirthday.setAlarmforBirthday;
    _alarmTime = birthdayTime;
    birthdayId = _editedBirthday.birthdayId;
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid || _editedBirthday.dateofbirth == null) {
      return;
    }
    FocusScope.of(context).unfocus();
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      // String calenderId = null;
      // if(_addToGoogleCalender){
      //   calenderId = await addCalender();
      // }
      BirthDay updatedBirthday = BirthDay(
        birthdayId: birthdayId,
        interestsofPerson: _selectedInterests,
        phoneNumberofPerson: birthdayPhone,
        dateofbirth: _editedBirthday.dateofbirth,
        notes: birthdayNotes,
        emailofPerson: birthdayEmail,
        imageUrl: _editedBirthday.imageUrl,
        imageofPerson: pickedFile != null?_imageofPersonToAdd:null,
        setAlarmforBirthday: birthdayTime,
      );
      await Provider.of<Birthdays>(context, listen: false)
          .editBirthday(updatedBirthday);

    } catch (error) {
      print(error);
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
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  Future<void> _takePictureofPerson() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    ); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
    if (pickedFile != null) {
      _imageofPersonToAdd = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notesFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {

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
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      Text(
                        'Edit Birthday',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: pickedFile == null
                                    ? AssetImage('assets/images/userimage.png')
                                    : FileImage(_imageofPersonToAdd),
                                radius:
                                    MediaQuery.of(context).size.width * 0.18,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(0.25),
                                radius:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt_outlined),
                                  onPressed: _takePictureofPerson,
                                  iconSize:
                                      MediaQuery.of(context).size.width * 0.10,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      ElevatedButton(
                          child:  _alarmTime != null?Text(
                            _alarmTime.format(context),
                            style: TextStyle(color: Colors.black),
                          ): Row(
                            children: [
                              Icon(Icons.notifications,color: Colors.black,size: 15,),
                              SizedBox(width: 4,),
                              Text('Notification Time',style: TextStyle(
                                color: Colors.black,
                              ),),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(120, 40),
                            primary: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).accentColor),
                          ),
                          onPressed: () async {
                            _alarmTime = await showCustomTimePicker(
                                context: context,
                                onFailValidation: (context) =>
                                    print('Unavailable selection'),
                                initialTime: TimeOfDay(hour: 0, minute: 0));
                            birthdayTime = _alarmTime;
                            setState(() {});
                          }),
                      ListTile(
                        title: Text('Name'),
                        trailing: Text(_editedBirthday.nameofperson),
                      ),

                      ListTile(
                        title: Text('Gender'),
                        trailing: Text(_editedBirthday.gender),
                      ),
                      ListTile(
                        title: Text('Date'),
                        trailing: _editedBirthday.yearofbirthProvided
                            ? Text(
                          DateFormat('EEEE, MMM dd, yyyy')
                              .format(_editedBirthday.dateofbirth),
                          //textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        )
                            : Text(DateFormat('EEEE, MMM dd')
                            .format(_editedBirthday.dateofbirth)),
                      ),
                      ListTile(
                        title: Text('Category'),
                        trailing: Text(categoryText(_editedBirthday.categoryofPerson)),
                      ),
                      TextFormField(
                        initialValue: _editedBirthday.phoneNumberofPerson,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          birthdayPhone = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return null;
                          } else if (value.length != 10) {
                            return 'Please provide a valid phone number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedBirthday.emailofPerson,
                        decoration:
                            InputDecoration(labelText: 'Email'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).dispose();
                        },
                        focusNode: _emailFocusNode,
                        onSaved: (value) {
                          birthdayEmail = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return null;
                          } else if (!value.contains('@')) {
                            return 'Please provide a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedBirthday.notes,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                        ),
                        focusNode: _notesFocusNode,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                        onSaved: (value) {
                          birthdayNotes = value;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      MultiSelectBottomSheetField(
                        searchTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        itemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        listType: MultiSelectListType.CHIP,
                        selectedItemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        searchable: true,
                        items: _items,
                        title: Text("Interests", style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),),
                        decoration: BoxDecoration(),
                        selectedColor: Colors.amber,
                        buttonIcon: Icon(
                          Icons.add_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        buttonText: Text(
                          'Select interests :',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          _selectedInterests = results;

                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Edit Birthday',
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

  Future<String> addCalender() async {
    GoogleSignInAccount account =
        Provider.of<GoogleAccountRepository>(context, listen: false)
            .googleSignInAccount;
    String title = _editedBirthday.nameofperson + '\'s Birthday';
    var currentTime = _editedBirthday.dateofbirth;
    DateTime startTime, endTime, dt = currentTime;
    DateTime dtnow = DateTime.now();
    if (currentTime.year == dtnow.year &&
        currentTime.month == dtnow.month &&
        currentTime.day == dtnow.day) {
      dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
    } else {
      if (currentTime.isBefore(dtnow)) {
        dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
      }
      if (dt.isBefore(dtnow)) {
        dt = DateTime(dtnow.year + 1, currentTime.month, currentTime.day);
      }
      // else if(currentTime){
      //
      // }
      else if (dt.isBefore(dtnow)) {
        dt = DateTime(dtnow.year + 1, currentTime.month, currentTime.day);
      }
    }
    if (_editedBirthday.setAlarmforBirthday != null) {
      var alarmTime = _editedBirthday.setAlarmforBirthday;
      startTime =
          DateTime(dt.year, dt.month, dt.day, alarmTime.hour, alarmTime.minute);
    } else {
      startTime = DateTime(dt.year, dt.month, dt.day, 10, 00);
    }
    endTime = DateTime(startTime.year, startTime.month, startTime.day,
        (startTime.hour + 1), startTime.minute, 00);
    GoogleCalenderModel calenderModel = GoogleCalenderModel(
        title: title,
        description: _editedBirthday.notes,
        startTime: startTime,
        endTime: endTime);
    CalendarClient cal = CalendarClient();
    String calId = await cal.insertCalender(account, calenderModel);
    return calId;
  }
}