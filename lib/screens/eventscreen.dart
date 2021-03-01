import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/add_anniversary.dart';
import 'package:yday/widgets/anniversary_widget.dart';
import 'package:yday/widgets/birthday_widget.dart';
import 'package:yday/widgets/task_widget.dart';

import 'add_birthday_screen.dart';
import 'add_task.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/event-screen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    final birthdaylist = Provider.of<Birthdays>(context);
    final birthdays = birthdaylist.birthdayList;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      //height: MediaQuery.of(context).size.height*0.9,
      child: ListView(
          children: [
            Card(
              shadowColor: Colors.green,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //height: 500,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('  Birthdays',style: TextStyle(
                              fontSize: 20.0,
                            ),),
                            IconButton(icon: Icon(Icons.add), onPressed: () {
                              Navigator.of(context).pushNamed(AddBirthday.routeName);
                            },),
                          ],
                        ),
                      ),
                    ),
                    BirthdayWidget(),
                  ],
                ),
              ),
            ),
            Card(
              shadowColor: Colors.green,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('  Anniversary',style: TextStyle(
                              fontSize: 20.0,
                            ),),
                            IconButton(icon: Icon(Icons.add), onPressed: () {
                              Navigator.of(context).pushNamed(AddAnniversary.routeName);
                            },),
                          ],
                        ),
                      ),
                    ),
                    AnniversaryWidget(),
                  ],
                ),
              ),
            ),
            // //Divider(),
            Card(
              shadowColor: Colors.green,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('  Todo Tasks',style: TextStyle(
                              fontSize: 20.0,
                            ),),
                            IconButton(icon: Icon(Icons.add), onPressed: () {
                              Navigator.of(context).pushNamed(AddTask.routeName);
                            },),
                          ],
                        ),
                      ),
                    ),
                    TaskWidget(),
                  ],
             ),
              ),
            )
            //Spacer(),
          ],
        ),
    );
  }
}
