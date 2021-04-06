// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:http/io_client.dart';
// import 'package:path_provider/path_provider.dart';
// class PhotoScreen extends StatefulWidget {
//   @override
//   _PhotoScreenState createState() => _PhotoScreenState();
// }
//
// class _PhotoScreenState extends State<PhotoScreen> {
//   List<Asset> images = <Asset>[];
//   String _error = 'No Error Dectected';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return AssetThumb(
//           asset: asset,
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//
//   _uploadFileToGoogleDrive() async {
//     var client = GoogleHttpClient(await googleSignIn.authHeaders);
//     var drive = ga.DriveApi(client);
//     ga.File fileToUpload = ga.File();
//     var file = await ImagePicker().getImage(
//       source: ImageSource
//           .gallery,
//       imageQuality: 60,
//     );//await FilePicker.platform.pickFiles();
//     fileToUpload.parents = ["appDataFolder"];
//     fileToUpload.name = path.basename(file.path);
//     var response = await drive.files.create(
//       fileToUpload,
//       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//     );
//     print(response);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//           children: <Widget>[
//             Center(child: Text('Error: $_error')),
//             ElevatedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             Expanded(
//               child: buildGridView(),
//             )
//           ],
//     );
//   }
// }
// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;
//   GoogleHttpClient(this._headers) : super();
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) async =>
//       super.send(request..headers.addAll(_headers));
//   @override
//   Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }