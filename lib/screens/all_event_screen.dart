import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/widgets/anniversary_widget.dart';
import 'package:yday/widgets/birthday_widget.dart';
import 'package:yday/widgets/task_widget.dart';

import 'add_anniversary.dart';
import 'add_birthday_screen.dart';
import 'add_task.dart';

class AllEvents extends StatefulWidget {
  static const routeName = '/allevent-screen-dart';

  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  @override
  Widget build(BuildContext context) {
    int eventnumber = ModalRoute.of(context).settings.arguments;
    Widget selectedEvent(){
      switch (eventnumber) {
        case 1:
          return BirthdayWidget();
          break;
        case 2:
          return AnniversaryWidget();
          break;
        case 3:
          return TaskWidget();
          break;
        default:
          return TaskWidget();
      }
    }

    String selectedEventTitle(){
      switch (eventnumber) {
        case 1:
          return 'All Birthdays';
          break;
        case 2:
          return 'All Anniversaries';
          break;
        case 3:
          return 'All Tasks';
          break;
        default:
          return 'All Tasks';
      }
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 15.0),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Text(selectedEventTitle(),style: TextStyle(
                  fontSize: 30.0,
                ),),
                Padding(padding: EdgeInsets.symmetric(vertical: 8.0,),),
                Divider(),
                selectedEvent(),
              ],
            ),),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            if(eventnumber==1)
              Navigator.of(context).pushNamed(AddBirthday.routeName);
            else if(eventnumber==2)
              Navigator.of(context).pushNamed(AddAnniversary.routeName);
            else
              Navigator.of(context).pushNamed(AddTask.routeName);

          },
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //
      //   ],
      //),
    );
  }
}
