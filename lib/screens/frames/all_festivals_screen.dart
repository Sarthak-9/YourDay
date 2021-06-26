// import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/run/v1.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/frames/festival.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/screens/frames/festival_frames_screen.dart';
import 'package:yday/widgets/frames/festival_widget.dart';
import 'package:yday/widgets/maindrawer.dart';

import 'add_frames_category_screen.dart';

class AllFestivalScreen extends StatefulWidget {
  static const routeName = '/all-festivals-events-screen';

  @override
  _AllFestivalScreenState createState() => _AllFestivalScreenState();
}

class _AllFestivalScreenState extends State<AllFestivalScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = true;
  bool _isSearching;
  String _searchText = "";
  UserDataModel currentUser;
  // List<dynamic> festivals = [];
  List<Festival> searchResult = [];

  _AllFestivalScreenState() {
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
    // currentUser = Provider.of<UserData>(context, listen: false).userData;
    Future.delayed(Duration.zero).then((value) => fetch());
    setState(() {
      isLoading = false;
    });
    super.initState();
    _isSearching = false;
    // values();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //
  //   super.didChangeDependencies();
  // }
  void fetch() async {
    // var str = await FirebaseMessaging.instance.getToken();
    await Provider.of<Festivals>(context, listen: false).fetchFestival();
  }

  @override
  Widget build(BuildContext context) {
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
      body: festivalEvent(),
    );
  }

  Widget festivalEvent() {
    final List<Festival> festivalList =
        Provider.of<Festivals>(context).yearFestivals;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Festivals of the Year',
                  style:
                      TextStyle(fontSize: 26.0, fontFamily: 'Libre Baskerville'
                          //color: Colors.white
                          ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
                //
                TextButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: FestivalSearch(festivalList));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search),
                        Text(
                          '  Search Festival',
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ],
                    )),
                Divider(),
                (searchResult.length != 0 ||
                        searchTextController.text.isNotEmpty)
                    ? ListView.builder(

                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchResult.length,
                        itemBuilder: (ctx, i) => ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => FestivalImageScreen(
                                        festivalId: searchResult[i].festivalId,
                                        year: DateTime.now().year.toString())));
                              },
                              title: Text(searchResult[i].festivalName),
                              trailing: Text(DateFormat('dd / MM / yyyy')
                                  .format(searchResult[i].festivalDate[
                                      DateTime.now().year.toString()])),
                            )
                        // FestivalWidget(
                        //         searchResult[i].festivalId,
                        //         i,
                        //         searchResult[i].festivalName,
                        //         searchResult[i].festivalImageUrl),
                        )
                    : ListView.builder(
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: festivalList.length,
                        itemBuilder: (ctx, i) => ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => FestivalImageScreen(
                                      festivalId: festivalList[i].festivalId,
                                      year: DateTime.now().year.toString())));
                            },
                            title: Text(festivalList[i].festivalName),
                            trailing: Text(DateFormat('EEEE, MMM dd, yyyy').format(
                                festivalList[i].festivalDate[
                                    DateTime.now().year.toString()]))),
                      ),
                SizedBox(
                  height: 30,
                ),
              ],
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
    return ListView.builder(
      // gridDelegate:
      //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => FestivalImageScreen(
                    festivalId: suggestionList[i].festivalId,
                    year: DateTime.now().year.toString())));
          },
          title: Text(suggestionList[i].festivalName),
          trailing: Text(DateFormat('EEEE, MMM dd, yyyy').format(
              suggestionList[i].festivalDate[DateTime.now().year.toString()]))),
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
    return ListView.builder(
      // gridDelegate:
      //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => FestivalImageScreen(
                    festivalId: suggestionList[i].festivalId,
                    year: DateTime.now().year.toString())));
          },
          title: Text(suggestionList[i].festivalName),
          trailing: Text(DateFormat('EEEE, MMM dd, yyyy').format(
              suggestionList[i].festivalDate[DateTime.now().year.toString()]))),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
