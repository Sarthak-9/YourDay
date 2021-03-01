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

class AnniversaryWidget extends StatefulWidget {
  @override
  _AnniversaryWidgetState createState() => _AnniversaryWidgetState();
}

class _AnniversaryWidgetState extends State<AnniversaryWidget> {
  @override
  Widget build(BuildContext context) {
    final anniversaryList = Provider.of<Anniversaries>(context);
    final anniversaries = anniversaryList.anniversaryList;
    return Expanded(
      child: anniversaries.isEmpty ? Container(
        alignment: Alignment.center,
        child: Text('No Anniversaries Today',style: TextStyle(
          fontSize: 20,
        ),),
      ) :ListView.builder(
        itemBuilder: (ctx, i) => AnniversaryItem(anniversaries[i].anniversaryId,anniversaries[i].husband_name,anniversaries[i].wife_name,anniversaries[i].dateofanniversary,anniversaries[i].categoryofCouple,anniversaries[i].relation,anniversaries[i].categoryColor),
        itemCount: anniversaries.length,
      ),
      //),
    );
  }
}

class AnniversaryItem extends StatelessWidget {
  String anniversaryId;
  final String husband_name;
  final String wife_name;
  final DateTime anniversaryDate;
  final CategoryofCouple category;
  final String relation;
  final Color categoryColor;


  AnniversaryItem(this.anniversaryId, this.husband_name, this.wife_name,
      this.anniversaryDate, this.category, this.relation, this.categoryColor);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(AnniversaryDetailScreen.routeName,arguments: anniversaryId),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: categoryColor,
              //child: Text('BDay'),
            ),
            title: Text('$husband_name-$wife_name'),
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
              DateFormat('dd / MM').format(anniversaryDate),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

}