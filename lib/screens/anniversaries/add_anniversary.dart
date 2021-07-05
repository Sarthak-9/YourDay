import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart'as tpw;
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/services/google_signin_repository.dart';
import '../all_event_screen.dart';
import '../auth/login_page.dart';
import 'package:yday/services/google_calender_repository.dart';

import '../homepage.dart';

class AddAnniversary extends StatefulWidget {
  static const routeName = '/add-anniversary-screen';

  @override
  _AddAnniversaryState createState() => _AddAnniversaryState();
}

class _AddAnniversaryState extends State<AddAnniversary> {
  // final _husbandnameFocusNode = FocusNode();
  // final _wifenameFocusNode = FocusNode();
  // final _relationFocusNode = FocusNode();
  // final _notesFocusNode = FocusNode();
  // final _phoneFocusNode = FocusNode();
  // final _emailFocusNode = FocusNode();
  final phoneController = TextEditingController();

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
  // bool _addToGoogleCalender = false;
  List<String> _categories = ['Family', 'Friend', 'Work','Others'];
  Color _categoryColor = Colors.red.shade50;
  bool _categoryBorder = true;
  List<Interest> _selectedInterests = [];
  final _items = interestsList
      .map((inter) => MultiSelectItem<Interest>(inter, inter.name))
      .toList();
  bool _categorySelected = false;
  bool _yearofAnnivProvidedStat = false;
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  Contact _contact;
  String _selectedCategory = 'Others';
  int categoryNumber = 3;
  var _editedAnniv = Anniversary(
    anniversaryId: '',
    husband_name: '',
    wife_name: '',
    dateofanniversary: null,
    notes: '',
    yearofmarriageProvided: true,
    // setAlarmforAnniversary: null,
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
    // _husbandnameFocusNode.dispose();
    // _wifenameFocusNode.dispose();
    // _relationFocusNode.dispose();
    // _notesFocusNode.dispose();
    // _phoneFocusNode.dispose();
    // _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    if (_editedAnniv.dateofanniversary == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Date!'),
          content: Text('Enter a valid date and time of event.'),
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
      return;}
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      String calenderId = null;
      // print(_addToGoogleCalender);
      // if(_addToGoogleCalender){
      //   calenderId = await addCalender();
      // }
      DateTime eventDate = DateTimeField.combine(dateTime, _alarmTime);
      _editedAnniv = Anniversary(
        anniversaryId: Id,
        calenderId: calenderId,
        husband_name: _editedAnniv.husband_name,
        wife_name: _editedAnniv.wife_name,
        dateofanniversary: eventDate,
        // relation: _editedAnniv.relation,
        notes: _editedAnniv.notes,
        yearofmarriageProvided: _editedAnniv.yearofmarriageProvided,
        // setAlarmforAnniversary: _alarmTime,
        interestsofCouple: _editedAnniv.interestsofCouple,
        categoryofCouple: getCategory(_selectedCategory),
        phoneNumberofCouple: _editedAnniv.phoneNumberofCouple,
        emailofCouple: _editedAnniv.emailofCouple,
        imageofCouple: _editedAnniv.imageofCouple,
      );
      _loggedIn = await Provider.of<Anniversaries>(context, listen: false)
          .addAnniversary(_editedAnniv);
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
    }
      setState(() {
        isLoading = false;
      });
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);

    // Navigator.of(context).pushReplacementNamed(AllEvents.routeName,arguments: 2);

  }

  Future<void> _takePictureofCouple() async {
    pickedFile = await ImagePicker().getImage(
        source: ImageSource
            .gallery,
      imageQuality: 60,
    );
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
      // relation: _editedAnniv.relation,
      notes: _editedAnniv.notes,
      yearofmarriageProvided: _editedAnniv.yearofmarriageProvided,
      // setAlarmforAnniversary: _editedAnniv.setAlarmforAnniversary,
      interestsofCouple: _editedAnniv.interestsofCouple,
      categoryofCouple:_editedAnniv.categoryofCouple,
      phoneNumberofCouple: _editedAnniv.phoneNumberofCouple,
      emailofCouple: _editedAnniv.emailofCouple,
      imageofCouple: _imageofCoupleToAdd,
    );
    setState(() {});
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
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      // Text(
                      //   'Add Anniversary',
                      //   style: TextStyle(
                      //     fontSize: 24.0,
                      //   ),
                      // ),
                      // Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _takePictureofCouple,
                                child: CircleAvatar(
                                  backgroundImage: pickedFile == null
                                      ? AssetImage('assets/images/anniversary_logo.png')
                                      : FileImage(_imageofCoupleToAdd),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.18,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 4.0,
                              //   ),
                              // ),
                              // CircleAvatar(
                              //   backgroundColor: Colors.grey.withOpacity(0.25),
                              //   radius:
                              //       MediaQuery.of(context).size.width * 0.075,
                              //   child: IconButton(
                              //     icon: Icon(Icons.camera_alt_outlined),
                              //     onPressed: _takePictureofCouple,
                              //     iconSize:
                              //         MediaQuery.of(context).size.width * 0.10,
                              //     color: Colors.grey.withOpacity(0.3),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child:  dateTime!=null?Text(
                              DateFormat('MMM dd').format(dateTime),style: TextStyle(
                color: Colors.black,
              ),
                            ): Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,color: Colors.black,size: 15,),
                                SizedBox(width: 4,),
                                Text('Select Date',style: TextStyle(
                                  color: Colors.black,
                                ),),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(140,40),
                              primary:  MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              dateTime = await PlatformDatePicker.showDate(
                                context: context,
                                // initialEntryMode: DatePickerEntryMode.input,
                                firstDate: DateTime(DateTime.now().year - 100),
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
                                _editedAnniv = Anniversary(
                                  anniversaryId: Id,
                                  husband_name: _editedAnniv.husband_name,
                                  wife_name: _editedAnniv.wife_name,
                                  dateofanniversary: dateTime,
                                  // relation: _editedAnniv.relation,
                                  notes: _editedAnniv.notes,
                                  yearofmarriageProvided:
                                      _editedAnniv.yearofmarriageProvided,
                                  // setAlarmforAnniversary:
                                  //     _editedAnniv.setAlarmforAnniversary,
                                  interestsofCouple: _editedAnniv.interestsofCouple,
                                  categoryofCouple: _editedAnniv.categoryofCouple,
                                  phoneNumberofCouple:
                                      _editedAnniv.phoneNumberofCouple,
                                  emailofCouple: _editedAnniv.emailofCouple,
                                  imageofCouple: _editedAnniv.imageofCouple,
                                );
                                FocusScope.of(context).requestFocus(new FocusNode());
                                setState(() {});
                              }
                            },
                          ),
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
                                minimumSize: Size(140,40),
                                primary: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),),                              onPressed: () async {
                            _alarmTime = await tpw.showCustomTimePicker(
                                context: context,
                                initialEntryMode: tpw.TimePickerEntryMode.input,
                                // It is a must if you provide selectableTimePredicate
                                onFailValidation: (context) =>
                                    print('Unavailable selection'),
                                initialTime: TimeOfDay(hour: 10, minute: 0));

                            // _editedAnniv = Anniversary(
                            //   anniversaryId: Id,
                            //   husband_name: _editedAnniv.husband_name,
                            //   wife_name: _editedAnniv.wife_name,
                            //   dateofanniversary:
                            //   _editedAnniv.dateofanniversary,
                            //   // relation: _editedAnniv.relation,
                            //   notes: _editedAnniv.notes,
                            //   yearofmarriageProvided:
                            //   _editedAnniv.yearofmarriageProvided,
                            //   // setAlarmforAnniversary: _alarmTime,
                            //   interestsofCouple:
                            //   _editedAnniv.interestsofCouple,
                            //   categoryofCouple:
                            //   _editedAnniv.categoryofCouple,
                            //   phoneNumberofCouple:
                            //   _editedAnniv.phoneNumberofCouple,
                            //   emailofCouple: _editedAnniv.emailofCouple,
                            //   imageofCouple: _editedAnniv.imageofCouple,
                            // );
                            FocusScope.of(context).requestFocus(new FocusNode());
                            setState(() {});
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(value: _yearofAnnivProvidedStat, onChanged: (status){
                            _yearofAnnivProvidedStat = status;
                            setState(() {

                            });
                            _editedAnniv = Anniversary(
                              anniversaryId: Id,
                              husband_name: _editedAnniv.husband_name,
                              wife_name: _editedAnniv.wife_name,
                              dateofanniversary:
                              _editedAnniv.dateofanniversary,
                              // relation: _editedAnniv.relation,
                              notes: _editedAnniv.notes,
                              yearofmarriageProvided:
                              !_yearofAnnivProvidedStat,
                              // setAlarmforAnniversary:
                              // _editedAnniv.setAlarmforAnniversary,
                              interestsofCouple:
                              _editedAnniv.interestsofCouple,
                              categoryofCouple: _editedAnniv.categoryofCouple,
                              phoneNumberofCouple:
                              _editedAnniv.phoneNumberofCouple,
                              emailofCouple: _editedAnniv.emailofCouple,
                              imageofCouple: _editedAnniv.imageofCouple,
                            );
                          }),
                          Text('Year of Marriage not known'),
                        ],
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration:
                            InputDecoration(labelText: 'Husband\'s Name *'),
                        textInputAction: TextInputAction.next,
                        // focusNode: _husbandnameFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context)
                        //       .requestFocus(_wifenameFocusNode);
                        // },
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
                            // relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:
                            //     _editedAnniv.setAlarmforAnniversary,
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
                        decoration: InputDecoration(labelText: 'Wife\'s Name *',
                            ),
                        textInputAction: TextInputAction.next,

                        // focusNode: _wifenameFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context)
                        //       .requestFocus(_relationFocusNode);
                        // },
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
                            // relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                                _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:/
                            //     _editedAnniv.setAlarmforAnniversary,
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
                          labelText: 'Phone Number',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.contact_page_outlined),
                            onPressed: () async {
                              PermissionStatus permission = await Permission.contacts.status;
                              if (permission != PermissionStatus.granted &&
                                  permission != PermissionStatus.permanentlyDenied) {
                                PermissionStatus permissionStatus = await Permission.contacts.request();
                                permission = await Permission.contacts.status;
                              }
                              if(permission.isGranted) {
                                Contact contact =
                                await _contactPicker.selectContact();
                                setState(() {
                                  _contact = contact;
                                });
                                phoneController.text = _contact.phoneNumber;
                              }
                            },
                          )
                        ),
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        // focusNode: _phoneFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_emailFocusNode);
                        // },
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            // relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                            _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:
                            // _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple: value,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty ) {
                            return null;
                          }
                          if(value.contains('+91')&&value.length==13)
                            return null;
                          else if(value.length==10)
                            return null;
                          return 'Please enter a valid phone number';
                        },
                      ),
                      TextFormField(
                        decoration:
                        InputDecoration(labelText: 'Email'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        // focusNode: _emailFocusNode,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).dispose();
                        // },
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
                            // relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                            _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:
                            // _editedAnniv.setAlarmforAnniversary,
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
                          vertical: 8.0,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Text('Select Category :',style: TextStyle(fontSize: 16),)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              selectCategory(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(label: Text('Family',style: TextStyle(color: Colors.black),),elevation: 3.0,backgroundColor: categoryNumber == 0?Colors.amber:Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              selectCategory(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(label: Text('Friend',style: TextStyle(color: Colors.black),),elevation: 3.0,backgroundColor: categoryNumber == 1?Colors.amber:Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              selectCategory(2);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(label: Text('Work',style: TextStyle(color: Colors.black),),elevation: 3.0,backgroundColor: categoryNumber == 2?Colors.amber:Colors.grey.shade100,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              selectCategory(3);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(label: Text('Others',style: TextStyle(color: Colors.black),),elevation: 3.0,backgroundColor: categoryNumber == 3?Colors.amber:Colors.grey.shade100,
                              ),
                            ),
                          ),

                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: MenuButton(
                      //     child:
                      //         CategoryButton, // Widget displayed as the button
                      //     items: _categories, // List of your items
                      //     topDivider: true,
                      //     popupHeight:
                      //         165, // This popupHeight is optional. The default height is the size of items
                      //     scrollPhysics:
                      //         AlwaysScrollableScrollPhysics(), // Change the physics of opened menu (example: you can remove or add scroll to menu)
                      //     itemBuilder: (value) => Container(
                      //         width: 100,
                      //         height: 40,
                      //         alignment: Alignment.centerLeft,
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 16),
                      //         child: Text(
                      //             value)), // Widget displayed for each item
                      //     toggledChild: Container(
                      //       child:
                      //           CategoryButton, // Widget displayed as the button,
                      //     ),
                      //     divider: Container(
                      //       height: 1,
                      //       color: Colors.grey,
                      //     ),
                      //     onItemSelected: (value) {
                      //       FocusScope.of(context).unfocus();
                      //       _categoryofCouple = getCategory(value);
                      //       _selectedCategory = value.toString();
                      //       setState(() {
                      //         _categorySelected = true;
                      //         _categoryColor = Colors.amber;
                      //         _categoryBorder = false;
                      //       });
                      //       _editedAnniv = Anniversary(
                      //         anniversaryId: Id,
                      //         husband_name: _editedAnniv.husband_name,
                      //         wife_name: _editedAnniv.wife_name,
                      //         dateofanniversary:
                      //             _editedAnniv.dateofanniversary,
                      //         relation: _editedAnniv.relation,
                      //         notes: _editedAnniv.notes,
                      //         yearofmarriageProvided:
                      //             _editedAnniv.yearofmarriageProvided,
                      //         setAlarmforAnniversary:
                      //             _editedAnniv.setAlarmforAnniversary,
                      //         interestsofCouple:
                      //             _editedAnniv.interestsofCouple,
                      //         categoryofCouple: _categoryofCouple,
                      //         phoneNumberofCouple:
                      //             _editedAnniv.phoneNumberofCouple,
                      //         emailofCouple: _editedAnniv.emailofCouple,
                      //         imageofCouple: _editedAnniv.imageofCouple,
                      //       );
                      //       FocusScope.of(context).unfocus();
                      //     },
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.grey[300]),
                      //         borderRadius: const BorderRadius.all(
                      //             Radius.circular(3.0))),
                      //     itemBackgroundColor: Colors.amber.shade300,
                      //     menuButtonBackgroundColor: Colors.amber,
                      //     onMenuButtonToggle: (isToggle) {
                      //       print(isToggle);
                      //     },
                      //   ),
                      // ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      MultiSelectBottomSheetField(
                        listType: MultiSelectListType.CHIP,
                        itemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        validator: (values) {
                          if (values == null || values.length <= 3)
                            return null;
                          return 'Choose max 3 tags only';
                        },
                        autovalidateMode: AutovalidateMode.always,
                        selectedItemsTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        // searchable: true,
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
                          _editedAnniv = Anniversary(
                            anniversaryId: Id,
                            husband_name: _editedAnniv.husband_name,
                            wife_name: _editedAnniv.wife_name,
                            dateofanniversary: _editedAnniv.dateofanniversary,
                            // relation: _editedAnniv.relation,
                            notes: _editedAnniv.notes,
                            yearofmarriageProvided:
                            _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:
                            // _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _selectedInterests,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                            _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Notes',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        // focusNode: _notesFocusNode,
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
                            // relation: _editedAnniv.relation,
                            notes: value,
                            yearofmarriageProvided:
                            _editedAnniv.yearofmarriageProvided,
                            // setAlarmforAnniversary:
                            // _editedAnniv.setAlarmforAnniversary,
                            interestsofCouple: _editedAnniv.interestsofCouple,
                            categoryofCouple: _editedAnniv.categoryofCouple,
                            phoneNumberofCouple:
                            _editedAnniv.phoneNumberofCouple,
                            emailofCouple: _editedAnniv.emailofCouple,
                            imageofCouple: _editedAnniv.imageofCouple,
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Add Anniversary',
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
    );
  }
    void selectCategory(int catNumber){
      switch (catNumber) {
        case 0:
          _selectedCategory = 'Family';
          break;
        case 1:
          _selectedCategory ='Friend';
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
        categoryNumber =catNumber;
      });}
  // Future<String> addCalender()async{
  //   GoogleSignInAccount account = Provider.of<GoogleAccountRepository>(context,listen: false).googleSignInAccount;
  //   String title = _editedAnniv.husband_name+'&'+_editedAnniv.wife_name+'\'s Anniversary';
  //   var currentTime = _editedAnniv.dateofanniversary;
  //   DateTime startTime,endTime,dt=currentTime;
  //   DateTime dtnow = DateTime.now();
  //   if(currentTime.year==dtnow.year&&currentTime.month==dtnow.month&&currentTime.day==dtnow.day){
  //     dt = DateTime(dtnow.year,currentTime.month,currentTime.day);
  //
  //   }else{
  //     if(currentTime.isBefore(dtnow)){
  //       dt = DateTime(dtnow.year,currentTime.month,currentTime.day);
  //       // if(currentTime.month<dtnow.month||currentTime.day<dtnow.day){
  //       //   calyear++;
  //       // }
  //     }
  //     if(dt.isBefore(dtnow)){
  //       dt = DateTime(dtnow.year+1,currentTime.month,currentTime.day);
  //     }
  //   }
  //   if(_editedAnniv.setAlarmforAnniversary !=null) {
  //     var alarmTime = _editedAnniv.setAlarmforAnniversary;
  //     startTime = DateTime(dt.year, dt.month, dt.day,alarmTime.hour,alarmTime.minute);
  //   }else{
  //     startTime = DateTime(dt.year, dt.month, dt.day,10,00);
  //   }
  //     endTime = DateTime(startTime.year,startTime.month,startTime.day,(startTime.hour+1),startTime.minute,00);
  //   GoogleCalenderModel calenderModel = GoogleCalenderModel(title: title,description: _editedAnniv.notes,startTime: startTime,endTime: endTime);
  //   CalendarClient cal = CalendarClient();
  //   String calId = await cal.insertCalender(account,calenderModel);
  //   return calId;
  // }
}
