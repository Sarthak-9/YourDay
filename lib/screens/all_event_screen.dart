// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:yday/models/anniversaries/anniversary.dart';
// import 'package:yday/models/constants.dart';
// import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
// import 'package:yday/widgets/birthdays/birthday_widget.dart';
// import 'package:yday/widgets/maindrawer.dart';
// import 'package:yday/widgets/tasks/task_widget.dart';
//
// import 'anniversaries/add_anniversary.dart';
// import 'birthdays/add_birthday_screen.dart';
// import 'tasks/add_task.dart';
//
// class AllEvents extends StatefulWidget {
//   static const routeName = '/allevent-screen-dart';
//
//   @override
//   _AllEventsState createState() => _AllEventsState();
// }
//
// class _AllEventsState extends State<AllEvents> {
//   TextEditingController searchTextController = TextEditingController();
//   bool isLoading = true;
//   bool _isSearching;
//   String _searchText = "";
//   // List<dynamic> festivals = [];
//   List<Anniversary> searchResult = [];
//
//   _AllEventsState() {
//     searchTextController.addListener(() {
//       if (searchTextController.text.isEmpty) {
//         setState(() {
//           _isSearching = false;
//           _searchText = "";
//         });
//       } else {
//         setState(() {
//           _isSearching = true;
//           _searchText = searchTextController.text;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int eventnumber = ModalRoute.of(context).settings.arguments as int;
//     Widget selectedEvent(){
//       switch (eventnumber) {
//         case 1:
//           return BirthdayWidget();
//           break;
//         case 2:
//           return AnniversaryWidget();
//           break;
//         case 3:
//           return TaskWidget();
//           break;
//         default:
//           return TaskWidget();
//       }
//     }
//
//     String selectedEventTitle(){
//       switch (eventnumber) {
//         case 1:
//           return 'All Birthdays';
//           break;
//         case 2:
//           return 'All Anniversaries';
//           break;
//         case 3:
//           return 'All Tasks';
//           break;
//         default:
//           return 'All Tasks';
//       }
//     }
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('YourDay',style: TextStyle(
//           fontFamily: 'Kaushan Script',
//           fontSize: 28  ,
//         ),),
//       ),
//       drawer: MainDrawer(),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//             height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-kToolbarHeight-NavigationToolbar.kMiddleSpacing,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(selectedEventTitle(),style: TextStyle(
//                     fontSize: 26.0,
//                     fontFamily: 'Libre Baskerville'
//                   //color: Colors.white
//                 ),),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Divider(),
//                 selectedEvent(),
//                 // SizedBox(
//                 //   height: 80,
//                 // )
//               ],
//             ),),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: IconButton(
//           icon: Icon(Icons.add),
//           onPressed: (){
//             if(eventnumber==1)
//               Navigator.of(context).pushNamed(AddBirthday.routeName);
//             else if(eventnumber==2)
//               Navigator.of(context).pushNamed(AddAnniversary.routeName);
//             else
//               Navigator.of(context).pushNamed(AddTask.routeName);
//           },
//         ),
//       ),
//     );
//   }
// }
// // class FestivalSearch extends SearchDelegate<String> {
// //   List<Festival> festivals;
// //
// //   FestivalSearch(this.festivals);
// //
// //   @override
// //   List<Widget> buildActions(BuildContext context) {
// //     return [
// //       IconButton(
// //         icon: Icon(Icons.clear),
// //         onPressed: () {
// //           query = "";
// //         },
// //       )
// //     ];
// //     throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildLeading(BuildContext context) {
// //     return IconButton(
// //         icon: AnimatedIcon(
// //           icon: AnimatedIcons.menu_arrow,
// //           progress: transitionAnimation,
// //         ),
// //         onPressed: () {
// //           close(context, null);
// //         });
// //     // TODO: implement buildLeading
// //     throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildResults(BuildContext context) {
// //     final List<Festival> suggestionList = query.isEmpty
// //     ? []
// //     : festivals.where((festival) {
// //     return festival.festivalName
// //         .toLowerCase()
// //         .contains(query.toLowerCase());
// //     }).toList();
// //     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
// //     return GridView.builder(
// //     gridDelegate:
// //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
// //     physics: ScrollPhysics(),
// //     shrinkWrap: true,
// //     itemCount: suggestionList.length,
// //     itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
// //     suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
// //     // child: FestivalWidget(),
// //     // child: ListView.builder(itemBuilder: (){}),
// //     );
// //     // TODO: implement buildResults
// //     // throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildSuggestions(BuildContext context) {
// //     final List<Festival> suggestionList = query.isEmpty
// //     ? []
// //     : festivals.where((festival) {
// //     return festival.festivalName
// //         .toLowerCase()
// //         .contains(query.toLowerCase());
// //     }).toList();
// //     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
// //     return GridView.builder(
// //     gridDelegate:
// //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
// //     physics: ScrollPhysics(),
// //     shrinkWrap: true,
// //     itemCount: suggestionList.length,
// //     itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
// //     suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
// //     // child: FestivalWidget(),
// //     // child: ListView.builder(itemBuilder: (){}),
// //     );
// //     // TODO: implement buildSuggestions
// //     throw UnimplementedError();
// //   }
// // }
// // class BirthdaySearch extends SearchDelegate<String> {
// //   List<Birthday> festivals;
// //
// //   FestivalSearch(this.festivals);
// //
// //   @override
// //   List<Widget> buildActions(BuildContext context) {
// //     return [
// //       IconButton(
// //         icon: Icon(Icons.clear),
// //         onPressed: () {
// //           query = "";
// //         },
// //       )
// //     ];
// //     throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildLeading(BuildContext context) {
// //     return IconButton(
// //         icon: AnimatedIcon(
// //           icon: AnimatedIcons.menu_arrow,
// //           progress: transitionAnimation,
// //         ),
// //         onPressed: () {
// //           close(context, null);
// //         });
// //     // TODO: implement buildLeading
// //     throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildResults(BuildContext context) {
// //     final List<Festival> suggestionList = query.isEmpty
// //     ? []
// //     : festivals.where((festival) {
// //     return festival.festivalName
// //         .toLowerCase()
// //         .contains(query.toLowerCase());
// //     }).toList();
// //     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
// //     return GridView.builder(
// //     gridDelegate:
// //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
// //     physics: ScrollPhysics(),
// //     shrinkWrap: true,
// //     itemCount: suggestionList.length,
// //     itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
// //     suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
// //     // child: FestivalWidget(),
// //     // child: ListView.builder(itemBuilder: (){}),
// //     );
// //     // TODO: implement buildResults
// //     // throw UnimplementedError();
// //   }
// //
// //   @override
// //   Widget buildSuggestions(BuildContext context) {
// //     final List<Festival> suggestionList = query.isEmpty
// //     ? []
// //     : festivals.where((festival) {
// //     return festival.festivalName
// //         .toLowerCase()
// //         .contains(query.toLowerCase());
// //     }).toList();
// //     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
// //     return GridView.builder(
// //     gridDelegate:
// //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
// //     physics: ScrollPhysics(),
// //     shrinkWrap: true,
// //     itemCount: suggestionList.length,
// //     itemBuilder: (ctx, i) => FestivalWidget(suggestionList[i].festivalId, i,
// //     suggestionList[i].festivalName, suggestionList[i].festivalImageUrl),
// //     // child: FestivalWidget(),
// //     // child: ListView.builder(itemBuilder: (){}),
// //     );
// //     // TODO: implement buildSuggestions
// //     throw UnimplementedError();
// //   }
// // }
// class AnniversarySearch extends SearchDelegate<String> {
//   List<Anniversary> festivals;
//
//   AnniversarySearch(this.festivals);
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: () {
//           close(context, null);
//         });
//     // TODO: implement buildLeading
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     final List<Anniversary> suggestionList = query.isEmpty
//     ? []
//     : festivals.where((anniv) {
//     return anniv.husband_name
//         .toLowerCase()
//         .contains(query.toLowerCase())||anniv.wife_name
//         .toLowerCase()
//         .contains(query.toLowerCase());
//     }).toList();
//     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
//     return GridView.builder(
//     gridDelegate:
//     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//     physics: ScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: suggestionList.length,
//     itemBuilder: (ctx, i) => AnniversaryItem(
//     suggestionList[i].anniversaryId,
//     suggestionList[i].husband_name,
//     suggestionList[i].wife_name,
//     suggestionList[i].dateofanniversary,
//     suggestionList[i].categoryofCouple,
//     suggestionList[i].relation,
//     categoryColor(suggestionList[i].categoryofCouple))// child: FestivalWidget(),
//     // child: ListView.builder(itemBuilder: (){}),
//     );
//     // TODO: implement buildResults
//     // throw UnimplementedError();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<Anniversary> suggestionList = query.isEmpty
//     ? []
//     : festivals.where((anniv) {
//     return anniv.husband_name
//         .toLowerCase()
//         .contains(query.toLowerCase())||anniv.wife_name
//         .toLowerCase()
//         .contains(query.toLowerCase());
//     }).toList();
//     // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
//     return GridView.builder(
//     gridDelegate:
//     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//     physics: ScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: suggestionList.length,
//     itemBuilder: (ctx, i) => AnniversaryItem(
//     suggestionList[i].anniversaryId,
//     suggestionList[i].husband_name,
//     suggestionList[i].wife_name,
//     suggestionList[i].dateofanniversary,
//     suggestionList[i].categoryofCouple,
//     suggestionList[i].relation,
//     categoryColor(suggestionList[i].categoryofCouple))// child: FestivalWidget(),
//     // child: ListView.builder(itemBuilder: (){}),
//     );
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }
