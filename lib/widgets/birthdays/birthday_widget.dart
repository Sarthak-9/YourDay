import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/birthdays/birthday_detail_screen.dart';

class BirthdayWidget extends StatefulWidget {
  @override
  _BirthdayWidgetState createState() => _BirthdayWidgetState();
}

class _BirthdayWidgetState extends State<BirthdayWidget> {
  var _isLoading = false;
  // var _loggedIn = true;
  Future<void> _refreshBirthday (BuildContext context) async {
    await Provider.of<Birthdays>(context,listen: false).fetchBirthday();
  }

  Future<void> _fetch()async{
    // Future.delayed(Duration.zero).then((_) async {

      await Provider.of<Birthdays>(context,listen: false).fetchBirthday();

    // });
  }

  void didUpdate()async{
    await _fetch();
  }

  // @override
  // void initState() {
  //   // didUpdate();
  //   super.initState();
  // }
  @override
  void didUpdateWidget(covariant BirthdayWidget oldWidget) {
    // TODO: implement didUpdateWidget
    // this.widget.
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
    final birthdaylist = Provider.of<Birthdays>(context);
    final birthdays = birthdaylist.birthdayList;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: ()=>_refreshBirthday(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : birthdays.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No Birthdays',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                            itemBuilder: (ctx, i) => BirthdayItem(
                                birthdays[i].birthdayId,
                                birthdays[i].nameofperson,
                                birthdays[i].dateofbirth,
                                birthdays[i].categoryofPerson,
                                birthdays[i].gender,
                                categoryColor(birthdays[i].categoryofPerson)),
                            itemCount: birthdays.length,
                          ),
      ),
      //),
    );
  }
}

class BirthdayItem extends StatelessWidget {
  String birthdayId;
  final String title;
  final DateTime startdate;
  final CategoryofPerson category;
  final String relation;
  final Color categoryColor;

  BirthdayItem(this.birthdayId, this.title, this.startdate, this.category,
      this.relation, this.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(BirthdayDetailScreen.routeName, arguments: birthdayId),
          child: ListTile(

            title: Text(title),
            trailing: Chip(
              label: Text(categoryText(category)),
              backgroundColor: Colors.amber,
            ),
            subtitle: Text(
              DateFormat('EEEE, MMM dd').format(startdate),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
