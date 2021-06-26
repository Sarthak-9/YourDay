import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/constants.dart';
import 'package:file/file.dart' as fl;
import 'package:yday/models/frames/festival.dart';
import 'package:yday/models/userevents/auth_manager.dart';
import 'package:yday/models/userevents/google_auth_client.dart';
import 'package:yday/models/userevents/user_event.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/services/google_signin_repository.dart';

class AddFramesCategoryScreen extends StatefulWidget {
  static const routeName = '/add-frames-category-screen';
  @override
  _AddFramesCategoryScreenState createState() => _AddFramesCategoryScreenState();
}

class _AddFramesCategoryScreenState extends State<AddFramesCategoryScreen> {
  // var signedIn = false;
  // var _yourDayFolder;
  String festivalName = '';
  final festivalNameController = TextEditingController();
  final festivalDescriptionController = TextEditingController();
  String festivalDescription;
  double percent = 0;
  int imageCount = 0;
  int imagesLength = 0;
  bool isLoading = false;
  List<Asset> images = <Asset>[];
  DateTime dateTime;
  bool _dateSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          'YourDay',
          style: TextStyle(
            // fontFamily: 'Kaushan Script',
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height*1.2,
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Add Frame',
                  style: TextStyle(
                      fontSize: 26.0, fontFamily: 'Libre Baskerville'
                    //color: Colors.white
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Festival Name',
                  ),
                  controller: festivalNameController,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (value) {
                    festivalName = value;
                  },
                ),

                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Event Description',
                  ),
                  controller: festivalDescriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (value) {
                    festivalDescription = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    child: Text(
                      _dateSelected
                          ? DateFormat('dd / MM ').format(dateTime)
                          : 'Select Date',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                        primary: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).accentColor)),
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
                      setState(() {
                        if (dateTime != null) _dateSelected = true;
                      });
                    }
                  // },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text("Pick Images"),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // if (states.contains(MaterialState.pressed))
                            return themeColor;
                            return null; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: loadAssets,
                    ),
                    ElevatedButton(
                      child: Text("Upload Images"),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // if (states.contains(MaterialState.pressed))
                            return themeColor;
                            return null; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: saveForm,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (isLoading)
                  Text('Please wait while your photos are being uploaded.'),
                SizedBox(
                  height: 10,
                ),
                if (isLoading)
                  FAProgressBar(
                    currentValue: percent.toInt(),
                    // backgroundColor: Theme.of(context).primaryColor,
                    progressColor: Theme.of(context).primaryColor,
                    displayText: '%',
                    displayTextStyle: TextStyle(color: Colors.white),
                    direction: Axis.horizontal,
                  ), //CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                LimitedBox(child: buildGridView()),
                SizedBox(
                  height: 30,
                )
              ],
            )),
      ),);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "YourDay",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  Future<void> saveForm() async {
    if (images.isEmpty) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Photos'),
          content: Text('Please select at least one photo.'),
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
    if (festivalNameController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Name'),
          content: Text('Please enter a valid name.'),
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

    setState(() {
      isLoading = true;
    });
    await uploadImage();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(tabNumber: 1,)), (route) => false);

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //       builder: (context) => HomePage(
    //         tabNumber: 0,
    //       ),),
    // );
    setState(() {
      isLoading = false;
    });

  }

  Future<void> uploadImage() async {
    List<String> photoUrl= [];
    if(images!=null){
      List <io.File> fileImageArray = [];
     await Future.forEach(images,(imageAsset) async {
        final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
        io.File tempFile = io.File(filePath);
        if (tempFile.existsSync()) {
          fileImageArray.add(tempFile);
        }});
     imagesLength = fileImageArray.length;
      FirebaseStorage storage = FirebaseStorage.instance;
      await Future.forEach(fileImageArray, (image)async {
        Reference ref =
        storage.ref().child('festivals').child(DateTime.now().toString());
        UploadTask uploadTask = ref.putFile(image);
        await uploadTask.whenComplete(() async {
          String url = await ref.getDownloadURL();
          photoUrl.add(url);
          imageCount++;
          percent = ((imageCount*100)/imagesLength);
          setState(() {
          });
        }).catchError((onError) {
          throw onError;
        });});
      Map<String, dynamic> dtMap= {};
      if(dateTime!=null){
        dtMap[dateTime.year.toString()] = dateTime.toIso8601String();
      }
      Festival newFestival = Festival(
        festivalName: festivalNameController.text,
        // festivalDate: dtMap,
        festivalDescription: festivalDescriptionController.text,
        festivalImageUrl: photoUrl,
      );
     await Provider.of<Festivals>(context, listen: false).addFestival(newFestival,dtMap);
    }

  }
}
