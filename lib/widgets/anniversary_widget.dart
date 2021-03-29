import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
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
  var _isLoading = false;

  Future<void> _refreshAnniversary (BuildContext context) async {
    await Provider.of<Anniversaries>(context,listen: false).fetchAnniversary();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Anniversaries>(context,listen: false).fetchAnniversary();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final anniversaryList = Provider.of<Anniversaries>(context);
    final anniversaries = anniversaryList.anniversaryList;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: ()=>_refreshAnniversary(context),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : anniversaries.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  'No Anniversaries',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, i) => AnniversaryItem(
                    anniversaries[i].anniversaryId,
                    anniversaries[i].husband_name,
                    anniversaries[i].wife_name,
                    anniversaries[i].dateofanniversary,
                    anniversaries[i].categoryofCouple,
                    anniversaries[i].relation,
                    categoryColor(anniversaries[i].categoryofCouple)),
                itemCount: anniversaries.length,
              ),
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
  final CategoryofPerson category;
  final String relation;
  final Color categoryColor;

  AnniversaryItem(this.anniversaryId, this.husband_name, this.wife_name,
      this.anniversaryDate, this.category, this.relation, this.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              AnniversaryDetailScreen.routeName,
              arguments: anniversaryId),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: categoryColor,
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
