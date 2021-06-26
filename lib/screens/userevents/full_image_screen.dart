import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullImageScreen extends StatelessWidget {
  static const routename = '/full-image-screen';

  @override
  Widget build(BuildContext context) {
    String imageUrl = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        backwardsCompatibility: false,
        elevation: 0.0,
      ),
      body:
      Container(
        alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
                image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain,
              // alignment:Alignment.topCenter,
            ),),
        child:PinchZoom(
          image: Image.network(imageUrl),
          zoomedBackgroundColor: Colors.black.withOpacity(0.5),
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 2.5,
          onZoomStart: (){print('Start zooming');},
          onZoomEnd: (){print('Stop zooming');},
        ),
      ),
      // Container(
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //       color: Colors.black,
      //         image: DecorationImage(
      //       image: NetworkImage(imageUrl),
      //       fit: BoxFit.contain,
      //       // alignment:Alignment.topCenter,
      //     ),),
      //   // child: Image(image: NetworkImage(imageUrl),),
      // ),
    );
  }
}
// appBar: AppBar(
//   backgroundColor: Colors.transparent,
// ),