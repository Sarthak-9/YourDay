import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:popover/popover.dart';
import 'package:yday/screens/anniversaries/add_anniversary.dart';
import 'package:yday/screens/birthdays/add_birthday_screen.dart';
import 'package:yday/screens/tasks/add_task.dart';
import 'package:yday/screens/calender.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';

import '../widgets/maindrawer.dart';

class AllEventPopUp extends StatefulWidget {
  @override
  _AllEventPopUpState createState() => _AllEventPopUpState();
}

class _AllEventPopUpState extends State<AllEventPopUp> {
  bool ispop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   title: Text(
      //     'YourDay',
      //     style: TextStyle(
      //       fontFamily: "Kaushan Script",
      //       fontSize: 28,
      //     ),
      //   ),
      //   centerTitle: true,
      //   // automaticallyImplyLeading: false,
      //   actions: [
      //     // if (selectedTab == 0)
      //     // IconButton(
      //     //     icon: Icon(Icons.add),
      //     //     onPressed: ()async {
      //     //
      //     //       Navigator.of(context).pushNamed(AddUserEventScreen.routeName);
      //     //     }),
      //     // if (selectedTab == 4)
      //     //   IconButton(
      //     //       icon: Icon(Icons.edit),
      //     //       onPressed: () {
      //     //         Navigator.of(context)
      //     //             .pushNamed(UserAccountEditScreen.routename);
      //     //       }),
      //   ],
      // ),
      //   drawer: MainDrawer(),
      // body: Builder(
      //   builder: (BuildContext context) => HawkFabMenu(
      //     icon: AnimatedIcons.add_event,
      //     fabColor: Theme.of(context).primaryColor,
      //     iconColor: Colors.white,
      //     items: [
      //       HawkFabMenuItem(
      //           label: 'Birthday',
      //           ontap: () {
      //             Navigator.of(context).pushNamed(AddBirthday.routeName);
      //           },
      //           icon: Icon(
      //             // FlatIcons.g
      //             Icons.person_rounded,
      //             color: Theme.of(context).primaryColor,
      //           ),
      //           color: Colors.white),
      //       HawkFabMenuItem(
      //           label: 'Anniversary',
      //           ontap: () {
      //             Navigator.of(context).pushNamed(AddAnniversary.routeName);
      //           },
      //           icon: Icon(
      //             Icons.people,
      //             color: Theme.of(context).primaryColor,
      //           ),
      //           color: Colors.white),
      //       HawkFabMenuItem(
      //           label: 'Task',
      //           ontap: () {
      //             Navigator.of(context).pushNamed(AddTask.routeName);
      //           },
      //           icon: Icon(
      //             Icons.work_rounded,
      //             color: Theme.of(context).primaryColor,
      //           ),
      //           color: Colors.white),
      //     ],
      //     body: Calendar(),
      //   ),
      //   //),
      // ),
      floatingActionButton: FloatingActionButton(
        // radius: 25.0,
        backgroundColor: Colors.amber,
        child: IconButton(icon: Icon(ispop?Icons.close:Icons.add,color: Colors.black,),
        onPressed: (){
          setState(() {
            ispop =!ispop;
          });
        },),
      ),
      body: Stack(
        children: [
          Calendar(),
          if(ispop)
          GestureDetector(
            onTap: (){
              setState(() {
                ispop = false;
              });
            },
            child: Container(

              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/Untitled design.jpg')
                ),
                // backgroundBlendMode: BlendMode.difference
              ),
              height: 800,width: 500,alignment: Alignment.center,
              child: BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(AddBirthday.routeName);
                        //
                      },
                      child: Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 30,),
                              SizedBox(height: 80,width: 80,child: Image.asset('assets/images/cake.png'),),
                              SizedBox(width: 30,),
                              // TextButton(onPressed: (){
                              //   Navigator.of(context).pushNamed(AddBirthday.routeName);

                              // },
                              //   child:
                                Text('Add Birthday',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              ),),
                                // style: ElevatedButton.styleFrom(
                                //   minimumSize: Size(140, 40),
                                //   primary: MaterialStateColor.resolveWith(
                                //           (states) => Theme.of(context).accentColor),
                                // ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(AddAnniversary.routeName);
                      },
                      child: Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 30,),
                              SizedBox(height: 80,width: 80,child: Image.asset('assets/images/anniversary.png'),),
                              SizedBox(width: 30,),
                              // TextButton(onPressed: (){
                              //   Navigator.of(context).pushNamed(AddAnniversary.routeName);
                              // },
                              // child:
                              Text('Add Anniversary',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              ),),
                                // style: ElevatedButton.styleFrom(
                                //   minimumSize: Size(140, 40),
                                //   primary: MaterialStateColor.resolveWith(
                                //           (states) => Theme.of(context).accentColor),
                                // ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap:  (){
                        Navigator.of(context).pushNamed(AddTask.routeName);
                      },
                      child: Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 30,),
                              SizedBox(height: 80,width: 80,child: Image.asset('assets/images/completed-task.png'),),
                              SizedBox(width: 30,),
                              // TextButton(onPressed: (){
                              //               Navigator.of(context).pushNamed(AddTask.routeName);
                              // }, child:
                              Text('Add Task',style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ),),
                                // style: ElevatedButton.styleFrom(
                                //   minimumSize: Size(140, 40),
                                //   primary: MaterialStateColor.resolveWith(
                                //           (states) => Theme.of(context).accentColor),
                                // ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // color: Colors.grey.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => const ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.top,
            width: 200,
            height: 400,
            arrowHeight: 15,
            arrowWidth: 30,
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Text('Add'),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AddBirthday.routeName);
              },
              child: Container(
                height: 50,
                color: Theme.of(context).primaryColor,
                child: const Center(child: Text('Birthday')),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AddAnniversary.routeName);
              },
              child: Container(
                height: 50,
                color: Theme.of(context).primaryColor,
                child: const Center(child: Text('Anniversary')),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AddTask.routeName);
              },
              child: Container(
                height: 50,
                color: Theme.of(context).primaryColor,
                child: const Center(child: Text('Task')),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
