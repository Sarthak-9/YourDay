import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:menu_button/menu_button.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:yday/models/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';

import 'add_birthday_screen.dart';
import 'auth/login_page.dart';

class AddAnniversary extends StatefulWidget {
  static const routeName = '/add-anniversary-screen';

  @override
  _AddAnniversaryState createState() => _AddAnniversaryState();
}

class _AddAnniversaryState extends State<AddAnniversary> {
  final _husbandnameFocusNode = FocusNode();
  final _wifenameFocusNode = FocusNode();
  final _relationFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  DateTime dateTime;
  TimeOfDay _alarmTime;
  File _imageofCoupleToAdd = File(
    'assets/images/userimage.png',
  );
  var pickedFile;
  var isLoading = false;
  var _loggedIn = false;

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
  bool _yearofAnnivProvidedStat = true;
  CategoryofPerson _categoryofCouple;
  BorderRadius _categoryborderRadius = BorderRadius.all(Radius.circular(40));
  Icon _iconofYearOfAnnivFalse = Icon(
    Icons.check_box_outline_blank_rounded,
    color: Colors.black45,
  );
  Icon _iconofYearOfAnnivTrue = Icon(
    Icons.check_box_rounded,
    color: Colors.red,
  );
  var _editedAnniv = Anniversary(
    anniversaryId: '',
    husband_name: '',
    wife_name: '',
    dateofanniversary: null,
    relation: '',
    notes: '',
    yearofmarriageProvided: true,
    setAlarmforAnniversary: null,
    interestsofCouple: [],
    categoryofCouple: null,
    phoneNumberofCouple: '',
    emailofCouple: '',
    imageofCouple: null,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _husbandnameFocusNode.dispose();
    _wifenameFocusNode.dispose();
    _relationFocusNode.dispose();
    _notesFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    if (_editedAnniv.dateofanniversary == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Date!'),
          content: Text('Enter a valid Date of Marriage.'),
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
    if (!isValid || _editedAnniv.dateofanniversary == null) {
      return;
    }
    // FocusScope.of(context).unfocus();
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      _loggedIn = await Provider.of<Anniversaries>(context, listen: false)
          .addAnniversary(_editedAnniv);
      if(_loggedIn == false){
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'You are not Logged-In',
            ),
            content: Text('Please Login with your credentials or Signup to YourDay to proceed'),
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
        );}
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
      // Provider.of<Anniversaries>(context, listen: false).addAnniversary(_editedAnniv);
         if(_loggedIn) {
        Navigator.of(context).pop();
      }
    }
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  // }

  Future<void> _takePictureofCouple() async {
    pickedFile = await ImagePicker().getImage(
        source: ImageSource
            .gallery,
      imageQuality: 60,
    ); //ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 600,maxHeight: 600,);
    if (pickedFile != null) {
      _imageofCoupleToAdd = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _editedAnniv = Anniversary(
      anniversaryId: Id,
      husband_name: _editedAnniv.husband_name,
      wife_name: _editedAnniv.wife_name,
      dateofanniversary: _editedAnniv.dateofanniversary,
      relation: _editedAnniv.relation,
      notes: _editedAnniv.notes,
      yearofmarriageProvided: _editedAnniv.yearofmarriageProvided,
      setAlarmforAnniversary: _editedAnniv.setAlarmforAnniversary,
      interestsofCouple: _editedAnniv.interestsofCouple,
      categoryofCouple: _editedAnniv.categoryofCouple,
      phoneNumberofCouple: _editedAnniv.phoneNumberofCouple,
      emailofCouple: _editedAnniv.emailofCouple,
      imageofCouple: _imageofCoupleToAdd,
    );
    setState(() {});
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
                        'Add Anniversary',
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
                                    : FileImage(_imageofCoupleToAdd),
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
                                  onPressed: _takePictureofCouple,
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
                                primaryColor:
                                    Colors.red, //const Color(0xFF8CE7F1),
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
                            _editedAnniv = Anniversary(
                              anniversaryId: Id,
                              husband_name: _editedAnniv.husband_name,
                              wife_name: _editedAnniv.wife_name,
                              dateofanniversary: dateTime,
                              relation: _editedAnniv.relation,
                              notes: _editedAnniv.notes,
                              yearofmarriageProvided:
                                  _editedAnniv.yearofmarriageProvided,
                              setAlarmforAnniversary:
                                  _editedAnniv.setAlarmforAnniversary,
                              interestsofCouple: _editedAnniv.interestsofCouple,
                              categoryofCouple: _editedAnniv.categoryofCouple,
                              phoneNumberofCouple:
                                  _editedAnniv.phoneNumberofCouple,
                              emailofCouple: _editedAnniv.emailofCouple,
                              imageofCouple: _editedAnniv.imageofCouple,
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
                            icon: _yearofAnnivProvidedStat
                                ? _iconofYearOfAnnivFalse
                                : _iconofYearOfAnnivTrue,
                            onPressed: () {
                              _yearofAnnivProvidedStat =
                                  !_yearofAnnivProvidedStat;
                              _editedAnniv = Anniversary(
                                anniversaryId: Id,
                                husband_name: _editedAnniv.husband_name,
                                wife_name: _editedAnniv.wife_name,
                                dateofanniversary:
                                    _editedAnniv.dateofanniversary,
                                relation: _editedAnniv.relation,
                                notes: _editedAnniv.notes,
                                yearofmarriageProvided:
                                    _yearofAnnivProvidedStat,
                                setAlarmforAnniversary:
                                    _editedAnniv.setAlarmforAnniversary,
                                interestsofCouple:
                                    _editedAnniv.interestsofCouple,
                                categoryofCouple: _editedAnniv.categoryofCouple,
                                phoneNumberofCouple:
                                    _editedAnniv.phoneNumberofCouple,
                                emailofCouple: _editedAnniv.emailofCouple,
                                imageofCouple: _editedAnniv.imageofCouple,
                              );
                              setState(() {});
                            },
                          ),
                          Text('Year of Marriage not known'),
                        ],
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Husband\'s Name'),
                        textInputAction: TextInputAction.next,
                        focusNode: _husbandnameFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_wifenameFocusNode);
                        },
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: value,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Wife\'s Name'),
                        textInputAction: TextInputAction.next,
                        focusNode: _wifenameFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_relationFocusNode);
                        },
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: value,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Relation'),
                        textInputAction: TextInputAction.next,
                        focusNode: _relationFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_notesFocusNode);
                        },
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a valid relation';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: value,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Notes',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _notesFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_phoneFocusNode);
                        // },
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: value,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Phone Number (Optional)'),
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple: value,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Email (Optional)'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).dispose();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return null;
                          } else if (!value.contains('@')) {
                            return 'Please provide a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: value,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
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
                                  _categoryofCouple = getCategory(value);
                                  _selectedCategory = value.toString();
                                  setState(() {
                                    _categorySelected = true;
                                    _categoryColor = Colors.amber;
                                    _categoryBorder = false;
                                  });
                                  _editedAnniv = Anniversary(
                                    anniversaryId: Id,
                                    husband_name: _editedAnniv.husband_name,
                                    wife_name: _editedAnniv.wife_name,
                                    dateofanniversary:
                                        _editedAnniv.dateofanniversary,
                                    relation: _editedAnniv.relation,
                                    notes: _editedAnniv.notes,
                                    yearofmarriageProvided:
                                        _editedAnniv.yearofmarriageProvided,
                                    setAlarmforAnniversary:
                                        _editedAnniv.setAlarmforAnniversary,
                                    interestsofCouple:
                                        _editedAnniv.interestsofCouple,
                                    categoryofCouple: _categoryofCouple,
                                    phoneNumberofCouple:
                                        _editedAnniv.phoneNumberofCouple,
                                    emailofCouple: _editedAnniv.emailofCouple,
                                    imageofCouple: _editedAnniv.imageofCouple,
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
                                _editedAnniv = Anniversary(
                                  anniversaryId: Id,
                                  husband_name: _editedAnniv.husband_name,
                                  wife_name: _editedAnniv.wife_name,
                                  dateofanniversary:
                                      _editedAnniv.dateofanniversary,
                                  relation: _editedAnniv.relation,
                                  notes: _editedAnniv.notes,
                                  yearofmarriageProvided:
                                      _editedAnniv.yearofmarriageProvided,
                                  setAlarmforAnniversary: _alarmTime,
                                  interestsofCouple:
                                      _editedAnniv.interestsofCouple,
                                  categoryofCouple:
                                      _editedAnniv.categoryofCouple,
                                  phoneNumberofCouple:
                                      _editedAnniv.phoneNumberofCouple,
                                  emailofCouple: _editedAnniv.emailofCouple,
                                  imageofCouple: _editedAnniv.imageofCouple,
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
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            setAlarmforAnniversary:
                                _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _selectedInterests,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                                _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      RaisedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Add Anniversary',
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
