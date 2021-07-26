import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/birthdays/all_birthday_screen.dart';
import 'package:yday/screens/birthdays/birthday_detail_screen.dart';

import 'birthday_widget.dart';

class TodaysBirthdayWidget extends StatefulWidget {
  final selectedDate;

  TodaysBirthdayWidget(this.selectedDate);

  @override
  _TodaysBirthdayWidgetState createState() => _TodaysBirthdayWidgetState();
}

class _TodaysBirthdayWidgetState extends State<TodaysBirthdayWidget> {
  var _isLoading = false;

  Future<void> _fetch()async{
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Birthdays>(context,listen: false).fetchBirthday();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }
  void didUpdate()async{
    await _fetch();
  }

  @override
  void initState() {
    // didUpdate();
    super.initState();
  }
  // @override
  // void didUpdateWidget(covariant TodaysBirthdayWidget oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   // this.widget.
  //   // if(_loggedIn){
  //     didUpdate();
  //   // }
  //   super.didUpdateWidget(oldWidget);
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final birthdaylist = Provider.of<Birthdays>(context);
    //final birthdays = birthdaylist.birthdayList;
    var todaysBirthdayList = birthdaylist.findByDate(widget.selectedDate);
    // List<BirthDay> todaysBirthday = birthdaylist.findByDate(widget._todaysDate);
    return LimitedBox(
      child: _isLoading
          ? Center(
              // child: CircularProgressIndicator(),
            )
          : todaysBirthdayList.isEmpty?SizedBox()
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    // SizedBox(height:15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(height: 30,width: 30,child: Image.asset('assets/images/cake.png'),),
                            Text('    Birthdays',style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                              textAlign: TextAlign.left,),
                          ],
                        ),
                        TextButton(onPressed: (){
                          Navigator.of(context)
                              .pushNamed(AllBirthdayScreen.routeName);

                        }, child: Text('Show All',style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),))
                      ],
                    ),
                    Divider(),
                    ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => BirthdayItem(
                          todaysBirthdayList[i].birthdayId,
                          todaysBirthdayList[i].nameofperson,
                          todaysBirthdayList[i].dateofbirth,
                          todaysBirthdayList[i].categoryofPerson,
                          todaysBirthdayList[i].imageUrl,
                          todaysBirthdayList[i].gender,
                          ),
                      itemCount: todaysBirthdayList.length,
                    ),
                  ],
                ),
              ),
    );
  }
}
