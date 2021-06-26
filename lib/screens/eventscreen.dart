// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yday/providers/birthdays.dart';
// import 'package:yday/screens/anniversaries/add_anniversary.dart';
// import 'package:yday/screens/all_event_screen.dart';
// import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
// import 'package:yday/widgets/birthdays/birthday_widget.dart';
// import 'package:yday/widgets/tasks/task_widget.dart';
//
// class EventScreen extends StatefulWidget {
//   static const routeName = '/event-screen';
//
//   @override
//   _EventScreenState createState() => _EventScreenState();
// }
//
// class _EventScreenState extends State<EventScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(8.0),
//       //height: MediaQuery.of(context).size.height*0.9,
//       child: ListView(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context)
//                   .pushNamed(AllEvents.routeName, arguments: 1);
//             },
//             child: Card(
//               shadowColor: primaryColor,
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Container(
//                 height: 200,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         //height: 500,
//                         decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.all(Radius.circular(40)),
//                           border: Border.all(
//                             color: primaryColor,
//                             width: 2,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '  Birthdays',
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.expand_more),
//                               onPressed: () {
//                                 Navigator.of(context).pushNamed(
//                                     AllEvents.routeName,
//                                     arguments: 1);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     BirthdayWidget(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context)
//                   .pushNamed(AllEvents.routeName, arguments: 2);
//             },
//             child: Card(
//               shadowColor: primaryColor,
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Container(
//                 height: 200,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.all(Radius.circular(40)),
//                           border: Border.all(
//                             color: primaryColor,
//                             width: 2,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '  Anniversaries',
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.expand_more),
//                               onPressed: () {
//                                 Navigator.of(context).pushNamed(
//                                     AllEvents.routeName,
//                                     arguments: 2);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     AnniversaryWidget(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // //Divider(),
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context)
//                   .pushNamed(AllEvents.routeName, arguments: 3);
//             },
//             child: Card(
//               shadowColor: primaryColor,
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Container(
//                 height: 200,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.all(Radius.circular(40)),
//                           border: Border.all(
//                             color: primaryColor,
//                             width: 2,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '  Tasks',
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.expand_more),
//                               onPressed: () {
//                                 Navigator.of(context).pushNamed(
//                                     AllEvents.routeName,
//                                     arguments: 3);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     TaskWidget(),
//                   ],
//                 ),
//               ),
//             ),
//           )
//           //Spacer(),
//         ],
//       ),
//     );
//   }
// }
