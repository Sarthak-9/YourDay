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
  List<Festival> festivalList;
  Festival currentFestival;
  List<String> festivalsImages;
  List<DateTime> festivalsDates;
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
    currentFestival = Provider.of<Festivals>(context).findById(widget.festivalId);
    festivalsImages = currentFestival.festivalImageUrl;
    festivalsDates = currentFestival.festivalDate.values.toList();
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(HomePage.routeName),
              child: Image.asset(
                "assets/images/Main_logo.png",
                height: 60,
                width: 100,
              )),
          titleSpacing: 0.1,
          centerTitle: true,
        ),
        body:isLoading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                // width: MediaQuery.of(context).size.width*0.9,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      currentFestival.festivalName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    if(currentFestival.festivalDate!=null&&currentFestival.festivalDate.isNotEmpty)
                      TextButton(
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
                      Text('\ "'+
                        currentFestival.festivalDescription+'.\"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Dancing Script'
                        ),
                      ),
                    SizedBox(height: 10,),
                    // Divider(
                    //   thickness: 5.0,
                    // ),
                    // if(currentFestival.festivalDate!=null&&currentFestival.festivalDate.isNotEmpty)
                    // TextButton(
                        // onPressed: () async {
                        //   await showDialog(
                        //       context: context,
                        //       builder: (ctx) => Dialog(
                        //         elevation: 5.0,
                        //         insetAnimationCurve:
                        //         Curves.slowMiddle,
                        //         child: Padding(
                        //           padding:
                        //           const EdgeInsets.all(8.0),
                        //           child: ListView.builder(
                        //             shrinkWrap: true,
                        //             itemBuilder: (ctx, i) =>
                        //                 Padding(
                        //                   padding:
                        //                   const EdgeInsets.all(
                        //                       8.0),
                        //                   child: Text(DateFormat('EEEE, MMM dd, yyyy').format(
                        //                       festivalsDates[i]),style: TextStyle(
                        //                     fontSize: 18
                        //                   ),),
                        //                 ),
                        //             itemCount: festivalsDates.length,
                        //           ),
                        //         ),
                        //       ));
                        //
                        // },
                        // child: Text('Festival Dates',textScaleFactor: 1.3,)),
                  ],
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
