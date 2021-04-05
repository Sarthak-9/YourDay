import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:image_share/image_share.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class FestivalImageWidget extends StatefulWidget {
  final String _festivalImageUrl;

  FestivalImageWidget(this._festivalImageUrl);

  @override
  _FestivalImageWidgetState createState() => _FestivalImageWidgetState();
}

class _FestivalImageWidgetState extends State<FestivalImageWidget> {
  @override
  Widget build(BuildContext context) {
    final Color themeColor = Theme.of(context).primaryColor;
    return Container(
      // width: MediaQuery.of(context).size.width*0.9,
      height: MediaQuery.of(context).size.width*0.8,
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 3.0,
          shadowColor: themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
          // padding: EdgeInsets.all(8.0),      // padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12.0),
        child: ClipRRect(
          child: GridTile(
            child: Container(
              padding: EdgeInsets.all(7.0),
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     width: 2.0,
              //     color: Colors.black45,
              //   ),
              // ),
              child: Image(
                width: MediaQuery.of(context).size.width*0.6,
                height: MediaQuery.of(context).size.width*0.6,

                image: NetworkImage(widget._festivalImageUrl),
              ),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.download_rounded,color: themeColor,),
                  onPressed: _onImageSaveButtonPressed,
                ),
                IconButton(icon: Icon(Icons.edit,color: themeColor,), onPressed: () async {}),
                IconButton(icon: Icon(Icons.share_rounded,color: themeColor,), onPressed: ()async {
                  await ImageShare.shareImage(filePath: "assets/images/userimage.png");
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  var _imageFile;
  void _onImageSaveButtonPressed() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage("https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/flutter.png");
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
    // var _imgUrl = Uri.parse(widget._festivalImageUrl);
    // print("_onImageSaveButtonPressed");
    // var response = await http
    //     .get(_imgUrl);
    //
    // debugPrint(response.statusCode.toString());
    //
    // var filePath = await ImagePickerSaver.saveFile(
    //     fileData: response.bodyBytes);
    //
    // var savedFile= File.fromUri(Uri.file(filePath));
    // setState(() {
    //   _imageFile = Future<File>.sync(() => savedFile);
    // });
    // print("_onImageSaveButtonPressedCompletes");
  }
  String imageData;
  bool dataLoaded = false;
  Future<void> downloadImage()async{
    var _imgUrl = Uri.parse(widget._festivalImageUrl);
    // _asyncMethod() async {
      //comment out the next two lines to prevent the device from getting
      // the image from the web in order to prove that the picture is
      // coming from the device instead of the web.
      var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
      var response = await http.get(_imgUrl); // <--2
      var documentDirectory = await pathProvider.getExternalStorageDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/706036.jpg';
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName);             // <-- 2
      file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
      setState(() {
        imageData = filePathAndName;
        dataLoaded = true;
      });
      print(imageData);
    // }
    // try {
    //   final response = await http.get(_imgUrl);
    //
    //   // Get the image name
    //   final imageName =path.basename('');
    //   // Get the document directory path
    //   final appDir = await pathProvider.getApplicationDocumentsDirectory();
    //
    //   // This is the saved image path
    //   // You can use it to display the saved image later.
    //   final localPath =path.join(appDir.path, imageName);
    //
    //   // Downloading
    //   final imageFile =File(localPath);
    //   await imageFile.writeAsBytes(response.bodyBytes);
    //   print('Downloaded!');
      // Saved with this method.
      // Future.delayed(Duration(seconds: 3));
      // var imageId = await ImageDownloader.downloadImage("https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/flutter.png");
      // if (imageId == null) {
      //   return;
      // }
      // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
    /*} on PlatformException catch (error) {
      print(error);
    }*/
  }
}
