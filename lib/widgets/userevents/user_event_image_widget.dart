import 'dart:io'as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart' as img;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:share/share.dart'as sh;
import 'package:flutter_vesti_share/flutter_vesti_share.dart' as vesti;
import 'package:yday/screens/userevents/full_image_screen.dart';

class UserEventImageWidget extends StatefulWidget {
  final String eventName;
  final DateTime eventDate;
  final String imageId;
  //final fl.File eventImage;

  UserEventImageWidget({
    this.eventName,
    this.eventDate,
    this.imageId,
  });

  @override
  _UserEventImageWidgetState createState() => _UserEventImageWidgetState();
}

class _UserEventImageWidgetState extends State<UserEventImageWidget> {
  String imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    imageUrl = 'https://drive.google.com/uc?export=view&id=${widget.imageId}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        GridTileBar(
          title: Text(
            widget.eventName,
            style: TextStyle(
              color: themeColor,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            DateFormat('dd / MM / yyyy').format(widget.eventDate),
            style: TextStyle(
              // fontSize: 20.0,
              color: themeColor,
            ),
            // textAlign: TextAlign.center,
          ),
          trailing: PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: themeColor,
            ),
            color: Colors.white70,
            // offset: Offset.zero,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                  child: IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      size: 20,
                      color: themeColor,
                    ),
                onPressed: _onImageSaveButtonPressed,
              )),
              PopupMenuItem(
                  child: IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 20,
                      color: themeColor,
                    ),
                onPressed: _saveAndShare,
              )),
              PopupMenuItem(
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: themeColor,
                ),
                onPressed: _shareWhatsApp,
              )),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: ()=>Navigator.of(context).pushNamed(FullImageScreen.routename,arguments: imageUrl),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/1498.gif',
                // placeholderCacheHeight: 1,
                placeholderScale: 3,
                imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                  return Icon(Icons.do_not_disturb);
                },
                // image: widget.imageId,
                // placeholderCacheWidth: 1,
                image: 'https://drive.google.com/uc?export=view&id=${widget.imageId}',
                // fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        // Divider(),
        // SizedBox(height:8,),
      ],
    );
  }
  var path;
  void _onImageSaveButtonPressed() async {
    try {
      var imageId = await img.ImageDownloader.downloadImage(
          'https://drive.google.com/uc?export=view&id=${widget.imageId}');
      if (imageId == null) {
        return;
      }
      final snackBar = SnackBar(content: Text('Image Downloaded Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } on PlatformException catch (error) {
      print(error);
    }
  }

  void _shareWhatsApp() async {
    var _imgUrl =
        'https://drive.google.com/uc?export=view&id=${widget.imageId}';
    List<dynamic> paths = [];
    List<dynamic> urls = [
      _imgUrl
    ];
    io.File file = await DefaultCacheManager().getSingleFile(urls[0]);
    paths.add(file.path);
    await vesti.Share().whatsAppImageList(paths: paths, business: false);
  }

  Future<Null> _saveAndShare() async {
    final RenderBox box = context.findRenderObject();
    if (io.Platform.isAndroid) {
      var imageUrl = Uri.parse(
          'https://drive.google.com/uc?export=view&id=${widget.imageId}');

      var response = await http.get(imageUrl);
      final documentDirectory =
          (await pathProvider.getTemporaryDirectory()).path;
      // var create = File().absolute;
      io.File imgFile = io.File('$documentDirectory/flutter.png') ;// = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      // = new File('$documentDirectory/flutter.png');
      // imgFile.writeAsBytes(bytes)
      imgFile.writeAsBytesSync(response.bodyBytes);
      sh.Share.shareFiles(['$documentDirectory/flutter.png'],
          // text: 'Hey! This is sent by Sarthak Saxena',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      sh.Share.share('',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
