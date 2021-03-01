









// import 'package:flutter/material.dart';
// import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
//
// class CalenderWidget extends StatelessWidget {
//   final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
//       NeatCleanCalendarEvent('Event A',
//           startTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day, 10, 0),
//           endTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day, 12, 0),
//           description: 'A special event',
//           color: Colors.blue[700]),
//     ],
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
//     [
//       NeatCleanCalendarEvent('Event B',
//           startTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day + 2, 10, 0),
//           endTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day + 2, 12, 0),
//           color: Colors.orange),
//       NeatCleanCalendarEvent('Event C',
//           startTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day + 2, 14, 30),
//           endTime: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day + 2, 17, 0),
//           color: Colors.pink),
//     ],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Calendar(
//           startOnMonday: true,
//           weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
//           events: _events,
//           isExpandable: true,
//           eventDoneColor: Colors.green,
//           selectedColor: Colors.pink,
//           todayColor: Colors.blue,
//           // dayBuilder: (BuildContext context, DateTime day) {
//           //   return new Text("!");
//           // },
//           eventListBuilder: (BuildContext context,
//               List<NeatCleanCalendarEvent> _selectesdEvents) {
//             return new Text("!");
//           },
//           eventColor: Colors.grey,
//           locale: 'de_DE',
//           todayButtonText: 'Calender',
//           expandableDateFormat: 'EEEE, dd. MMMM yyyy',
//           dayOfWeekStyle: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
//         ),
//       ),
//     );
//   }
// }
