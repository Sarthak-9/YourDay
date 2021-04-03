import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData with ChangeNotifier {
  final String userEmail;
  final String userPhone;
  final String userName;
  final DateTime dateofBirth;

  UserData({@required this.userEmail,@required this.userPhone,@required this.userName, this.dateofBirth});
  Future<void> addUser(String userEmail,String userPhone,String userName)async{
    var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/user/$userEmail.json');
    try{
      final response = await http.post(url,
          body: json.encode({
            'userEmail': userEmail,
            'username': userName,
            'userPhone': userPhone,
          }));
    } catch (error) {
      throw error;
    }
  }

}

