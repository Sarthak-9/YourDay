import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/providers/anniversaries.dart';
import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
import 'package:yday/widgets/birthdays/birthday_widget.dart';
import 'package:yday/widgets/maindrawer.dart';
import 'package:yday/widgets/tasks/task_widget.dart';

import 'add_anniversary.dart';

class AllAnniversaryScreen extends StatefulWidget {
  static const routeName = '/all-anniversary-screen-dart';

  @override
  _AllAnniversaryScreenState createState() => _AllAnniversaryScreenState();
}

class _AllAnniversaryScreenState extends State<AllAnniversaryScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = true;
  bool _isSearching;
  String _searchText = "";
  // List<dynamic> festivals = [];
  List<Anniversary> searchResult = [];

  _AllAnniversaryScreenState() {
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
    final anniversaryList = Provider.of<Anniversaries>(context).anniversaryList;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text('YourDay',style: TextStyle(
          // fontFamily: 'Kaushan Script',
          fontSize: 28  ,
        ),),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-kToolbarHeight-NavigationToolbar.kMiddleSpacing,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text('All Anniversaries',style: TextStyle(
                  fontSize: 26.0,
                  fontFamily: 'Libre Baskerville'
                //color: Colors.white
              ),),
              SizedBox(
                height: 15,
              ),
              Divider(),
              TextButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: AnniversarySearch(anniversaryList));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      Text(
                        '  Search Anniversary',
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  )),
              Divider(),
              AnniversaryWidget(),
              // SizedBox(
              //   height: 80,
              // )
            ],
          ),),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
              Navigator.of(context).pushNamed(AddAnniversary.routeName);

          },
        ),
      ),
    );
  }
}

class AnniversarySearch extends SearchDelegate<String> {
  List<Anniversary> festivals;

  AnniversarySearch(this.festivals);

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
    final List<Anniversary> suggestionList = query.isEmpty
    ? []
    : festivals.where((anniv) {
    return anniv.husband_name
        .toLowerCase()
        .contains(query.toLowerCase())||anniv.wife_name
        .toLowerCase()
        .contains(query.toLowerCase());
    }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
    // gridDelegate:
    // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: suggestionList.length,
    itemBuilder: (ctx, i) => AnniversaryItem(
    suggestionList[i].anniversaryId,
    suggestionList[i].husband_name,
    suggestionList[i].wife_name,
    suggestionList[i].dateofanniversary,
    suggestionList[i].categoryofCouple,
    // suggestionList[i].relation,
    categoryColor(suggestionList[i].categoryofCouple))// child: FestivalWidget(),
    // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Anniversary> suggestionList = query.isEmpty
    ? []
    : festivals.where((anniv) {
    return anniv.husband_name
        .toLowerCase()
        .contains(query.toLowerCase())||anniv.wife_name
        .toLowerCase()
        .contains(query.toLowerCase());
    }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
    // gridDelegate:
    // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: suggestionList.length,
    itemBuilder: (ctx, i) => AnniversaryItem(
    suggestionList[i].anniversaryId,
    suggestionList[i].husband_name,
    suggestionList[i].wife_name,
    suggestionList[i].dateofanniversary,
    suggestionList[i].categoryofCouple,
    // suggestionList[i].relation,
    categoryColor(suggestionList[i].categoryofCouple))// child: FestivalWidget(),
    // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
