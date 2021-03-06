import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart' as tpw;
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/models/interests.dart';
import '../homepage.dart';

class AddBirthday extends StatefulWidget {
  static const routeName = '/add-birthday-screen';

  @override
  _AddBirthdayState createState() => _AddBirthdayState();
}

class _AddBirthdayState extends State<AddBirthday> {
  final phoneController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  DateTime dateTime;
  TimeOfDay _alarmTime;
  File _imageofPersonToAdd = File(
    'assets/images/userimage.png',
  );
  String countryCode = '+91';
  String phoneNumber;

  var pickedFile;
  bool isLoading = false;
  List<Interest> _selectedInterests = [];
  final _items = interestsList
      .map((inter) => MultiSelectItem<Interest>(inter, inter.name))
      .toList();
  bool _loggedIn = false;
  bool _yearofBirthProvidedStat = false;
  CategoryofPerson _categoryofPerson;
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  Contact _contact;
  String _selectedCategory = 'Others';
  int categoryNumber = 3;
  String _selectedGender = 'Female';
  int genderNumber = 1;
  BirthDay _editedBirthday = BirthDay(
    birthdayId: '',
    nameofperson: '',
    gender: '',
    dateofbirth: null,
    yearofbirthProvided: true,
    notes: '',
    categoryofPerson: null,
    interestsofPerson: [],
    phoneNumberofPerson: '',
    emailofPerson: '',
    imageofPerson: null,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveForm() async {
    if (_editedBirthday.dateofbirth == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Set Date!'),
          content: Text('Set valid Date of Birth.'),
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
    if (_alarmTime == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Notification Time!'),
          content: Text('Set valid notification time.'),
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
    if (!isValid) {
      return;
    }
    FocusScope.of(context).unfocus();
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      if(_editedBirthday.phoneNumberofPerson!=null){
        phoneNumber = countryCode+_editedBirthday.phoneNumberofPerson;
      }else{
        phoneNumber = _editedBirthday.phoneNumberofPerson;
      }
      DateTime eventDate = DateTimeField.combine(dateTime, _alarmTime);
      _editedBirthday = BirthDay(
        birthdayId: Id,
        nameofperson: _editedBirthday.nameofperson,
        gender: _selectedGender,
        dateofbirth: eventDate,
        notes: _editedBirthday.notes,
        categoryofPerson: getCategory(_selectedCategory),
        interestsofPerson: _editedBirthday.interestsofPerson,
        yearofbirthProvided: _editedBirthday.yearofbirthProvided,
        phoneNumberofPerson: phoneNumber,
        emailofPerson: _editedBirthday.emailofPerson,
        imageofPerson: _editedBirthday.imageofPerson,
      );
      _loggedIn = await Provider.of<Birthdays>(context, listen: false)
          .addBirthday(_editedBirthday);
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
    );
    if (pickedFile != null) {
      _imageofPersonToAdd = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _editedBirthday = BirthDay(
      birthdayId: Id,
      nameofperson: _editedBirthday.nameofperson,
      gender: _editedBirthday.gender,
      dateofbirth: _editedBirthday.dateofbirth,
      notes: _editedBirthday.notes,
      categoryofPerson: _editedBirthday.categoryofPerson,
      interestsofPerson: _editedBirthday.interestsofPerson,
      yearofbirthProvided: _editedBirthday.yearofbirthProvided,
      phoneNumberofPerson: _editedBirthday.phoneNumberofPerson,
      emailofPerson: _editedBirthday.emailofPerson,
      imageofPerson: _imageofPersonToAdd,
    );
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
            child: Image.asset(
              "assets/images/Main_logo.png",
              height: 60,
              width: 100,
            )),
        titleSpacing: 0.1,
        centerTitle: true,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _takePictureofPerson,
                                child: CircleAvatar(
                                  backgroundImage: pickedFile == null
                                      ? AssetImage('assets/images/userimage.png')
                                      : FileImage(_imageofPersonToAdd),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: dateTime != null
                                ? Text(
                                    DateFormat('MMM dd').format(dateTime),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Select Date',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(140, 40),
                              primary: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).accentColor),
                            ),
                            onPressed: () async {
                              dateTime = await PlatformDatePicker.showDate(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 50),
                                initialDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
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
                              );
                              if (dateTime != null) {
                                _editedBirthday = BirthDay(
                                  birthdayId: Id,
                                  nameofperson: _editedBirthday.nameofperson,
                                  gender: _editedBirthday.gender,
                                  dateofbirth: dateTime,
                                  notes: _editedBirthday.notes,
                                  categoryofPerson:
                                      _editedBirthday.categoryofPerson,
                                  interestsofPerson:
                                      _editedBirthday.interestsofPerson,
                                  yearofbirthProvided:
                                      _editedBirthday.yearofbirthProvided,
                                  phoneNumberofPerson:
                                      _editedBirthday.phoneNumberofPerson,
                                  emailofPerson: _editedBirthday.emailofPerson,
                                  imageofPerson: _editedBirthday.imageofPerson,
                                );
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                setState(() {});
                              }
                            },
                          ),
                          ElevatedButton(
                              child: _alarmTime != null
                                  ? Text(
                                      _alarmTime.format(context),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'Notification Time',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(140, 40),
                                primary: MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).accentColor),
                              ),
                              onPressed: () async {
                                _alarmTime = await tpw.showCustomTimePicker(
                                    context: context,
                                    initialEntryMode:
                                        tpw.TimePickerEntryMode.input,
                                    onFailValidation: (context) =>
                                        print('Unavailable selection'),
                                    initialTime:
                                        TimeOfDay(hour: 10, minute: 0));
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                setState(() {});
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(
                              value: _yearofBirthProvidedStat,
                              onChanged: (status) {
                                _yearofBirthProvidedStat = status;
                                setState(() {});
                                _editedBirthday = BirthDay(
                                  birthdayId: Id,
                                  nameofperson: _editedBirthday.nameofperson,
                                  gender: _editedBirthday.gender,
                                  dateofbirth: _editedBirthday.dateofbirth,
                                  notes: _editedBirthday.notes,
                                  categoryofPerson:
                                      _editedBirthday.categoryofPerson,
                                  interestsofPerson:
                                      _editedBirthday.interestsofPerson,
                                  yearofbirthProvided:
                                      !_yearofBirthProvidedStat,
                                  phoneNumberofPerson:
                                      _editedBirthday.phoneNumberofPerson,
                                  emailofPerson: _editedBirthday.emailofPerson,
                                  imageofPerson: _editedBirthday.imageofPerson,
                                );
                              }),
                          Text('Year of Birth not known'),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name *'),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: value,
                            gender: _editedBirthday.gender,
                            dateofbirth: _editedBirthday.dateofbirth,
                            notes: _editedBirthday.notes,
                            categoryofPerson: _editedBirthday.categoryofPerson,
                            interestsofPerson:
                                _editedBirthday.interestsofPerson,
                            yearofbirthProvided:
                                _editedBirthday.yearofbirthProvided,
                            phoneNumberofPerson:
                                _editedBirthday.phoneNumberofPerson,
                            emailofPerson: _editedBirthday.emailofPerson,
                            imageofPerson: _editedBirthday.imageofPerson,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid name';
                          }
                          return null;
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: '+91',
                            keyboardType: TextInputType.number,
                            onSaved: (value){
                              countryCode = value;
                            },
                          ),
                        ),
                        title: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.contact_page_outlined),
                                  onPressed: () async {
                                    PermissionStatus permission =
                                        await Permission.contacts.status;
                                    if (permission != PermissionStatus.granted &&
                                        permission !=
                                            PermissionStatus.permanentlyDenied) {
                                      PermissionStatus permissionStatus =
                                          await Permission.contacts.request();
                                      permission = await Permission.contacts.status;
                                    }
                                    if (permission.isGranted) {
                                      Contact contact =
                                          await _contactPicker.selectContact();
                                      setState(() {
                                        _contact = contact;
                                      });
                                      phoneController.text = _contact.phoneNumber;
                                    }
                                  },
                                )),
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _editedBirthday = BirthDay(
                                birthdayId: Id,
                                nameofperson: _editedBirthday.nameofperson,
                                gender: _editedBirthday.gender,
                                dateofbirth: _editedBirthday.dateofbirth,
                                notes: _editedBirthday.notes,
                                categoryofPerson: _editedBirthday.categoryofPerson,
                                interestsofPerson:
                                    _editedBirthday.interestsofPerson,
                                yearofbirthProvided:
                                    _editedBirthday.yearofbirthProvided,
                                phoneNumberofPerson: value,
                                emailofPerson: _editedBirthday.emailofPerson,
                                imageofPerson: _editedBirthday.imageofPerson,
                                );
                            },

                          ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).dispose();
                        },
                        // focusNode: _emailFocusNode,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            gender: _editedBirthday.gender,
                            dateofbirth: _editedBirthday.dateofbirth,
                            notes: _editedBirthday.notes,
                            categoryofPerson: _editedBirthday.categoryofPerson,
                            interestsofPerson:
                                _editedBirthday.interestsofPerson,
                            yearofbirthProvided:
                                _editedBirthday.yearofbirthProvided,
                            phoneNumberofPerson:
                                _editedBirthday.phoneNumberofPerson,
                            emailofPerson: value,
                            imageofPerson: _editedBirthday.imageofPerson,
                            // setAlarmforBirthday:
                            //     _editedBirthday.setAlarmforBirthday,
                          );
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Gender :',
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
                              selectGender(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Male',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: genderNumber == 0
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectGender(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Female',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: genderNumber == 1
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectGender(2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Other',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: genderNumber == 2
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
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
                                  'Family',
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
                                  'Friend',
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
                          GestureDetector(
                            onTap: () {
                              selectCategory(3);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Text(
                                  'Others',
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3.0,
                                backgroundColor: categoryNumber == 3
                                    ? Colors.amber
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      MultiSelectBottomSheetField(
                        listType: MultiSelectListType.CHIP,
                        itemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        validator: (values) {
                          if (values == null || values.length <= 3) return null;
                          return 'Choose max 3 tags only';
                        },
                        autovalidateMode: AutovalidateMode.always,
                        selectedItemsTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        // searchable: true,
                        items: _items,
                        title: Text(
                          "Interests",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        selectedColor: Colors.amber,
                        decoration: BoxDecoration(),

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
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            gender: _editedBirthday.gender,
                            dateofbirth: _editedBirthday.dateofbirth,
                            notes: _editedBirthday.notes,
                            categoryofPerson: _categoryofPerson,
                            interestsofPerson: _selectedInterests,
                            yearofbirthProvided:
                                _editedBirthday.yearofbirthProvided,
                            phoneNumberofPerson:
                                _editedBirthday.phoneNumberofPerson,
                            emailofPerson: _editedBirthday.emailofPerson,
                            // setAlarmforBirthday:
                            //     _editedBirthday.setAlarmforBirthday,
                            imageofPerson: _editedBirthday.imageofPerson,
                          );
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Notes',
                        ),
                        //textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_phoneFocusNode);
                        // },
                        // focusNode: _notesFocusNode,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: DateTime.now().toString(),
                            nameofperson: _editedBirthday.nameofperson,
                            gender: _editedBirthday.gender,
                            dateofbirth: _editedBirthday.dateofbirth,
                            notes: value,
                            categoryofPerson: _editedBirthday.categoryofPerson,
                            interestsofPerson:
                                _editedBirthday.interestsofPerson,
                            yearofbirthProvided:
                                _editedBirthday.yearofbirthProvided,
                            phoneNumberofPerson:
                                _editedBirthday.phoneNumberofPerson,
                            emailofPerson: _editedBirthday.emailofPerson,
                            imageofPerson: _editedBirthday.imageofPerson,
                            // setAlarmforBirthday:
                            //     _editedBirthday.setAlarmforBirthday,
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Add Birthday',
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
        _selectedCategory = 'Family';
        break;
      case 1:
        _selectedCategory = 'Friend';
        break;
      case 2:
        _selectedCategory = 'Work';
        break;
      case 3:
        _selectedCategory = 'Others';
        break;
      default:
        _selectedCategory = 'Others';
    }
    setState(() {
      categoryNumber = catNumber;
    });
  }

  void selectGender(int genNumber) {
    switch (genNumber) {
      case 0:
        _selectedGender = 'Male';
        break;
      case 1:
        _selectedGender = 'Female';
        break;
      case 2:
        _selectedGender = 'Other';
        break;
      default:
        _selectedCategory = 'None';
    }
    setState(() {
      genderNumber = genNumber;
    });
  }
  // Future<String> addCalender() async {
  //   GoogleSignInAccount account =
  //       Provider.of<GoogleAccountRepository>(context, listen: false)
  //           .googleSignInAccount;
  //   String title = _editedBirthday.nameofperson + '\'s Birthday';
  //   var currentTime = _editedBirthday.dateofbirth;
  //   DateTime startTime, endTime, dt = currentTime;
  //   DateTime dtnow = DateTime.now();
  //   if (currentTime.year == dtnow.year &&
  //       currentTime.month == dtnow.month &&
  //       currentTime.day == dtnow.day) {
  //     dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
  //   } else {
  //     if (currentTime.isBefore(dtnow)) {
  //       dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
  //     }
  //     if (dt.isBefore(dtnow)) {
  //       dt = DateTime(dtnow.year + 1, currentTime.month, currentTime.day);
  //     }
  //     // else if(currentTime){
  //     //
  //     // }
  //     else if (dt.isBefore(dtnow)) {
  //       dt = DateTime(dtnow.year + 1, currentTime.month, currentTime.day);
  //     }
  //   }
  //   if (_editedBirthday.setAlarmforBirthday != null) {
  //     var alarmTime = _editedBirthday.setAlarmforBirthday;
  //     startTime =
  //         DateTime(dt.year, dt.month, dt.day, alarmTime.hour, alarmTime.minute);
  //   } else {
  //     startTime = DateTime(dt.year, dt.month, dt.day, 10, 00);
  //   }
  //   endTime = DateTime(startTime.year, startTime.month, startTime.day,
  //       (startTime.hour + 1), startTime.minute, 00);
  //   GoogleCalenderModel calenderModel = GoogleCalenderModel(
  //       title: title,
  //       description: _editedBirthday.notes,
  //       startTime: startTime,
  //       endTime: endTime);
  //   CalendarClient cal = CalendarClient();
  //   String calId = await cal.insertCalender(account, calenderModel);
  //   return calId;
  // }
}
