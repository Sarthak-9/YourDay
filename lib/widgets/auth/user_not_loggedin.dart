import 'package:flutter/material.dart';
import 'package:yday/screens/auth/login_page.dart';
import 'package:yday/screens/auth/signup_page.dart';

class UserNotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('You are not Logged-in. Sign in with your credentials or register to YourDay to access all the features.',
          style: TextStyle(
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                elevation: 0,
                // minWidth: double.maxFinite,
                height: 50,
                onPressed: (){
                  Navigator.of(context).pushNamed(SignUp.routename);
                },
                color: Colors.green,
                child: Text('SignUp',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal :4.0)),
              MaterialButton(
                elevation: 0,
                // minWidth: double.maxFinite,
                height: 50,
                onPressed: (){
                  Navigator.of(context).pushNamed(LoginPage.routename);
                },
                color: Colors.green,
                child: Text('SignIn',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}