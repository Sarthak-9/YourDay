import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/widgets/anniversaries/todays_anniversary_widget.dart';
import 'package:yday/widgets/birthdays/todays_birthday_widget.dart';
import 'package:yday/widgets/frames/todays_festival_widget.dart';
import 'package:yday/widgets/frames/upcoming_festivals_widgets.dart';
import 'package:yday/widgets/tasks/todays_task_widget.dart';

class Calendar extends StatefulWidget {
  static const routeName = '/calender-screen-dart';

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();

  CalendarController _calendarController=CalendarController();
  Map<DateTime, List<dynamic>> _events = {};
  bool _isLoading = true;
  void initState() {
    _fetch();
    super.initState();
  }

  Future<void> _fetch() async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Birthdays>(context, listen: false).fetchBirthday();
      await Provider.of<Anniversaries>(context, listen: false)
          .fetchAnniversary();
      await Provider.of<Tasks>(context, listen: false).fetchTask();
      await Provider.of<Festivals>(context, listen: false).fetchFestival();

      setState(() {
        _isLoading = false;
      });
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget events(var d) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(d, style: Theme.of(context).primaryTextTheme.bodyText1),
            //IconButton(icon: FaIcon(FontAwesomeIcons.trashAlt, color: Colors.redAccent, size: 15,), onPressed: ()=> _deleteEvent(d))
          ])),
    );
  }

  void _onDaySelected(DateTime day, List events, List abc) {
    //_selectedDay = day;
    setState(() {
      _selectedDay = day;
    });
  }

  Widget calendar() {
    return Container(
        //margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6),
            //gradient: LinearGradient(colors: [Colors.red[600], Colors.red[400]]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: new Offset(0.0, 5))
            ]),
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            canEventMarkersOverflow: true,
            markersColor: Colors.white,
            weekdayStyle: TextStyle(color: Colors.white),
            todayColor: Colors.green,
            todayStyle: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            selectedColor: Colors.red[900],
            outsideWeekendStyle: TextStyle(color: Colors.white60),
            outsideStyle: TextStyle(color: Colors.white60),
            weekendStyle: TextStyle(color: Colors.white),
            renderDaysOfWeek: true,

          ),
          onDaySelected: _onDaySelected,
          calendarController: _calendarController,
          events: _events,
          headerStyle: HeaderStyle(
            leftChevronIcon:
                Icon(Icons.arrow_back_ios, size: 15, color: Colors.white),
            rightChevronIcon:
                Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
            ),

            formatButtonDecoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(20),
            ),

          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            // height: MediaQuery.of(context).size.height*1.2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                calendar(),
                _isLoading
                    ? Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : todaysevents(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget todaysevents() {
    return Container(
      // height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height:15),
          // Text(' Birthdays',style: TextStyle(
          //   fontSize: 20,
          //   color: Theme.of(context).primaryColor,
          //   fontWeight: FontWeight.bold,
          // ),
          //   textAlign: TextAlign.left,),
          // Divider(),
          TodaysBirthdayWidget(_selectedDay),
          // Padding(
          //   padding: EdgeInsets.all(5),
          // ),
          // Text(' Anniversaries',style: TextStyle(
          //   fontSize: 20,
          //   color: Theme.of(context).primaryColor,
          //   fontWeight: FontWeight.bold,
          // ),
          //   textAlign: TextAlign.left,),
          // Divider(),
          TodaysAnniversaryWidget(_selectedDay),
          // Padding(
          //   padding: EdgeInsets.all(5),
          // ),
          // Text(' Tasks',style: TextStyle(
          //   fontSize: 20,
          //   color: Theme.of(context).primaryColor,
          //   fontWeight: FontWeight.bold,
          // ),
          //   textAlign: TextAlign.left,),
          // Divider(),
          TodaysTaskWidget(_selectedDay),
          // Padding(
          //   padding: EdgeInsets.all(5),
          // ),

          // Divider(),
          TodaysFestivalWidget(_selectedDay),
          // Padding(
          //   padding: EdgeInsets.all(5),
          // ),

          UpcomingEventWidget(),
          Padding(
            padding: EdgeInsets.all(25),
          ),
        ],
      ),
    );
  }
}
