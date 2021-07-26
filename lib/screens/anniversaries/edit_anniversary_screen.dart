import 'dart:io';
import 'dart:math';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart'as tpw;
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/interests.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yday/services/message_handler.dart';
import '../homepage.dart';

class EditAnniversaryScreen extends StatefulWidget {
  static const routeName = '/edit-anniversary-screen';
  Anniversary fetchedAnniversary;

  EditAnniversaryScreen(this.fetchedAnniversary);

  @override
  _EditAnniversaryScreenState createState() => _EditAnniversaryScreenState();
}

class _EditAnniversaryScreenState extends State<EditAnniversaryScreen> {
  final _notesFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final phoneController = TextEditingController();

  final _form = GlobalKey<FormState>();
  String Id = DateTime.now().toString();
  TimeOfDay _alarmTime;
  File _imageofCoupleToAdd = File(
    'assets/images/userimage.png',
  );
  var pickedFile;
  var isLoading = false;
  var _loggedIn = false;
  List<Interest> _selectedInterests = [];
  final _items = interestsList
      .map((inter) => MultiSelectItem<Interest>(inter, inter.name))
      .toList();
  String anniversaryId = '';
  String anniversaryNotes = '';
  String anniversaryPhone = '';
  String anniversaryEmail = '';
  Anniversary _editedAnniv;
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  Contact _contact;

  @override
  void initState() {
    // TODO: implement initState
    _editedAnniv = widget.fetchedAnniversary;
    _alarmTime = TimeOfDay.fromDateTime(_editedAnniv.dateofanniversary);
    anniversaryId = _editedAnniv.anniversaryId;
    anniversaryEmail = _editedAnniv.emailofCouple;
    anniversaryPhone = _editedAnniv.phoneNumberofCouple;
    _selectedInterests = _editedAnniv.interestsofCouple;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notesFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();

    final isValid = _form.currentState.validate();
    if (!isValid ) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      DateTime eventDate = _editedAnniv.dateofanniversary;
      if(_alarmTime!=null&&(_editedAnniv.dateofanniversary.hour!=_alarmTime.hour||_editedAnniv.dateofanniversary.minute!=_alarmTime.minute)){
         eventDate = DateTimeField.combine(_editedAnniv.dateofanniversary, _alarmTime);
        await NotificationsHelper.cancelNotification(_editedAnniv.notifId);
        String annivWish = 'Happy Anniversary '+_editedAnniv.husband_name+' & '+_editedAnniv.wife_name;
        String payLoad = 'anniversary'+_editedAnniv.anniversaryId;
        await NotificationsHelper.setNotification(currentTime:eventDate ,id:_editedAnniv.notifId,title:annivWish,body:'Wish Happy Anniversary',payLoad: payLoad);
      }
      Anniversary updatedAnniversary = Anniversary(
        anniversaryId: anniversaryId,
        notes: anniversaryNotes,
        phoneNumberofCouple: anniversaryPhone,
        emailofCouple: anniversaryEmail,
        imageUrl: _editedAnniv.imageUrl,
        dateofanniversary: eventDate,
        interestsofCouple: _selectedInterests,
        imageofCouple: pickedFile!=null?_imageofCoupleToAdd:null,
      );
      _loggedIn = await Provider.of<Anniversaries>(context, listen: false)
          .editAnniversary(updatedAnniversary);
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
  }

  Future<void> _takePictureofCouple() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      _imageofCoupleToAdd = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
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
                        'Edit Anniversary',
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
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0)),
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
                            _alarmTime = await tpw.showCustomTimePicker(
                                context: context,
                                initialEntryMode: tpw.TimePickerEntryMode.input,
                                onFailValidation: (context) =>
                                    print('Unavailable selection'),
                                initialTime: TimeOfDay(hour: 0, minute: 0));
                            setState(() {});
                          }),
                      ListTile(
                        title: Text('Husband\'s Name'),
                        trailing: Text(_editedAnniv.husband_name),
                      ),
                      ListTile(
                        title: Text('Wife\'s Name'),
                        trailing: Text(_editedAnniv.wife_name),
                      ),
                      ListTile(
                        title: Text('Date'),
                        trailing: _editedAnniv.yearofmarriageProvided
                            ? Text(
                          DateFormat('EEEE, MMM dd, yyyy')
                              .format(_editedAnniv.dateofanniversary),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        )
                            : Text(DateFormat('EEEE, MMM dd')
                            .format(_editedAnniv.dateofanniversary)),
                      ),
                      ListTile(
                        title: Text('Category'),
                        trailing: Text(categoryText(_editedAnniv.categoryofCouple)),
                      ),

                      TextFormField(
                        initialValue: _editedAnniv.phoneNumberofCouple,
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
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          anniversaryPhone = value;
                        },
                        // validator: (value) {
                        //   if (value.isEmpty ) {
                        //     return null;
                        //   }
                        //   if(value.contains('+91')&&value.length==10)
                        //     return null;
                        //   // else if(value.length==10)
                        //   //   return null;
                        //   return 'Please enter a valid phone number';
                        // },
                      ),
                      TextFormField(
                        initialValue: _editedAnniv.emailofCouple,
                        decoration:
                            InputDecoration(labelText: 'Email '),
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
                          anniversaryEmail = value;
                        },
                      ),
                      TextFormField(
                        initialValue: _editedAnniv.notes,
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
                          anniversaryNotes = value;
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
                        listType: MultiSelectListType.CHIP,
                        itemsTextStyle: TextStyle(
                          color: Colors.black,
                        ),
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
                          'Edit Anniversary',
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
                      SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  //
  // Future<String> addCalender() async {
  //   GoogleSignInAccount account =
  //       Provider.of<GoogleAccountRepository>(context, listen: false)
  //           .googleSignInAccount;
  //   String title = _editedAnniv.husband_name +
  //       '&' +
  //       _editedAnniv.wife_name +
  //       '\'s Anniversary';
  //   var currentTime = _editedAnniv.dateofanniversary;
  //   DateTime startTime, endTime, dt = currentTime;
  //   DateTime dtnow = DateTime.now();
  //   if (currentTime.year == dtnow.year &&
  //       currentTime.month == dtnow.month &&
  //       currentTime.day == dtnow.day) {
  //     dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
  //   } else {
  //     if (currentTime.isBefore(dtnow)) {
  //       dt = DateTime(dtnow.year, currentTime.month, currentTime.day);
  //       // if(currentTime.month<dtnow.month||currentTime.day<dtnow.day){
  //       //   calyear++;
  //       // }
  //     }
  //     if (dt.isBefore(dtnow)) {
  //       dt = DateTime(dtnow.year + 1, currentTime.month, currentTime.day);
  //     }
  //   }
  //   if (_editedAnniv.setAlarmforAnniversary != null) {
  //     var alarmTime = _editedAnniv.setAlarmforAnniversary;
  //     startTime =
  //         DateTime(dt.year, dt.month, dt.day, alarmTime.hour, alarmTime.minute);
  //   } else {
  //     startTime = DateTime(dt.year, dt.month, dt.day, 10, 00);
  //   }
  //   endTime = DateTime(startTime.year, startTime.month, startTime.day,
  //       (startTime.hour + 1), startTime.minute, 00);
  //   GoogleCalenderModel calenderModel = GoogleCalenderModel(
  //       title: title,
  //       description: _editedAnniv.notes,
  //       startTime: startTime,
  //       endTime: endTime);
  //   CalendarClient cal = CalendarClient();
  //   String calId = await cal.insertCalender(account, calenderModel);
  //   return calId;
  // }
}
