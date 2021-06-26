import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:provider/provider.dart';
import 'package:yday/services/google_drive_repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/services/google_signin_repository.dart';

class AddImageToEventScreen extends StatefulWidget {
  static const routeName = '/add-image-to-event-screen';
  @override
  _AddImageToEventScreenState createState() => _AddImageToEventScreenState();
}

class _AddImageToEventScreenState extends State<AddImageToEventScreen> {
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn =
  // GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
  GoogleSignInAccount googleSignInAccount;
  ga.FileList list;
  double percent = 0;
  int imageCount = 0;
  int imagesLength = 0;
  bool isLoading = false;
  String folderId;
  List<Asset> images = <Asset>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    folderId = ModalRoute.of(context).settings.arguments as String;
    checkInit();
    super.didChangeDependencies();
  }
  void checkInit()async{
    googleSignInAccount = Provider.of<GoogleAccountRepository>(context).googleSignInAccount;
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('YourDay',style: TextStyle(
            // fontFamily: 'Kaushan Script',
            fontSize: 28  ,
          ),),
        ),
        body:SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height * 1.2,
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Add Images',
                    style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'Libre Baskerville'
                      //color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text("Pick Images"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                  if (isLoading) Text('Please wait while your photos are being uploaded.'),
                  SizedBox(height: 10,),
                  if(isLoading)
                    FAProgressBar(
                      currentValue: percent.toInt(),
                      // backgroundColor: Theme.of(context).primaryColor,
                      progressColor: Theme.of(context).primaryColor,
                      displayText: '%',
                      displayTextStyle: TextStyle(
                          color: Colors.white
                      ),
                      direction: Axis.horizontal,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  LimitedBox(
                    child: buildGridView(),
                  ),
                  SizedBox(height: 30,)
                ],
              )

          ),
        )
    );
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
    if (!mounted)
      return;
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
    setState(() {
      isLoading = true;
    });
    await uploadImage();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(tabNumber: 2,)), (route) => false);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadImage() async {
        imagesLength = images.length;
        GoogleDriveRepository googleDriveRepository = GoogleDriveRepository(googleSignInAccount);//Provider.of<GoogleAccountRepository>(context,listen: false).googleDriveRepository;
         await  Future.forEach(images,(uploadImage) async {
        final filePath =
        await FlutterAbsolutePath.getAbsolutePath(uploadImage.identifier);
        await googleDriveRepository.savePicture(
            uploadImage.name, folderId, filePath);
        imageCount++;
        percent = ((imageCount*100)/imagesLength);
        setState(() {

        });
      });
    // }
  }
}
