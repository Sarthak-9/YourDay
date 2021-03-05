import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/content/v2_1.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/birthday_detail_screen.dart';

import 'birthday_widget.dart';


class TodaysBirthdayWidget extends StatefulWidget {
  final  selectedDate;

  TodaysBirthdayWidget(this.selectedDate);

  @override
  _TodaysBirthdayWidgetState createState() => _TodaysBirthdayWidgetState();
}

class _TodaysBirthdayWidgetState extends State<TodaysBirthdayWidget> {
  @override
  Widget build(BuildContext context) {

    final birthdaylist = Provider.of<Birthdays>(context);
    //final birthdays = birthdaylist.birthdayList;
     var todaysBirthdayList = birthdaylist.findByDate(widget.selectedDate);
    // List<BirthDay> todaysBirthday = birthdaylist.findByDate(widget._todaysDate);
    return todaysBirthdayList.isEmpty ? Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        alignment: Alignment.center,
        child: Text('No Birthdays',style: TextStyle(
          fontSize: 16,
        ),
        ),
      ),
    ) : Expanded(
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemExtent: null,
        shrinkWrap: true,
        //shrinkWrap: false,
        itemBuilder: (ctx, i) => BirthdayItem(todaysBirthdayList[i].birthdayId,todaysBirthdayList[i].nameofperson,todaysBirthdayList[i].dateofbirth,todaysBirthdayList[i].categoryofPerson,todaysBirthdayList[i].relation,todaysBirthdayList[i].categoryColor),
        itemCount: todaysBirthdayList.length,
      ),
    );
  }
}

