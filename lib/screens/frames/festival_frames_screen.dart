import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yday/models/frames/festival.dart';
import 'package:yday/models/userdata.dart';
import 'package:yday/providers/frames/festivals.dart';
import 'package:yday/screens/frames/edit_frame_screen.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/widgets/frames/festival_images_widget.dart';
import 'package:yday/widgets/frames/festival_widget.dart';

import 'add_images_to_category.dart';

class FestivalImageScreen extends StatefulWidget {
  static const routeName = '/festival-image-screen';
  String festivalId='';
  String year='';


  FestivalImageScreen({this.festivalId, this.year});

  @override
  _FestivalImageScreenState createState() => _FestivalImageScreenState();
}

class _FestivalImageScreenState extends State<FestivalImageScreen> {
  UserDataModel currentUser;
  // String _festivalId;
  List<Festival> festivalList;
  Festival currentFestival;
  List<String> festivalsImages;
  List<DateTime> festivalsDates;
  // String festivalId;

  bool isLoading = true;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    currentUser = Provider.of<UserData>(context, listen: false).userData;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // _festivalId = ModalRoute.of(context).settings.arguments as String;
    currentFestival = Provider.of<Festivals>(context).findById(widget.festivalId);
    // currentFestival = festivalList[_festivalIndex];
    // festivalId = currentFestival.festivalId;
    festivalsImages = currentFestival.festivalImageUrl;
    festivalsDates = currentFestival.festivalDate.values.toList();
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }
  // Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   children: [
  //     CircleAvatar(radius: 25,child: IconButton(icon: Icon(Icons.add),onPressed: ()=>Navigator.of(context).pushNamed(AddImagesToCategoryScreen.routeName,arguments: festivalId),)),
  //     CircleAvatar(radius: 25,child: IconButton(icon: Icon(Icons.add),onPressed: ()=>Navigator.of(context).pushNamed(AddImagesToCategoryScreen.routeName,arguments: festivalId),)),
  //   ],

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'YourDay',
            style: TextStyle(
              // fontFamily: 'Kaushan Script',
              fontSize: 28,
            ),
          ),
        ),
        body:isLoading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 8,
                shadowColor: Theme.of(context).primaryColor,
                child: Container(
                  // color: Colors.black12,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        currentFestival.festivalName,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                      if(currentFestival.festivalDate!=null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              currentFestival.festivalDate[widget.year]!=null?DateFormat('EEEE, MMM dd, yyyy')
                                .format(currentFestival.festivalDate[widget.year]):'',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      if(currentFestival.festivalDescription!=null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            currentFestival.festivalDescription,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),

                      ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  elevation: 5.0,
                                  insetAnimationCurve:
                                  Curves.slowMiddle,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, i) =>
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
                                            child: Text(DateFormat('EEEE, MMM dd, yyyy').format(
                                                festivalsDates[i]),style: TextStyle(
                                              fontSize: 18
                                            ),),
                                          ),
                                      itemCount: festivalsDates.length,
                                    ),
                                  ),
                                ));

                          },
                          child: Text('Festival Dates')),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Divider(),
              if(currentUser.userRole <4)
              ElevatedButton(
                child: Text('   Add Photos   '),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor
                ),
                onPressed: () => Navigator.of(context).pushNamed(
                    AddImagesToCategoryScreen.routeName,
                    arguments: widget.festivalId),
              ),
              Divider(),
              ListView.builder(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: festivalsImages.length,
                itemBuilder: (ctx, i) => FestivalImageWidget(festivalsImages[i]
                    // festivals[i].festivalName,festivals[i].festivalImageUrl
                    ),
                // child: FestivalWidget(),
                // child: ListView.builder(itemBuilder: (){}),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
  // void deleteFestival()async{
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Provider.of<Festivals>(context, listen: false).deleteFrameCategory(festivalId,currentFestival);
  //   Navigator.of(context).pushNamed(
  //       HomePage.routeName2);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
}
