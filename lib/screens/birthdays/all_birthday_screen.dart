import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/birthday.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/birthdays.dart';
import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
import 'package:yday/widgets/birthdays/birthday_widget.dart';
import 'package:yday/widgets/maindrawer.dart';
import 'package:yday/widgets/tasks/task_widget.dart';
import 'add_birthday_screen.dart';

class AllBirthdayScreen extends StatefulWidget {
  static const routeName = '/all-birthday-screen-dart';

  @override
  _AllBirthdayScreenState createState() => _AllBirthdayScreenState();
}

class _AllBirthdayScreenState extends State<AllBirthdayScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = true;
  bool _isSearching = false;
  String _searchText = "";
  // List<dynamic> festivals = [];
  List<BirthDay> searchResult = [];

  _AllBirthdayScreenState() {
    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = searchTextController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final birthdaylist = Provider.of<Birthdays>(context).birthdayList;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          'YourDay',
          style: TextStyle(
            // fontFamily: 'Kaushan Script',
            fontSize: 28,
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              kToolbarHeight -
              NavigationToolbar.kMiddleSpacing,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'All Birthdays',
                style: TextStyle(fontSize: 26.0, fontFamily: 'Libre Baskerville'
                    //color: Colors.white
                    ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              TextButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: BirthDaySearch(birthdaylist));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      Text(
                        '  Search Birthday',
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  )),
              Divider(),
              BirthdayWidget(),
              // SizedBox(
              //   height: 80,
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AddBirthday.routeName);
          },
        ),
      ),
    );
  }
}

class BirthDaySearch extends SearchDelegate<String> {
  List<BirthDay> birthdays;

  BirthDaySearch(this.birthdays);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<BirthDay> suggestionList = query.isEmpty
        ? []
        : birthdays.where((bday) {
            return bday.nameofperson
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
        // gridDelegate:
        //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: suggestionList.length,
        itemBuilder: (ctx, i) => BirthdayItem(
            suggestionList[i].birthdayId,
            suggestionList[i].nameofperson,
            suggestionList[i].dateofbirth,
            suggestionList[i].categoryofPerson,
    suggestionList[i].imageUrl,
    suggestionList[i].gender,
            ) // child: FestivalWidget(),
        // child: ListView.builder(itemBuilder: (){}),
        );
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<BirthDay> suggestionList = query.isEmpty
        ? []
        : birthdays.where((bday) {
            return bday.nameofperson
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
        // gridDelegate:
        //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: suggestionList.length,
        itemBuilder: (ctx, i) => BirthdayItem(
            suggestionList[i].birthdayId,
            suggestionList[i].nameofperson,
            suggestionList[i].dateofbirth,
            suggestionList[i].categoryofPerson,
    suggestionList[i].imageUrl,
    suggestionList[i].gender,
            ) // child: FestivalWidget(),
        // child: ListView.builder(itemBuilder: (){}),
        );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
