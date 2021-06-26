import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/anniversaries/anniversary.dart';
import 'package:yday/models/constants.dart';
import 'package:yday/models/task.dart';
import 'package:yday/providers/tasks.dart';
import 'package:yday/widgets/anniversaries/anniversary_widget.dart';
import 'package:yday/widgets/birthdays/birthday_widget.dart';
import 'package:yday/widgets/maindrawer.dart';
import 'package:yday/widgets/tasks/task_widget.dart';
import 'add_task.dart';

class AllTaskScreen extends StatefulWidget {
  static const routeName = '/all-task-screen-dart';

  @override
  _AllTaskScreenState createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = true;
  bool _isSearching;
  String _searchText = "";
  // List<dynamic> festivals = [];
  List<Task> searchResult = [];

  _AllTaskScreenState() {
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
    final tasks = Provider.of<Tasks>(context).taskList;

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
                'All Tasks',
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
                        delegate: TaskSearch(tasks));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      Text(
                        '  Search Task',
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  )),
              Divider(),
              TaskWidget(),
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
            Navigator.of(context).pushNamed(AddTask.routeName);
          },
        ),
      ),
    );
  }
}

class TaskSearch extends SearchDelegate<String> {
  List<Task> taskList;

  TaskSearch(this.taskList);

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
    final List<Task> suggestionList = query.isEmpty
        ? []
        : taskList.where((task) {
            return task.title.toLowerCase().contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
      // gridDelegate:
      //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => TaskItem(
          suggestionList[i].taskId,
          suggestionList[i].title,
          suggestionList[i].startdate,
          // tasks[i].enddate,
          suggestionList[i].levelofpriority,
          suggestionList[i].priorityLevelColor,
          suggestionList[i].priorityLevelText), // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Task> suggestionList = query.isEmpty
        ? []
        : taskList.where((task) {
            return task.title.toLowerCase().contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return ListView.builder(
      // gridDelegate:
      //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => TaskItem(
          suggestionList[i].taskId,
          suggestionList[i].title,
          suggestionList[i].startdate,
          // tasks[i].enddate,
          suggestionList[i].levelofpriority,
          suggestionList[i].priorityLevelColor,
          suggestionList[i].priorityLevelText), // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
