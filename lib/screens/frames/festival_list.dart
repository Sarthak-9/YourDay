// import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/frames/festival.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/widgets/frames/festival_widget.dart';
import 'package:yday/widgets/maindrawer.dart';

import 'add_frames_category_screen.dart';

class FestivalList extends StatefulWidget {
  @override
  _FestivalListState createState() => _FestivalListState();
}

class _FestivalListState extends State<FestivalList> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = true;
  bool _isSearching;
  String _searchText = "";
  UserDataModel currentUser;
  // List<dynamic> festivals = [];
  List<Festival> searchResult = [];

  _FestivalListState() {
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
  void initState() {
    setState(() {
      isLoading = true;
    });
    currentUser = Provider.of<UserData>(context, listen: false).userData;
    Future.delayed(Duration.zero).then((value) => fetch());

    super.initState();
    _isSearching = false;
  }

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<Festivals>(context, listen: false).fetchFestival();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentUser.userRole < 4
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AddFramesCategoryScreen.routeName),
                )),
            body: festivalEvent(),
          )
        : Scaffold(
            body: festivalEvent(),
          );
  }

  Widget festivalEvent() {
    final festivalList = Provider.of<Festivals>(context);
    List<Festival> festivals = festivalList.festivals;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
      onRefresh:fetch,

      child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    // padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: FestivalSearch(festivals));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search,color: Theme.of(context).primaryColor,),
                            Text(
                              '  Search',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Divider(),
                  (searchResult.length != 0 ||
                          searchTextController.text.isNotEmpty)
                      ? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchResult.length,
                          itemBuilder: (ctx, i) => FestivalWidget(
                              searchResult[i].festivalId,
                              i,
                              searchResult[i].festivalName,
                              searchResult[i].festivalImageUrl),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: festivals.length,
                          itemBuilder: (ctx, i) => FestivalWidget(
                              festivals[i].festivalId,
                              i,
                              festivals[i].festivalName,
                              festivals[i].festivalImageUrl),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
        );
  }
}

class FestivalSearch extends SearchDelegate<String> {
  List<Festival> festivals;

  FestivalSearch(this.festivals);

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
    final List<Festival> suggestionList = query.isEmpty
        ? []
        : festivals.where((festival) {
            return festival.festivalName
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
          suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Festival> suggestionList = query.isEmpty
        ? []
        : festivals.where((festival) {
            return festival.festivalName
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
          suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
