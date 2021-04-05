import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/widgets/frames/festival_images_widget.dart';
import 'package:yday/widgets/frames/festival_widget.dart';

class FestivalImageScreen extends StatefulWidget {
  static const routeName = '/festival-image-screen';

  @override
  _FestivalImageScreenState createState() => _FestivalImageScreenState();
}

class _FestivalImageScreenState extends State<FestivalImageScreen> {
  @override
  Widget build(BuildContext context) {
    final _festivalIndex = ModalRoute.of(context).settings.arguments as int;
    final festivalList = Provider.of<Festivals>(context);
    final festivalsImages = festivalList.festivals[_festivalIndex].festivalImageUrl;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('YDay'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('Festival Description',style: TextStyle(
              fontSize: 24.0,
            ),
            ),
            SizedBox(height: 20,),
            Divider(),
            ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: festivalsImages.length,
              itemBuilder: (ctx, i) => FestivalImageWidget(
                festivalsImages[i]
                  // festivals[i].festivalName,festivals[i].festivalImageUrl
              ),
              // child: FestivalWidget(),
              // child: ListView.builder(itemBuilder: (){}),
            ),
          ],
        ),
      ),
    );
  }
}

