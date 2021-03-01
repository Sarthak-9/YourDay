import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Task11 extends StatefulWidget {
  @override
  Task11State createState() => Task11State();
}

/// State for MyApp
class Task11State extends State<Task11> {
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;

  @override
  void initState() {
    _selectedDate = '';
    _dateCount = '';
    _range = '';
    _rangeCount = '';
    super.initState();
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('DatePicker demo'),
            ),
            body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    FlatButton(
    child: Text("Open"),
    onPressed: () {
    DateTimeRangePicker(
    startText: "From",
    endText: "To",
    doneText: "Yes",
    cancelText: "Cancel",
    interval: 5,
    initialStartTime: DateTime.now(),
    initialEndTime: DateTime.now().add(Duration(days: 20)),
    mode: DateTimeRangePickerMode.dateAndTime,
    minimumTime: DateTime.now().subtract(Duration(days: 5)),
    maximumTime: DateTime.now().add(Duration(days: 25)),
    use24hFormat: true,
    onConfirm: (start, end) {
    print(start);
    print(end);
    }).showPicker(context);
    },
    ),
    //Text(resultString ?? "")
    ]),
    ),),);
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
//
//
// class MyApp1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Multi Select',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Multi Select'),
//     );
//   }
// }
//
// class Interest {
//   final int id;
//   final String name;
//
//   Interest({
//     this.id,
//     this.name,
//   });
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   static List<Interest> _interestss = [
//     Interest(id: 1, name: "Lion"),
//     Interest(id: 2, name: "Flamingo"),
//     Interest(id: 3, name: "Hippo"),
//     Interest(id: 4, name: "Horse"),
//     Interest(id: 5, name: "Tiger"),
//     Interest(id: 6, name: "Penguin"),
//     Interest(id: 7, name: "Spider"),
//     Interest(id: 8, name: "Snake"),
//     Interest(id: 9, name: "Bear"),
//     Interest(id: 10, name: "Beaver"),
//     Interest(id: 11, name: "Cat"),
//     Interest(id: 12, name: "Fish"),
//     Interest(id: 13, name: "Rabbit"),
//     Interest(id: 14, name: "Mouse"),
//     Interest(id: 15, name: "Dog"),
//     Interest(id: 16, name: "Zebra"),
//     Interest(id: 17, name: "Cow"),
//     Interest(id: 18, name: "Frog"),
//     Interest(id: 19, name: "Blue Jay"),
//     Interest(id: 20, name: "Moose"),
//     Interest(id: 21, name: "Gecko"),
//     Interest(id: 22, name: "Kangaroo"),
//     Interest(id: 23, name: "Shark"),
//     Interest(id: 24, name: "Crocodile"),
//     Interest(id: 25, name: "Owl"),
//     Interest(id: 26, name: "Dragonfly"),
//     Interest(id: 27, name: "Dolphin"),
//   ];
//   final _items = _interestss
//       .map((animal) => MultiSelectItem<Interest>(animal, animal.name))
//       .toList();
//   List<Interest> _selectedAnimals = [];
//   List<Interest> _selectedAnimals2 = [];
//   List<Interest> _selectedAnimals3 = [];
//   List<Interest> _selectedAnimals4 = [];
//   List<Interest> _selectedAnimals5 = [];
//   final _multiSelectKey = GlobalKey<FormFieldState>();
//
//   @override
//   void initState() {
//     _selectedAnimals5 = _interestss;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           alignment: Alignment.center,
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 40),
//               //################################################################################################
//               // Rounded blue MultiSelectDialogField
//               //################################################################################################
//               MultiSelectDialogField(
//                 items: _items,
//                 title: Text("Animals"),
//                 selectedColor: Colors.blue,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.all(Radius.circular(40)),
//                   border: Border.all(
//                     color: Colors.blue,
//                     width: 2,
//                   ),
//                 ),
//                 buttonIcon: Icon(
//                   Icons.pets,
//                   color: Colors.blue,
//                 ),
//                 buttonText: Text(
//                   "Favorite Animals",
//                   style: TextStyle(
//                     color: Colors.blue[800],
//                     fontSize: 16,
//                   ),
//                 ),
//                 onConfirm: (results) {
//                   _selectedAnimals = results;
//                 },
//               ),
//               SizedBox(height: 50),
//               //################################################################################################
//               // This MultiSelectBottomSheetField has no decoration, but is instead wrapped in a Container that has
//               // decoration applied. This allows the ChipDisplay to render inside the same Container.
//               //################################################################################################
//               Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor.withOpacity(.4),
//                   border: Border.all(
//                     color: Theme.of(context).primaryColor,
//                     width: 2,
//                   ),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     MultiSelectBottomSheetField(
//                       initialChildSize: 0.4,
//                       listType: MultiSelectListType.CHIP,
//                       searchable: true,
//                       buttonText: Text("Favorite Animals"),
//                       title: Text("Animals"),
//                       items: _items,
//                       onConfirm: (values) {
//                         _selectedAnimals2 = values;
//                       },
//                       chipDisplay: MultiSelectChipDisplay(
//                         onTap: (value) {
//                           setState(() {
//                             _selectedAnimals2.remove(value);
//                           });
//                         },
//                       ),
//                     ),
//                     _selectedAnimals2 == null || _selectedAnimals2.isEmpty
//                         ? Container(
//                         padding: EdgeInsets.all(10),
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "None selected",
//                           style: TextStyle(color: Colors.black54),
//                         ))
//                         : Container(),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 40),
//               //################################################################################################
//               // MultiSelectBottomSheetField with validators
//               //################################################################################################
//               MultiSelectBottomSheetField<Interest>(
//                 key: _multiSelectKey,
//                 initialChildSize: 0.7,
//                 maxChildSize: 0.95,
//                 title: Text("Animals"),
//                 buttonText: Text("Favorite Animals"),
//                 items: _items,
//                 searchable: true,
//                 validator: (values) {
//                   if (values == null || values.isEmpty) {
//                     return "Required";
//                   }
//                   List<String> names = values.map((e) => e.name).toList();
//                   if (names.contains("Frog")) {
//                     return "Frogs are weird!";
//                   }
//                   return null;
//                 },
//                 onConfirm: (values) {
//                   setState(() {
//                     _selectedAnimals3 = values;
//                   });
//                   _multiSelectKey.currentState.validate();
//                 },
//                 chipDisplay: MultiSelectChipDisplay(
//                   onTap: (item) {
//                     setState(() {
//                       _selectedAnimals3.remove(item);
//                     });
//                     _multiSelectKey.currentState.validate();
//                   },
//                 ),
//               ),
//               SizedBox(height: 40),
//               //################################################################################################
//               // MultiSelectChipField
//               //################################################################################################
//               MultiSelectChipField(
//                 items: _items,
//                 //initialValue: [_animals[4], _animals[7], _animals[9]],
//                 title: Text("Animals"),
//                 headerColor: Colors.blue.withOpacity(0.5),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue[700], width: 1.8),
//                 ),
//                 selectedChipColor: Colors.blue.withOpacity(0.5),
//                 selectedTextStyle: TextStyle(color: Colors.blue[800]),
//                 onTap: (values) {
//                   _selectedAnimals4 = values;
//                 },
//               ),
//               SizedBox(height: 40),
//               //################################################################################################
//               // MultiSelectDialogField with initial values
//               //################################################################################################
//               MultiSelectDialogField(
//                 onConfirm: (val) {
//                   _selectedAnimals5 = val;
//                 },
//                 items: _items,
//                 initialValue:
//                 _selectedAnimals5, // setting the value of this in initState() to pre-select values.
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
