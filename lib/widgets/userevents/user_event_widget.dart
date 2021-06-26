import 'package:flutter/material.dart';
import 'package:yday/screens/userevents/user_event_detail_screen.dart';

class UserEventWidget extends StatelessWidget {
  final String folderId;
  final String userEventName;

  UserEventWidget(this.folderId,this.userEventName); // final String userEventNotes;
  // final DateTime userDateOfEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 8.0),
      child: GestureDetector(
        onTap: (){
          // Navigator.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserEventDetailScreen(folderId),
            ),
          );        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // height: 60,
          child: GridTile(
            child: Image(
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width*0.2,
              image:AssetImage('assets/images/drive_folder.png')// NetworkImage(titlePhotoUrl),
            ),
            footer: GridTileBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
              title: Text(
                  userEventName,
                style: TextStyle(
                    color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
