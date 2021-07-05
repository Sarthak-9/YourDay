import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:yday/models/task.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/screens/frames/all_festivals_screen.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/screens/tasks/task_detail_screen.dart';

class TodaysFestivalWidget extends StatefulWidget {
  final DateTime selectedDate;

  TodaysFestivalWidget(this.selectedDate);
  @override
  _TodaysFestivalWidgetState createState() => _TodaysFestivalWidgetState();
}

class _TodaysFestivalWidgetState extends State<TodaysFestivalWidget> {
  // var _isLoading = false;

  // Future<void> _refreshTask(BuildContext context) async {
  //   await Provider.of<Tasks>(context, listen: false).fetchTask();
  // }

  // Future<void> _fetch() async {
  //   Future.delayed(Duration.zero).then((_) async {
  //     // setState(() {
  //     //   _isLoading = true;
  //     // });
  //     // await Provider.of<Festivals>(context, listen: false).fetchFestival();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }
  //
  // void didUpdate() async {
  //   await _fetch();
  // }
  //
  // @override
  // void initState() {
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   // didUpdate();
  //   super.initState();
  // }
  // @override
  // void didUpdateWidget(covariant UpcomingEventWidget oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   // this.widget.
  //   // if(_loggedIn){
  //
  //   didUpdate();
  //   setState(() {
  //     _isLoading = false;
  //   });
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
    var upcomingFestivals =
        Provider.of<Festivals>(context).findByDate(widget.selectedDate);
    return LimitedBox(
      child:
      // _isLoading
      //     ? Center(
              // child: CircularProgressIndicator(),
              // )
          // : !_loggedIn
          //     ? Center(
          //   child: Text(
          //     'You are not Logged-in',
          //     style: TextStyle(
          //       fontSize: 20,
          //     ),
          //   ),
          // )
          // :
        upcomingFestivals.isEmpty
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '    Festivals',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.left,
                          ),
                          TextButton(onPressed: (){
                            Navigator.of(context)
                                .pushNamed(AllFestivalScreen.routeName);
                          }, child: Text('Show All',style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),))
                        ],
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>FestivalImageScreen(festivalId: upcomingFestivals[i].festivalId,year: widget.selectedDate.year.toString())));

                            // Navigator.of(context).pushNamed(
                            //     FestivalImageScreen.routeName,
                            //     arguments: upcomingFestivals[i].festivalId);
                          },
                          title: Text(upcomingFestivals[i].festivalName),
                          subtitle: Text(
                            upcomingFestivals[i].festivalDate != null&&upcomingFestivals[i].festivalDate[widget.selectedDate.year.toString()]!=null
                                ? DateFormat('EEEE, MMM dd')
                                    .format(upcomingFestivals[i].festivalDate[widget.selectedDate.year.toString()])
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
    );
  }
}
