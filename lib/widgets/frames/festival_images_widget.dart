import 'dart:io'as io;
import 'package:enhanced_drop_down/enhanced_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
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
      // height: MediaQuery.of(context).size.width*0.8,
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 3.0,
          shadowColor: themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(7.0),
              child:FadeInImage.assetNetwork(
                placeholder: 'assets/images/1498.gif',
                placeholderScale: 3,
                imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                  return Icon(Icons.do_not_disturb);
                },
                image: widget._festivalImageUrl, // After image load
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.download_rounded,color: themeColor,),
                  onPressed: _onImageSaveButtonPressed,
                ),
                IconButton(icon: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,), onPressed: shareWhatsApp),
                IconButton(icon: Icon(Icons.share_rounded,color: themeColor,), onPressed: saveAndShare,
                ),
              ],
            ),
          ],
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
      final snackBar = SnackBar(content: Text('Image Downloaded Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //
      // var fileName = await ImageDownloader.findName(imageId);
      // path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void shareWhatsApp()async{
    var _imgUrl = widget._festivalImageUrl;
    List<dynamic> paths = [];
    List<dynamic> urls = [
      _imgUrl
      // "https://blurha.sh/assets/images/img1.jpg",
      // "https://blurha.sh/assets/images/img1.jpg"
    ];
    // for(final url in urls){
      io.File file = await DefaultCacheManager().getSingleFile(urls[0]);
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
    if (io.Platform.isAndroid) {
      var imageUrl = Uri.parse(widget._festivalImageUrl);

      var response = await http.get(imageUrl);
      final documentDirectory = (await pathProvider.getTemporaryDirectory()).path;
      io.File imgFile = io.File('$documentDirectory/flutter.png') ;// = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      // imgFile.create().
      Share.shareFiles(['$documentDirectory/flutter.png'],
          // subject: 'URL conversion + Share',
          // text: 'Hey! This is sent by Sarthak Saxena',
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
