import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/anniversaries/anniversary_detail.dart';
import 'package:yday/screens/birthdays/birthday_detail_screen.dart';

class AnniversaryWidget extends StatefulWidget {
  @override
  _AnniversaryWidgetState createState() => _AnniversaryWidgetState();
}

class _AnniversaryWidgetState extends State<AnniversaryWidget> {
  var _isLoading = false;
  var _loggedIn = true;

  Future<void> _refreshAnniversary(BuildContext context) async {
    await Provider.of<Anniversaries>(context, listen: false).fetchAnniversary();
  }

  Future<void> _fetch() async {
    // Future.delayed(Duration.zero).then((_) async {
    _loggedIn = await Provider.of<Anniversaries>(context, listen: false)
        .fetchAnniversary();
    // });
  }

  void didUpdate() async {
    await _fetch();
  }

  // @override
  // void initState() {
  //   // didUpdate();
  //   super.initState();
  // }
  @override
  void didUpdateWidget(covariant AnniversaryWidget oldWidget) {
    // TODO: implement didUpdateWidget
    // this.widget.
    // if(_loggedIn){
    setState(() {
      _isLoading = true;
    });
    didUpdate();
    setState(() {
      _isLoading = false;
    });
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anniversaryList = Provider.of<Anniversaries>(context);
    final anniversaries = anniversaryList.anniversaryList;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _refreshAnniversary(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : !_loggedIn
                ? Center(
                    child: Text(
                      'You are not Logged-in',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
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
                            // anniversaries[i].relation,
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
  // final String relation;
  final Color categoryColor;

  AnniversaryItem(this.anniversaryId, this.husband_name, this.wife_name,
      this.anniversaryDate, this.category, this.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.blue.shade50,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AnniversaryDetailScreen(anniversaryId))),
            child: ListTile(
              // leading: CircleAvatar(
              //   backgroundColor: categoryColor,
              //   child: Text(
              //     'A',
              //     style: TextStyle(
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              title: Text('$husband_name-$wife_name'),
              trailing: TextButton(child: Text('View'),onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AnniversaryDetailScreen(anniversaryId))) ),

              // trailing: Chip(
              //   label: Text(categoryText(category)),
              //   backgroundColor: Colors.amber,
              // ),
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
                DateFormat('EEEE, MMM dd').format(anniversaryDate),
              ),
            ),
          ),
        ),
        // Divider(),
      ],
    );
  }
}
