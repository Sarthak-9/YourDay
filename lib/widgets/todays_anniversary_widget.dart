import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/anniversary_detail.dart';
import 'package:yday/screens/birthday_detail_screen.dart';

import 'anniversary_widget.dart';

class TodaysAnniversaryWidget extends StatefulWidget {
  final  selectedDate;

  TodaysAnniversaryWidget(this.selectedDate);

  @override
  _TodaysAnniversaryWidgetState createState() => _TodaysAnniversaryWidgetState();
}

class _TodaysAnniversaryWidgetState extends State<TodaysAnniversaryWidget> {
  @override
  Widget build(BuildContext context) {

    final anniversaryList = Provider.of<Anniversaries>(context);
    final todaysanniversaries = anniversaryList.findByDate(widget.selectedDate);
    return todaysanniversaries.isEmpty ? Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        alignment: Alignment.center,
              child: Text('No Anniversaries',style: TextStyle(// alignment: Alignment.center,
                fontSize: 16,// child: Text('',style: TextStyle(
              ),//   fontSize: 20,
              ),// ),),
      ),
    ) :Container(
      height: 200,
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemBuilder: (ctx, i) => AnniversaryItem(todaysanniversaries[i].anniversaryId,todaysanniversaries[i].husband_name,todaysanniversaries[i].wife_name,todaysanniversaries[i].dateofanniversary,todaysanniversaries[i].categoryofCouple,todaysanniversaries[i].relation,todaysanniversaries[i].categoryColor),
        itemCount: todaysanniversaries.length,
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