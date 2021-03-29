import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:menu_button/menu_button.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/eventscreen.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/models/interests.dart';

class AddBirthday extends StatefulWidget {
  static const routeName = '/add-birthday-screen';

  @override
  _AddBirthdayState createState() => _AddBirthdayState();
}

class _AddBirthdayState extends State<AddBirthday> {
  final _nameFocusNode = FocusNode();
  final _relationFocusNode = FocusNode();
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

  var pickedFile;
  var isLoading = false;
  String _selectedCategory = 'ABC';
  List<String> _categories = ['Family', 'Friend', 'Work'];
  Color _categoryColor = Colors.red.shade50;
  bool _categoryBorder = true;
  List<Interest> _selectedInterests = [];
  final _items = interestsList
      .map((inter) => MultiSelectItem<Interest>(inter, inter.name))
      .toList();
  var _isInit = true;
  bool _dateSelected = false;
  bool _categorySelected = false;
  bool _yearofBirthProvidedStat = true;
  CategoryofPerson _categoryofPerson;
  BorderRadius _categoryborderRadius = BorderRadius.all(Radius.circular(40));
  Icon _iconofYearOfBirthFalse = Icon(
    Icons.check_box_outline_blank_rounded,
    color: Colors.black45,
  );
  Icon _iconofYearOfBirthTrue = Icon(
    Icons.check_box_rounded,
    color: Colors.red,
  );
  var _editedBirthday = BirthDay(
    birthdayId: '',
    nameofperson: '',
    relation: '',
    dateofbirth: null,
    yearofbirthProvided: true,
    notes: '',
    categoryofPerson: null,
    interestsofPerson: [],
    phoneNumberofPerson: '',
    emailofPerson: '',
    imageofPerson: null,
    setAlarmforBirthday: null,
  );
  var _newBirthday = BirthDay(
    birthdayId: null,
    nameofperson: '',
    relation: '',
    dateofbirth: null,
    notes: '',
    categoryofPerson: null,
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
          title: Text('Select Date!'),
          content: Text('Enter a valid Date of Birth.'),
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
    if (!isValid || _editedBirthday.dateofbirth == null) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Birthdays>(context, listen: false)
          .addBirthday(_editedBirthday);
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
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  // }

  Future<void> _takePictureofPerson() async {
    pickedFile = await ImagePicker().getImage(
        source: ImageSource
            .gallery); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
    if (pickedFile != null) {
      _imageofPersonToAdd = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _editedBirthday = BirthDay(
      birthdayId: Id,
      nameofperson: _editedBirthday.nameofperson,
      relation: _editedBirthday.relation,
      dateofbirth: _editedBirthday.dateofbirth,
      notes: _editedBirthday.notes,
      categoryofPerson: _editedBirthday.categoryofPerson,
      interestsofPerson: _editedBirthday.interestsofPerson,
      yearofbirthProvided: _editedBirthday.yearofbirthProvided,
      phoneNumberofPerson: _editedBirthday.phoneNumberofPerson,
      emailofPerson: _editedBirthday.emailofPerson,
      imageofPerson: _imageofPersonToAdd,
      setAlarmforBirthday: _editedBirthday.setAlarmforBirthday,
    );
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameFocusNode.dispose();
    _notesFocusNode.dispose();
    _relationFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
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
                !_categorySelected ? 'Select Category' : _selectedCategory,
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
                        'Add Birthday',
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
                      OutlineButton(
                        child: Text(
                          _dateSelected
                              ? DateFormat('dd / MM ').format(dateTime)
                              : 'Select Date',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        color: Colors.red.shade50,
                        splashColor: Colors.red.shade50,
                        focusColor: Colors.red,
                        onPressed: () async {
                          dateTime = await PlatformDatePicker.showDate(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 50),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 2),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: const Color(0xFF8CE7F1),
                                accentColor: const Color(0xFF8CE7F1),
                                colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF8CE7F1)),
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
                              relation: _editedBirthday.relation,
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
                              setAlarmforBirthday:
                                  _editedBirthday.setAlarmforBirthday,
                            );
                            setState(() {
                              _dateSelected = true;
                            });
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: _yearofBirthProvidedStat
                                ? _iconofYearOfBirthFalse
                                : _iconofYearOfBirthTrue,
                            onPressed: () {
                              _yearofBirthProvidedStat =
                                  !_yearofBirthProvidedStat;
                              _editedBirthday = BirthDay(
                                birthdayId: Id,
                                nameofperson: _editedBirthday.nameofperson,
                                relation: _editedBirthday.relation,
                                dateofbirth: _editedBirthday.dateofbirth,
                                notes: _editedBirthday.notes,
                                categoryofPerson:
                                    _editedBirthday.categoryofPerson,
                                interestsofPerson:
                                    _editedBirthday.interestsofPerson,
                                yearofbirthProvided: _yearofBirthProvidedStat,
                                phoneNumberofPerson:
                                    _editedBirthday.phoneNumberofPerson,
                                emailofPerson: _editedBirthday.emailofPerson,
                                imageofPerson: _editedBirthday.imageofPerson,
                                setAlarmforBirthday:
                                    _editedBirthday.setAlarmforBirthday,
                              );
                              setState(() {});
                            },
                          ),
                          Text('Year of Birth not known'),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_relationFocusNode);
                        },
                        textCapitalization: TextCapitalization.words,
                        focusNode: _nameFocusNode,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: value,
                            relation: _editedBirthday.relation,
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
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Relation'),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_notesFocusNode);
                        },
                        focusNode: _relationFocusNode,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            relation: value,
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
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid relation';
                          }
                          return null;
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
                        focusNode: _notesFocusNode,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: DateTime.now().toString(),
                            nameofperson: _editedBirthday.nameofperson,
                            relation: _editedBirthday.relation,
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
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Phone Number (Optional)'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            relation: _editedBirthday.relation,
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
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
                          );
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
                        decoration:
                            InputDecoration(labelText: 'Email (Optional)'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).dispose();
                        },
                        focusNode: _emailFocusNode,
                        onSaved: (value) {
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            relation: _editedBirthday.relation,
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
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
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
                          vertical: 4.0,
                        ),
                      ),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                  if (value == 'Friend')
                                    _categoryofPerson = CategoryofPerson.friend;
                                  else if (value == 'Family')
                                    _categoryofPerson = CategoryofPerson.family;
                                  else if (value == 'Work')
                                    _categoryofPerson = CategoryofPerson.work;
                                  _selectedCategory = value.toString();
                                  setState(() {
                                    _categorySelected = true;
                                    _categoryColor = Colors.amber;
                                    _categoryBorder = false;
                                  });
                                  _editedBirthday = BirthDay(
                                    birthdayId: DateTime.now().toString(),
                                    nameofperson: _editedBirthday.nameofperson,
                                    relation: _editedBirthday.relation,
                                    dateofbirth: _editedBirthday.dateofbirth,
                                    notes: _editedBirthday.notes,
                                    categoryofPerson: _categoryofPerson,
                                    interestsofPerson:
                                        _editedBirthday.interestsofPerson,
                                    yearofbirthProvided:
                                        _editedBirthday.yearofbirthProvided,
                                    phoneNumberofPerson:
                                        _editedBirthday.phoneNumberofPerson,
                                    emailofPerson:
                                        _editedBirthday.emailofPerson,
                                    setAlarmforBirthday:
                                        _editedBirthday.setAlarmforBirthday,
                                  );
                                },
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(3.0))),
                                itemBackgroundColor: Colors.amber,
                                menuButtonBackgroundColor: Colors.amber,
                                onMenuButtonToggle: (isToggle) {
                                  print(isToggle);
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0)),
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
                                _editedBirthday = BirthDay(
                                  birthdayId: Id,
                                  nameofperson: _editedBirthday.nameofperson,
                                  relation: _editedBirthday.relation,
                                  dateofbirth: _editedBirthday.dateofbirth,
                                  notes: _editedBirthday.notes,
                                  categoryofPerson:
                                      _editedBirthday.categoryofPerson,
                                  setAlarmforBirthday: _alarmTime,
                                  interestsofPerson:
                                      _editedBirthday.interestsofPerson,
                                  yearofbirthProvided:
                                      _editedBirthday.yearofbirthProvided,
                                  phoneNumberofPerson:
                                      _editedBirthday.phoneNumberofPerson,
                                  emailofPerson: _editedBirthday.emailofPerson,
                                );
                                setState(() {});
                              }),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      MultiSelectDialogField(
                        searchTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        itemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        selectedItemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        searchable: true,
                        items: _items,
                        title: Text("Interests"),
                        selectedColor: Colors.amber,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.category,
                          color: Colors.red,
                        ),
                        buttonText: Text(
                          "Interests",
                          style: TextStyle(
                            //color: Colors.amberAccent[800],
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          _selectedInterests = results;
                          _editedBirthday = BirthDay(
                            birthdayId: Id,
                            nameofperson: _editedBirthday.nameofperson,
                            relation: _editedBirthday.relation,
                            dateofbirth: _editedBirthday.dateofbirth,
                            notes: _editedBirthday.notes,
                            categoryofPerson: _categoryofPerson,
                            interestsofPerson: _selectedInterests,
                            yearofbirthProvided:
                                _editedBirthday.yearofbirthProvided,
                            phoneNumberofPerson:
                                _editedBirthday.phoneNumberofPerson,
                            emailofPerson: _editedBirthday.emailofPerson,
                            setAlarmforBirthday:
                                _editedBirthday.setAlarmforBirthday,
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      RaisedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Add Birthday',
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

// child: Column(
// children: [
// TextField(
// decoration: InputDecoration(
// hintText: 'Name',
// ),
// controller: _nameController,
// //onSubmitted: addd//),
// ),
// TextField(
// decoration: InputDecoration(
// hintText: 'Relation',
// ),
// controller: _relationController,
// //onSubmitted: addd//),
// ),
// TextField(
// decoration: InputDecoration(
// hintText: 'Notes',
// ),
// controller: _notesController,
// //onSubmitted: addd//),
// ),
// RaisedButton(onPressed: addd,
// child: Text('Add Birthday'),),
// // TextField(
// //     decoration: InputDecoration(
// //       hintText: 'Name',
// //     ),
// //     controller: _nameController,
// //     onSubmitted: addd//),
// // ),
// RaisedButton(onPressed:() {
// Navigator.of(context).pushNamed(HomePage.routeName);
// },
// child: Text('Add '),),
// ],
//),

// Row(
//   children: [
//     TextFormField(
//
//       decoration: InputDecoration(labelText: 'Date of Birth'),
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (_) {
//         FocusScope.of(context).requestFocus(_nameFocusNode);
//       },
//       onSaved: (value) {
//         _editedBirthday = BirthDay(
//           id: Id,
//           name: _editedBirthday.name,
//           relation: _editedBirthday.relation,
//           dateofbirth: _editedBirthday.dateofbirth,
//           notes: _editedBirthday.notes,
//         );
//       },
//     ),
//Text(''),

//],
// ),
// TextFormField(
//   decoration: InputDecoration(labelText: 'Date of Birthday'),
//   textInputAction: TextInputAction.next,
//   onFieldSubmitted: (_){
//     FocusScope.of(context).requestFocus(_nameFocusNode);
//   },
//   onSaved: (value){
//     _editedBirthday = BirthDay(
//       id: DateTime.now().toString(),
//       name: _editedBirthday.name,
//       relation: _editedBirthday.relation,
//       dateofbirth: value,
//       notes: _editedBirthday.notes,
//     );
//   },
// ),

// Container(
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: MenuButton(
//       child: InterestButton,
//       items: _interests, // List of your items
//       topDivider: true,
//       popupHeight:
//       200, // This popupHeight is optional. The default height is the size of items
//       scrollPhysics:
//       AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
//       itemBuilder: (value) => Container(
//           width: 100,
//           height: 40,
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(value)), // Widget displayed for each item
//       toggledChild: Container(
//         child: InterestButton, // Widget displayed as the button,
//       ),
//       divider: Container(
//         height: 1,
//         color: Colors.grey,
//       ),
//       onItemSelected: (value) {
//         if(value == 'Friend')
//           _categoryofPerson = CategoryofPerson.friend;
//         else if (value == ' Family')
//           _categoryofPerson = CategoryofPerson.family;
//         else if (value == 'Work')
//           _categoryofPerson = CategoryofPerson.work;
//         _selectedCategory = value;
//         setState(() {});
//         _editedBirthday = BirthDay(
//           id: DateTime.now().toString(),
//           name: _editedBirthday.name,
//           relation: _editedBirthday.relation,
//           dateofbirth: _editedBirthday.dateofbirth,
//           notes: _editedBirthday.notes,
//           catergory: _categoryofPerson,
//         );
//       },
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]),
//           borderRadius:
//           const BorderRadius.all(Radius.circular(3.0))),
//       itemBackgroundColor: Colors.amber,
//       menuButtonBackgroundColor: Colors.amber,
//       onMenuButtonToggle: (isToggle) {
//         print(isToggle);
//       },
//     ),
//   ),
// ),
