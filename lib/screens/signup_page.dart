import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yday/screens/homepage.dart';

class SignUp extends StatelessWidget {
  static const routename = '/signup-page';
  @override
  Widget build(BuildContext context) {
    final mdq=MediaQuery.of(context) ;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          width: mdq.size.width,
          height: mdq.size.height*1.2,
          alignment: Alignment.topCenter,
          //margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                ),
                Card(
                  child: Image(
                    image : AssetImage("assets/images/YD.png"),
                    width: 200,
                    height: 100,
                  ),
                ),
                // IconTheme(
                //   data: IconThemeData(),
                //   child: CircleAvatar(
                //     ///backgroundImage: AssetImage("assets/images/dsc_logo.jpg"),
                //     backgroundColor: Colors.white,
                //     radius: 60.0,
                //   ),
                // ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  "Your Day",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    //fontFamily: 'MarckScript',
                  ),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                Text(
                  "Enter your details here",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                    Icon(Icons.person,color: Colors.green,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      //child: Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: ' First Name',
                          hintText: ' First Name',
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                    // ),
                    Container(
                      width: 2.0,
                      height: 59.0,
                      color: Colors.green,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                    Container(
                      width: MediaQuery.of(context).size.width*0.42,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: ' Last Name',
                          hintText: ' Last Name',
                        ),
                      ),
                    ),
                    //),
                  ]),
                ),
                // // Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                      Icon(Icons.email_rounded,color: Colors.green,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                      Flexible(
                        child:TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: ' Email',
                            hintText: ' Email',
                          ),
                        ),)
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                      Icon(Icons.phone,color: Colors.green,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: ' Phone Number',
                            hintText: ' Phone Number',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                          Icon(Icons.archive_outlined,color: Colors.green,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                          Flexible(
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: ' Password',
                                hintText: ' Password',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Padding(padding: EdgeInsets.symmetric(vertical: 3.0,),),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                          Icon(Icons.check_circle_outline,color: Colors.green,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0,),),
                          Flexible(
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: ' Confirm Password',
                                hintText: ' Confirm Password',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Password must contain at least 6 characters",
                  style: TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0)),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.46,
                    child: RaisedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(HomePage.routeName);
                      },
                      color: Colors.green,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(3.0)),
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Existing User ? Sign in",
                    style: TextStyle(color: Colors.white70,fontSize: 16),
                  ),
                ),
                FlatButton(
                  child: Text(
                    "Skip this step",
                    style: TextStyle(color: Colors.white70),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(HomePage.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
