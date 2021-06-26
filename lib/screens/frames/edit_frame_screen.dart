import 'package:flutter/material.dart';
import 'package:text_editor/text_editor.dart';

class EditFrameScreen extends StatefulWidget {
  EditFrameScreen({Key key, this.title}) : super(key: key);
  static const routeName = '/edit-frame-screen';

  final String title;

  @override
  _EditFrameScreenState createState() => _EditFrameScreenState();
}

class _EditFrameScreenState extends State<EditFrameScreen> {
  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Billabong',
  );
  String _text = 'Sample Text';
  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  // paletteColors: [
                  //   Colors.black,
                  //   Colors.white,
                  //   Colors.blue,
                  //   Colors.red,
                  //   Colors.green,
                  //   Colors.yellow,
                  //   Colors.pink,
                  //   Colors.cyanAccent,
                  // ],
                  // decoration: EditorDecoration(
                  //   doneButton: Icon(Icons.close, color: Colors.white),
                  //   fontFamily: Icon(Icons.title, color: Colors.white),
                  //   colorPalette: Icon(Icons.palette, color: Colors.white),
                  //   alignment: AlignmentDecoration(
                  //     left: Text(
                  //       'left',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     center: Text(
                  //       'center',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     right: Text(
                  //       'right',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Center(
          child: Stack(
            children: [
              Image.asset('assets/images/bday.jpg'),
              Center(
                child: GestureDetector(
                  onTap: () => _tapHandler(_text, _textStyle, _textAlign),
                  child: Text(
                    _text,
                    style: _textStyle,
                    textAlign: _textAlign,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}