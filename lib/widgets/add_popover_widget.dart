import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:popover/popover.dart';
import 'package:yday/screens/add_anniversary.dart';
import 'package:yday/screens/add_birthday_screen.dart';
import 'package:yday/screens/add_task.dart';
import 'package:yday/screens/calender.dart';

// class PopoverExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Popover Example')),
//         body: const SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Button(),
//           ),
//         ),
//       ),
//     );
//   }
// }
class AllEventPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
// builder is used only for the snackbar, if you don't want the snackbar you can remove
// Builder from the tree
      builder: (BuildContext context) => HawkFabMenu(
        icon: AnimatedIcons.add_event,
        fabColor: Theme.of(context).primaryColor,
        iconColor: Colors.white,
        items: [
          HawkFabMenuItem(
              label: 'Birthday',
              ontap: () {
                // Scaffold.of(context)..hideCurrentSnackBar();
                // Scaffold.of(context).showSnackBar(
                //   SnackBar(content: Text('Menu 1 selected')),
                // );
                Navigator.of(context).pushNamed(AddBirthday.routeName);
              },
              icon: Icon(
                Icons.person_rounded,
                color: Theme.of(context).primaryColor,
              ),
              // color: Theme.of(context).primaryColor,
              //labelColor: Colors.blue,
              color: Colors.white),
          HawkFabMenuItem(
              label: 'Anniversary',
              ontap: () {
                // Scaffold.of(context)..hideCurrentSnackBar();
                // Scaffold.of(context).showSnackBar(
                //   SnackBar(content: Text('Menu 2 selected')),
                // );
                Navigator.of(context).pushNamed(AddAnniversary.routeName);
              },
              icon: Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
              ),
              // labelColor: Colors.white,
              // labelBackgroundColor: Colors.blue,
              color: Colors.white),
          HawkFabMenuItem(
              label: 'Task',
              ontap: () {
                // Scaffold.of(context)..hideCurrentSnackBar();
                // Scaffold.of(context).showSnackBar(
                //   SnackBar(content: Text('Menu 3 selected')),
                // );
                Navigator.of(context).pushNamed(AddTask.routeName);
              },
              icon: Icon(
                Icons.work_rounded,
                color: Theme.of(context).primaryColor,
              ),
              color: Colors.white),
        ],
        body: Calendar(),
      ),
      //),
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
// class Button extends StatelessWidget {
//   const Button({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: const Center(child: Text('Click Me')),
//       onTap: () {
//         showPopover(
//           context: context,
//           bodyBuilder: (context) => const ListItems(),
//           onPop: () => print('Popover was popped!'),
//           direction: PopoverDirection.bottom,
//           width: 200,
//           height: 400,
//           arrowHeight: 15,
//           arrowWidth: 30,
//         );
//       },
//     );
//   }
// }

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
                //print('GestureDetector was called on Entry A');
                Navigator.of(context).pushNamed(AddBirthday.routeName);

                //Navigator.of(context).pop();
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
                //print('GestureDetector was called on Entry A');
                Navigator.of(context).pushNamed(AddAnniversary.routeName);

                //Navigator.of(context).pop();
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
                //print('GestureDetector was called on Entry A');
                Navigator.of(context).pushNamed(AddTask.routeName);

                //Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                color: Theme.of(context).primaryColor,
                child: const Center(child: Text('Task')),
              ),
            ),
            const Divider(),
            // Container(
            //   height: 50,
            //   color: Colors.amber[200],
            //   child: const Center(child: Text('Entry B')),
            // ),
          ],
        ),
      ),
    );
  }
}
