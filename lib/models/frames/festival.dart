import 'package:flutter/material.dart';

class Festival{
  final String festivalId;
  final String festivalName;
   String festivalDescription;
   Map<String,DateTime> festivalDate;
  List<String> festivalImageUrl;

  Festival({this.festivalId, this.festivalName,this.festivalDescription,this.festivalDate, this.festivalImageUrl});
}