// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yday/providers/birthdays.dart';
// import 'package:yday/widgets/anniversaries/todays_anniversary_widget.dart';
// import 'package:yday/widgets/birthdays/todays_birthday_widget.dart';
// import 'package:yday/widgets/frames/todays_festival_widget.dart';
// import 'package:yday/widgets/tasks/todays_task_widget.dart';
//
//
//
// class TodaysEventScreen extends StatefulWidget {
//
//   // const TodaysEventScreen({Key key}) : super(key: key);
//   int _selectedDay;
//   static const routeName = '/todays-event-screen';
//   @override
//   _TodaysEventScreenState createState() => _TodaysEventScreenState();
// }
//
// class _TodaysEventScreenState extends State<TodaysEventScreen> {
//   bool _isLoading = true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   // void fetch()async{
//   //   Future.delayed(Duration.zero).then((_) async {
//   //     setState(() {
//   //       _isLoading = true;
//   //     });
//   //     await Provider.of<Birthdays>(context,listen: false).fetchBirthday();
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     // var _selectedDay;
//     return Container(
//       // height: 500,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TodaysBirthdayWidget(widget._selectedDay),
//             Text(' Anniversaries',style: TextStyle(
//             fontSize: 20,
//             color: Theme.of(context).primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//             textAlign: TextAlign.left,),
//           Divider(),
//           TodaysAnniversaryWidget(widget._selectedDay),
//           Padding(padding: EdgeInsets.all(5),),
//           Text(' Tasks',style: TextStyle(
//             fontSize: 20,
//             color: Theme.of(context).primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//             textAlign: TextAlign.left,),
//           Divider(),
//           TodaysTaskWidget(widget._selectedDay),
//           Divider(),
//           TodaysFestivalWidget(widget._selectedDay),
//           Padding(padding: EdgeInsets.all(5),),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:yday/providers/birthdays.dart';
// // import 'package:yday/screens/anniversaries/add_anniversary.dart';
// // import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
// // import 'package:yday/widgets/birthdays/birthday_widget.dart';
// // import 'package:yday/widgets/tasks/task_widget.dart';
// // import 'package:yday/widgets/birthdays/todays_birthday_widget.dart';
// //
// // import 'birthdays/add_birthday_screen.dart';
// // import 'tasks/add_task.dart';
// //
// // class TodaysEventScreen extends StatefulWidget {
// //   static const routeName = '/todays-event-screen';
// //
// //   @override
// //   _TodaysEventScreenState createState() => _TodaysEventScreenState();
// // }
// //
// // class _TodaysEventScreenState extends State<TodaysEventScreen> {
// //   bool _isLoading = true;
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //   }
// //   void fetch()async{
// //     Future.delayed(Duration.zero).then((_) async {
// //       setState(() {
// //         _isLoading = true;
// //       });
// //       await Provider.of<Birthdays>(context,listen: false).fetchBirthday();
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final selectedDate = ModalRoute.of(context).settings.arguments as DateTime;
// //     final birthdaylist = Provider.of<Birthdays>(context);
// //     //final birthdays = birthdaylist.birthdayList;
// //     return ListView(
// //       children: [
// //         Card(
// //           shadowColor: Colors.green,
// //           elevation: 5.0,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15.0),
// //           ),
// //           child: Container(
// //             height: 200,
// //             child: Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     //height: 500,
// //                     decoration: BoxDecoration(
// //                       color: Colors.green.withOpacity(0.1),
// //                       borderRadius: BorderRadius.all(Radius.circular(40)),
// //                       border: Border.all(
// //                         color: Colors.green,
// //                         width: 2,
// //                       ),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text('  Birthdays',style: TextStyle(
// //                           fontSize: 20.0,
// //                         ),),
// //                         IconButton(icon: Icon(Icons.add), onPressed: () {
// //                           Navigator.of(context).pushNamed(AddBirthday.routeName);
// //                         },),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 TodaysBirthdayWidget(selectedDate),
// //               ],
// //             ),
// //           ),
// //         ),
// //         Card(
// //           shadowColor: Colors.green,
// //           elevation: 5.0,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15.0),
// //           ),
// //           child: Container(
// //             height: 200,
// //             child: Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       color: Colors.green.withOpacity(0.1),
// //                       borderRadius: BorderRadius.all(Radius.circular(40)),
// //                       border: Border.all(
// //                         color: Colors.green,
// //                         width: 2,
// //                       ),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text('  Anniversary',style: TextStyle(
// //                           fontSize: 20.0,
// //                         ),),
// //                         IconButton(icon: Icon(Icons.add), onPressed: () {
// //                           Navigator.of(context).pushNamed(AddAnniversary.routeName);
// //                         },),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 AnniversaryWidget(),
// //               ],
// //             ),
// //           ),
// //         ),
// //         // //Divider(),
// //         Card(
// //           shadowColor: Colors.green,
// //           elevation: 5.0,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15.0),
// //           ),
// //           child: Container(
// //             height: 200,
// //             child: Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       color: Colors.green.withOpacity(0.1),
// //                       borderRadius: BorderRadius.all(Radius.circular(40)),
// //                       border: Border.all(
// //                         color: Colors.green,
// //                         width: 2,
// //                       ),
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text('  Todo Tasks',style: TextStyle(
// //                           fontSize: 20.0,
// //                         ),),
// //                         IconButton(icon: Icon(Icons.add), onPressed: () {
// //                           Navigator.of(context).pushNamed(AddTask.routeName);
// //                         },),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 TaskWidget(),
// //               ],
// //             ),
// //           ),
// //         )
// //         //Spacer(),
// //       ],
// //     );
// //   }
// // }
