import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/birthday_detail_screen.dart';

class BirthdayWidget extends StatefulWidget {
  @override
  _BirthdayWidgetState createState() => _BirthdayWidgetState();
}

class _BirthdayWidgetState extends State<BirthdayWidget> {
  @override
  Widget build(BuildContext context) {
  final birthdaylist = Provider.of<Birthdays>(context);
  final birthdays = birthdaylist.birthdayList;
  var bd = birthdaylist.findByDate(DateTime.now());
    return Expanded(
      child: birthdays.isEmpty ? Container(
        alignment: Alignment.center,
        child: Text('No Birthdays',style: TextStyle(
          fontSize: 20,
        ),),
      ) : ListView.builder(
        itemBuilder: (ctx, i) => BirthdayItem(birthdays[i].birthdayId,birthdays[i].nameofperson,birthdays[i].dateofbirth,birthdays[i].categoryofPerson,birthdays[i].relation,birthdays[i].categoryColor),
        itemCount: birthdays.length,
        ),
      //),
    );
  }
}
class BirthdayItem extends StatelessWidget {
  String birthdayId;
  final String title;
  // final DateTime startdate;
  final CategoryofPerson category;
  final String relation;
  final Color categoryColor;

  var startdate;


  BirthdayItem(this.birthdayId, this.title, this.startdate, this.category,
      this.relation, this.categoryColor);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(BirthdayDetailScreen.routeName,arguments: birthdayId),
          child: ListTile(
            leading: CircleAvatar(
              //radius: 30,
              backgroundColor: categoryColor,
              child: Text('B',style: TextStyle(
                color: Colors.white,
              ),),
            ),
            title: Text(title),
            trailing: Chip(
              label: Text(relation),
              backgroundColor: Theme.of(context).highlightColor,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //     border: BoxBorder.
            //   ),
            //child: Text(priorityLevelText,style: TextStyle(
            //),),
            // ),
            subtitle: Text(
              DateFormat('dd / MM').format(startdate),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}


// class BirthdayItem extends StatelessWidget {
//   String birthdayId;
//   final String title;
//   final DateTime startdate;
//   final CategoryofPerson category;
//   final String relation;
//   final Color categoryColor;
//   BirthdayItem(this.birthdayId,this.title,this.startdate,this.category,this.relation,this.categoryColor);
//
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
//               backgroundColor: categoryColor,
//               //child: Text('BDay'),
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
//
// }