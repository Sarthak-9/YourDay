import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/all_event_screen.dart';
import 'package:yday/screens/anniversaries/all_anniversary_screen.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/anniversaries/anniversary_detail.dart';
import 'package:yday/screens/birthdays/birthday_detail_screen.dart';

import 'anniversary_widget.dart';

class TodaysAnniversaryWidget extends StatefulWidget {
  final selectedDate;

  TodaysAnniversaryWidget(this.selectedDate);

  @override
  _TodaysAnniversaryWidgetState createState() =>
      _TodaysAnniversaryWidgetState();
}

class _TodaysAnniversaryWidgetState extends State<TodaysAnniversaryWidget> {
  var _isLoading = false;
  // var _loggedIn = false;
  Future<void> _fetch() async{
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   _loggedIn = await Provider.of<Anniversaries>(context,listen: false).fetchAnniversary();
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
  // void didUpdateWidget(covariant TodaysAnniversaryWidget oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   // this.widget.
  //   // if(_loggedIn)
  //   // {
  //     didUpdate();
  //   // }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    final anniversaryList = Provider.of<Anniversaries>(context);
    final todaysanniversaries = anniversaryList.findByDate(widget.selectedDate);
    return  LimitedBox(
      child: _isLoading
          ? Center(
              // child: CircularProgressIndicator(),
      )
          : todaysanniversaries.isEmpty?SizedBox()
          // ? Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: Container(
          //       alignment: Alignment.center,
          //       child: Text(
          //         'No Anniversaries',
          //         style: TextStyle(
          //           // alignment: Alignment.center,
          //           fontSize: 16, // child: Text('',style: TextStyle(
          //         ), //   fontSize: 20,
          //       ), // ),),
          //     ),
          //   )
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Anniversaries',style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                      textAlign: TextAlign.left,),
                    TextButton(onPressed: (){
                      Navigator.of(context)
                          .pushNamed(AllAnniversaryScreen.routeName);

                    }, child: Text('Show All',style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),))
                  ],
                ),
                Divider(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) => AnniversaryItem(
                      todaysanniversaries[i].anniversaryId,
                      todaysanniversaries[i].husband_name,
                      todaysanniversaries[i].wife_name,
                      todaysanniversaries[i].dateofanniversary,
                      todaysanniversaries[i].categoryofCouple,
                      // todaysanniversaries[i].relation,
                      categoryColor(todaysanniversaries[i].categoryofCouple)),
                  itemCount: todaysanniversaries.length,
                ),
              ],
            ),
          ),
    );
  }
}

// class AnniversaryItem extends StatelessWidget {
//   String anniversaryId;
//   final String husband_name;
//   final String wife_name;
//   final DateTime anniversaryDate;
//   final CategoryofCouple category;
//   final String relation;
//   final Color categoryColor;
//
//
//   AnniversaryItem(this.anniversaryId, this.husband_name, this.wife_name,
//       this.anniversaryDate, this.category, this.relation, this.categoryColor);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: ()=>Navigator.of(context).pushNamed(AnniversaryDetailScreen.routeName,arguments: anniversaryId),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: categoryColor,
//               child: Text('A',style: TextStyle(
//                 color: Colors.white,
//               ),),
//             ),
//             title: Text('$husband_name-$wife_name'),
//             trailing: Chip(
//               label: Text(relation),
//               backgroundColor: Theme.of(context).highlightColor,
//             ),
//             // Container(
//             //   decoration: BoxDecoration(
//             //     shape: BoxShape.rectangle,
//             //     borderRadius: BorderRadius.circular(5.0),
//             //     border: BoxBorder.
//             //   ),
//             //child: Text(priorityLevelText,style: TextStyle(
//             //),),
//             // ),
//             subtitle: Text(
//               DateFormat('dd / MM').format(anniversaryDate),
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
//
// }
