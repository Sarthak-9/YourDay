import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yday/models/frames/festival.dart';
import 'package:yday/providers/userevents/user_events.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/services/google_signin_repository.dart';

class AddImagesToCategoryScreen extends StatefulWidget {
  static const routeName = '/add-images-to-category-screen';
  @override
  _AddImagesToCategoryScreenState createState() => _AddImagesToCategoryScreenState();
}

class _AddImagesToCategoryScreenState extends State<AddImagesToCategoryScreen> {
  // var signedIn = false;
  // var _yourDayFolder;
  final festivalDescriptionController = TextEditingController();
  String festivalDescription = '';
  double percent = 0;
  int imageCount = 0;
  int imagesLength = 0;
  bool isLoading = false;
  List<Asset> images = <Asset>[];
  String festivalId = '';
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
    festivalId = ModalRoute.of(context).settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
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
                Divider(),
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
    setState(() {
      isLoading = true;
    });
    await uploadImage();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(tabNumber: 1,)), (route) => false);
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
     }
    Map<String, dynamic> dtMap= {};

    Festival fetchFestival = Provider.of<Festivals>(context, listen: false).findFestivalById(festivalId);
    if(fetchFestival!=null){
      fetchFestival.festivalDate.forEach((key, value) {
        dtMap[key] = value.toIso8601String();
      });
    }
    if(dateTime!=null){
      dtMap[dateTime.year.toString()] = dateTime.toIso8601String();
    }

    Festival updateFestival = Festival(
      festivalId: festivalId,
      festivalImageUrl: photoUrl,
      festivalDescription: festivalDescriptionController.text.isNotEmpty?festivalDescriptionController.text:fetchFestival.festivalDescription,
      // festivalDate: dtMap,
    );
    await Provider.of<Festivals>(context, listen: false).addFramesInFestival(updateFestival,dtMap);


  }
}
/*
imagesLength = images.length;
        List<String> photoUrl;
        if(images!=null){
          FirebaseStorage storage = FirebaseStorage.instance;
          await Future.forEach(images, (image)async {
            Reference ref =
            storage.ref().child('frames').child(DateTime.now().toString());
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
        }
 */
