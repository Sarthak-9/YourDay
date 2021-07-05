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
                                birthdays[i].imageUrl,
                                birthdays[i].gender
                                ),
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
  final String imageUrl;
  final String gender;
  final DateTime startdate;
  final CategoryofPerson category;

  BirthdayItem(this.birthdayId, this.title, this.startdate, this.category,
       this.imageUrl,this.gender);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      // elevation: 5.0,
      // shadowColor: Theme.of(context).primaryColor,
      child: GestureDetector(

        onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>BirthdayDetailScreen(birthdayId))),
        child: ListTile(
          minVerticalPadding: 0.0,
          leading: CircleAvatar(
            backgroundImage: imageUrl != null?NetworkImage(imageUrl)
                :gender==null? AssetImage('assets/images/userimage.png')
                :gender == 'Male'? AssetImage('assets/images/bday_male_placeholder.jpeg'):gender == 'Female'? AssetImage('assets/images/bday_female_placeholder.jpeg'):AssetImage('assets/images/userimage.png'),
            radius: 25,
            // radius: MediaQuery.of(context).size.width * 0.18,
          ),
          title: Text(title),
          trailing: TextButton(child: Text('View'),onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>BirthdayDetailScreen(birthdayId))) ),

          subtitle: Text(
            DateFormat('EEEE, MMM dd').format(startdate),
          ),
        ),
      ),
    );
  }
}
