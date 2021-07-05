import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:yday/models/constants.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/anniversaries/all_anniversary_screen.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/frames/all_festivals_screen.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/screens/tasks/all_task_screen.dart';
import 'package:yday/screens/tasks/task_detail_screen.dart';
import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
import 'package:yday/widgets/birthdays/birthday_widget.dart';
import 'package:yday/widgets/tasks/task_widget.dart';

class UpcomingEventWidget extends StatefulWidget {
  @override
  _UpcomingEventWidgetState createState() => _UpcomingEventWidgetState();
}

class _UpcomingEventWidgetState extends State<UpcomingEventWidget> {
  int categoryNumber = 0;
  String _selectedCategory = 'Others';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final upcomingFestivals = Provider.of<Festivals>(context).upcomingFestivals;
    final upcomingBirthday =
        Provider.of<Birthdays>(context).upcomingBirthdayList;
    final upcomingAnniversary =
        Provider.of<Anniversaries>(context).upcomingAnniversaryList;
    final upcomingTask = Provider.of<Tasks>(context).upcomingTaskList;

    return LimitedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: LimitedBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '    Upcoming Events',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    // textAlign: TextAlign.left,
                  ),
                  TextButton(
                      onPressed: () {
                        if (categoryNumber == 0) {
                          Navigator.of(context)
                              .pushNamed(AllBirthdayScreen.routeName);
                        }else if (categoryNumber == 1) {
                          Navigator.of(context)
                              .pushNamed(AllAnniversaryScreen.routeName);
                        } else if (categoryNumber == 2) {
                          Navigator.of(context)
                              .pushNamed(AllTaskScreen.routeName);
                        } else {
                          Navigator.of(context)
                              .pushNamed(AllFestivalScreen.routeName);
                        }
                      },
                      child: Text(
                        'Show All',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Divider(),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectCategory(0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(
                            'Birthday',
                            style: TextStyle(color: Colors.black),
                          ),
                          elevation: 3.0,
                          backgroundColor: categoryNumber == 0
                              ? Colors.amber
                              : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectCategory(1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(
                            'Anniversary',
                            style: TextStyle(color: Colors.black),
                          ),
                          elevation: 3.0,
                          backgroundColor: categoryNumber == 1
                              ? Colors.amber
                              : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectCategory(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(
                            'Task',
                            style: TextStyle(color: Colors.black),
                          ),
                          elevation: 3.0,
                          backgroundColor: categoryNumber == 2
                              ? Colors.amber
                              : Colors.grey.shade100,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        selectCategory(3);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(
                            'Festival',
                            style: TextStyle(color: Colors.black),
                          ),
                          elevation: 3.0,
                          backgroundColor: categoryNumber == 3
                              ? Colors.amber
                              : Colors.grey.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ListView.builder(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemBuilder: (ctx, i) => ListTile(
              //       onTap: (){
              //         Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>FestivalImageScreen(festivalId: upcomingFestivals[i].festivalId,year: DateTime.now().year.toString(),)));
              //         // Navigator.of(context).pushNamed(FestivalImageScreen.routeName,arguments: upcomingFestivals[i].festivalId);
              //       },
              //       title: Text(upcomingFestivals[i].festivalName),
              //       subtitle: Text(
              //         upcomingFestivals[i].festivalDate != null&&upcomingFestivals[i].festivalDate[DateTime.now().year.toString()]!=null
              //             ? DateFormat('EEEE, MMM dd')
              //                 .format(upcomingFestivals[i].festivalDate[DateTime.now().year.toString()])
              //             : '',
              //         //textScaleFactor: 1.4,
              //         textAlign: TextAlign.start,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),
              //     itemCount: upcomingFestivals.length,
              //     //),
              //   ),
              if (categoryNumber == 0)
                upcomingBirthday.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          'No Birthday',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => BirthdayItem(
                            upcomingBirthday[i].birthdayId,
                            upcomingBirthday[i].nameofperson,
                            upcomingBirthday[i].dateofbirth,
                            upcomingBirthday[i].categoryofPerson,
                            upcomingBirthday[i].imageUrl,
                            upcomingBirthday[i].gender),
                        itemCount: upcomingBirthday.length,
                      ),
              if (categoryNumber == 1)
                upcomingAnniversary.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No Anniversary',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => AnniversaryItem(
                            upcomingAnniversary[i].anniversaryId,
                            upcomingAnniversary[i].husband_name,
                            upcomingAnniversary[i].wife_name,
                            upcomingAnniversary[i].dateofanniversary,
                            upcomingAnniversary[i].categoryofCouple,
                            // anniversaries[i].relation,
                            categoryColor(
                                upcomingAnniversary[i].categoryofCouple)),
                        itemCount: upcomingAnniversary.length,
                      ),
              if (categoryNumber == 2)
                upcomingTask.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No Tasks',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => TaskItem(
                            upcomingTask[i].taskId,
                            upcomingTask[i].title,
                            upcomingTask[i].startdate,
                            // tasks[i].enddate,
                            upcomingTask[i].levelofpriority,
                            upcomingTask[i].priorityLevelColor,
                            upcomingTask[i].priorityLevelText),
                        itemCount: upcomingTask.length,
                        //),
                      ),
              if (categoryNumber == 3)
                upcomingFestivals.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No Festivals',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => FestivalImageScreen(
                                      festivalId:
                                          upcomingFestivals[i].festivalId,
                                      year: DateTime.now().year.toString(),
                                    )));
                            // Navigator.of(context).pushNamed(FestivalImageScreen.routeName,arguments: upcomingFestivals[i].festivalId);
                          },
                          title: Text(upcomingFestivals[i].festivalName),
                          subtitle: Text(
                            upcomingFestivals[i].festivalDate != null &&
                                    upcomingFestivals[i].festivalDate[
                                            DateTime.now().year.toString()] !=
                                        null
                                ? DateFormat('EEEE, MMM dd').format(
                                    upcomingFestivals[i].festivalDate[
                                        DateTime.now().year.toString()])
                                : '',
                            //textScaleFactor: 1.4,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        itemCount: upcomingFestivals.length,
                        //),
                      ),
            ],
          ),
        ),
      ),
    );
  }

  void selectCategory(int catNumber) {
    switch (catNumber) {
      case 0:
        _selectedCategory = 'Birthday';
        break;
      case 1:
        _selectedCategory = 'Anniversary';
        break;
      case 2:
        _selectedCategory = 'Task';
        break;
      case 3:
        _selectedCategory = 'Festival';
        break;
      default:
        _selectedCategory = 'Birthday';
    }
    setState(() {
      categoryNumber = catNumber;
    });
  }
}
