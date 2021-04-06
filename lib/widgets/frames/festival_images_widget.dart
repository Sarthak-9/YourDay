import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
// import 'package:image_share/image_share.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as URLLauncher;
import 'package:flutter_vesti_share/flutter_vesti_share.dart' as vesti;
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
                IconButton(icon: FaIcon(FontAwesomeIcons.whatsapp,color: themeColor,), onPressed: shareWhatsApp),
                IconButton(icon: Icon(Icons.share_rounded,color: themeColor,), onPressed: saveAndShare,
                //     ()async {
                //   File _imageShare = await urlToFile();
                //   await ImageShare.shareImage(filePath: _imageShare.path);
                // }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  var _imageFile;
  var path;
  void _onImageSaveButtonPressed() async {
    try {
      var imageId = await ImageDownloader.downloadImage(widget._festivalImageUrl);
      if (imageId == null) {
        return;
      }

      var fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }
  // void _imageWhatsAppShare()async{
  //   List<dynamic> paths = [];
  //   List<dynamic> urls = [
  //     "https://blurha.sh/assets/images/img1.jpg",
  //     "https://blurha.sh/assets/images/img1.jpg"
  //   ];
  //   paths.add(path);
  //   // await Share().
  // }
//   Future<File> urlToFile() async {
// // generate random number.
//     var rng = new Random();
//     var imageUrl = Uri.parse(widget._festivalImageUrl);
//     Directory tempDir = await pathProvider.getTemporaryDirectory();
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
//     await Share.shareFiles([file.path]);
//     // await ImageShare.shareImage(filePath: file.path);
//
//     return file;
//
//   }
  void shareWhatsApp()async{
    var _imgUrl = widget._festivalImageUrl;
    List<dynamic> paths = [];
    List<dynamic> urls = [
      _imgUrl
      // "https://blurha.sh/assets/images/img1.jpg",
      // "https://blurha.sh/assets/images/img1.jpg"
    ];
    // for(final url in urls){
      File file = await DefaultCacheManager().getSingleFile(urls[0]);
      paths.add(file.path);
    // }
    await vesti.Share().whatsAppImageList(
        paths: paths,
        business: false
    );

    // const url = 'whatsapp://send';//?phone';//=$widget.';
    // if (await URLLauncher.canLaunch(url)) {
    //   await URLLauncher.launch(url);
    // }
    // else {
    //   throw 'Could not launch $url';
    // }
  }
  Future<Null> saveAndShare() async {
    // setState(() {
    //   isBtn2 = true;
    // });
    final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      var imageUrl = Uri.parse(widget._festivalImageUrl);

      var response = await http.get(imageUrl);
      final documentDirectory = (await pathProvider.getTemporaryDirectory()).path;
      File imgFile = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFiles([File('$documentDirectory/flutter.png').path],
          // subject: 'URL conversion + Share',
          text: 'Hey! This is sent by Sarthak Saxena',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('',
          // subject: 'URL conversion + Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
    // setState(() {
    //   isBtn2 = false;
    // });
  }


}
