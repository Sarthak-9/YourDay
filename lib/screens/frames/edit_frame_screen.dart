// import 'package:flutter/material.dart';
// import 'package:text_editor/text_editor.dart';
//
// class EditFrameScreen extends StatefulWidget {
//   EditFrameScreen({Key key, this.title}) : super(key: key);
//   static const routeName = '/edit-frame-screen';
//
//   final String title;
//
//   @override
//   _EditFrameScreenState createState() => _EditFrameScreenState();
// }
//
// class _EditFrameScreenState extends State<EditFrameScreen> {
//
//   TextStyle _textStyle = TextStyle(
//     fontSize: 50,
//     color: Colors.white,
//     fontFamily: 'Billabong',
//   );
//   String _text = 'Sample Text';
//   TextAlign _textAlign = TextAlign.center;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         top: false,
//         child: Center(
//           child: Stack(
//             children: [
//               Image.asset('assets/images/bday.jpg'),
//               Center(
//                 child: GestureDetector(
//                   onTap: () => _tapHandler(_text, _textStyle, _textAlign),
//                   child: Text(
//                     _text,
//                     style: _textStyle,
//                     textAlign: _textAlign,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }