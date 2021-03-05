// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:googleapis/content/v2_1.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:yday/models/birthday.dart';
// import 'package:yday/providers/birthdays.dart';
// import 'package:yday/screens/add_birthday_screen.dart';
// import 'package:yday/screens/birthday_detail_screen.dart';
//
// import '../models/anniversary.dart';
// import '../providers/anniversaries.dart';
// import '../screens/anniversary_detail.dart';
//
//
// class TodaysAllEvent extends StatefulWidget {
//   final  selectedDate;
//
//   TodaysAllEvent(this.selectedDate);
//
//   @override
//   _TodaysAllEventState createState() => _TodaysAllEventState();
// }
//
// class _TodaysAllEventState extends State<TodaysAllEvent> {
//   @override
//   Widget build(BuildContext context) {
//
//     final birthdaylist = Provider.of<Birthdays>(context);
//     //final birthdays = birthdaylist.birthdayList;
//     var todaysBirthdayList = birthdaylist.findByDate(widget.selectedDate);
//     final anniversaryList = Provider.of<Anniversaries>(context);
//     final todaysanniversaries = anniversaryList.findByDate(widget.selectedDate);
//     // List<BirthDay> todaysBirthday = birthdaylist.findByDate(widget._todaysDate);
//     return todaysBirthdayList.isEmpty ? Container(
//       alignment: Alignment.center,
//       child: Text('No Birthdays Today',style: TextStyle(
//         fontSize: 20,
//       ),),
//     ) : Container(
//       height: 500,
//       child: Column(
//           children: [
//           ListView.builder(
//             itemBuilder: (ctx, i) => TodaysBirthdayItem(todaysBirthdayList[i].birthdayId,todaysBirthdayList[i].nameofperson,todaysBirthdayList[i].dateofbirth,todaysBirthdayList[i].categoryofPerson,todaysBirthdayList[i].relation,todaysBirthdayList[i].categoryColor),
//             itemCount: todaysBirthdayList.length,
//           ),
//             if(todaysanniversaries.isNotEmpty)
//             ListView.builder(
//               itemBuilder: (ctx, i) => AnniversaryItem(todaysanniversaries[i].anniversaryId,todaysanniversaries[i].husband_name,todaysanniversaries[i].wife_name,todaysanniversaries[i].dateofanniversary,todaysanniversaries[i].categoryofCouple,todaysanniversaries[i].relation,todaysanniversaries[i].categoryColor),
//               itemCount: todaysanniversaries.length,
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class TodaysBirthdayItem extends StatelessWidget {
//   String birthdayId;
//   final String title;
//   // final DateTime startdate;
//   final CategoryofPerson category;
//   final String relation;
//   final Color categoryColor;
//
//   var startdate;
//
//
//   TodaysBirthdayItem(this.birthdayId, this.title, this.startdate, this.category,
//       this.relation, this.categoryColor);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: ()=>Navigator.of(context).pushNamed(BirthdayDetailScreen.routeName,arguments: birthdayId),
//           child: ListTile(
//             leading: CircleAvatar(
//               //radius: 30,
//               backgroundColor: categoryColor,
//               child: Text('B',style: TextStyle(
//                 color: Colors.white,
//               ),),
//             ),
//             title: Text(title),
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
//               DateFormat('dd / MM').format(startdate),
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
//
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
//             subtitle: Text(''
//               //DateFormat('dd / MM').format(anniversaryDate),
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
//
// }