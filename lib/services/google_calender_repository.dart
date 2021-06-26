import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yday/models/userevents/google_auth_client.dart';
import 'package:intl/intl.dart';
import 'google_signin_repository.dart';

class GoogleCalenderModel{
    @required String title;
    @required String description;
    // @required String location;
    // @required List<EventAttendee> attendeeEmailList;
    // @required bool shouldNotifyAttendees;
    // @required bool hasConferenceSupport;
    @required DateTime startTime;
    @required DateTime endTime;

    GoogleCalenderModel({
      this.title,
      this.description,
      // this.location,
      // this.attendeeEmailList,
      // this.shouldNotifyAttendees,
      // this.hasConferenceSupport,
      this.startTime,
      this.endTime});
}

class CalendarClient {
  static const _scopes = const [CalendarApi.calendarScope];

  Future<String> insertCalender(GoogleSignInAccount account,GoogleCalenderModel calenderModel)async {
    final headers = await account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
      var calendar = CalendarApi(httpClient);
      calendar.calendarList.list();//.then((value) => print("VAL________$value"));

      String calendarId = "primary";
      Event event = Event();
      // event.
      event.summary = calenderModel.title;
      EventDateTime start = new EventDateTime();
      start.dateTime = calenderModel.startTime;
      start.timeZone = "GMT+05:30";
      event.start = start;
      event.description = calenderModel.description;
      event.recurrence = ["RRULE:FREQ=YEARLY"];
      EventDateTime end = new EventDateTime();
      end.timeZone = "GMT+05:30";
      end.dateTime = calenderModel.endTime;
      event.end = end;
      event.eventType = 'default';
      var calenderResponseId;
      try {
      var response = await  calendar.events.insert(event, calendarId).then((value) {
        calenderResponseId = value.id;
        });
      return calenderResponseId;
      } catch (e) {
        log('Error creating event $e');
        return null;
      }
    // });
  }
  Future<void> deleteEvent(GoogleSignInAccount account, String calenderId)async{
    final headers = await account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    var calendar = CalendarApi(httpClient);
    await calendar.events.delete("primary", calenderId);
    // await calendar.events.update(request, "primary", calenderId);
  }
}
