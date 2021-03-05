import 'package:flutter/material.dart';
import 'package:yday/screens/homepage.dart';
import 'package:yday/screens/signup_page.dart';

class LoginPage extends StatelessWidget {
  static const routename = '/login';
  @override
  Widget build(BuildContext context) {
    final mdq = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        //alignment: Alignment.topCenter,
        width: mdq.size.width,
        height: mdq.size.height,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60.0),
              ),
              // CircleAvatar(
              //   backgroundImage: AssetImage("assets/images/YD.png"), //,
              //   backgroundColor: Colors.white,
              //   radius: 60.0,
              // ),
              Card(
                child: Image(
                    image : AssetImage("assets/images/YD.png"),
                  width: 200,
                  height: 100,
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Text(
                'Your Day',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text(
                "Enter your details here",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Form(
                child: Column(
                  children: [
                    Card(
                      borderOnForeground: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                          ),
                          Icon(
                            Icons.email_sharp,
                            color: Colors.green,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: " Email / Phone ",
                                hintText: " Email or Phone",
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                            ),
                            Icon(
                              Icons.archive_outlined,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: " Password",
                                  hintText: " Password",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      alignment: Alignment.center,
                      child: RaisedButton(
                        child: Text(
                          'Sign In',
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
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              OutlineButton(
                child: Text(
                  "  New here ? Sign Up  ",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUp.routename);
                  //Navigator.pushNamed(context, SignUp.routename);
                },
                textColor: Colors.amber,
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(HomePage.routeName);
                  //Navigator.pushReplacementNamed(context, MainHomePage.id);
                },
                child: Text(
                  "Forgot Password ? Need help ",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              // Padding(padding: EdgeInsets.all(2.0)),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(HomePage.routeName);
                  //Navigator.pushReplacementNamed(context, MainHomePage.id);
                },
                child: Text(
                  "Skip this step",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
