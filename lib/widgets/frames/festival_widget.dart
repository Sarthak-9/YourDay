import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/screens/homepage.dart';

class FestivalWidget extends StatefulWidget {
  final String _festivalId;
  final int _festivalIndex;
  // final DateTime
  final String _festivalName;
  List<String> _festivalImageUrl;

  FestivalWidget(this._festivalId, this._festivalIndex, this._festivalName,
      this._festivalImageUrl);

  @override
  _FestivalWidgetState createState() => _FestivalWidgetState();
}

class _FestivalWidgetState extends State<FestivalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => FestivalImageScreen(
                    festivalId: widget._festivalId,
                    year: DateTime.now().year.toString(),
                  )));

          // Navigator.of(context).pushNamed(FestivalImageScreen.routeName,arguments: widget._festivalId);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // height: 60,
          child: GridTile(
            child: Image(
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.3,
              image: NetworkImage(widget._festivalImageUrl[0]),
            ),
            footer: GridTileBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
              title: Text(
                widget._festivalName,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
