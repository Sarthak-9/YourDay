
class UserEvent {
  final String userEventId;
  final String folderId;
  final String authorName;
  final String authorId;
  final String userEventName;
  final String userEventNotes;
  final DateTime userDateOfEvent;
  List<String> memberEmails = [];

  UserEvent({this.userEventId, this.folderId,this.authorName,this.authorId, this.userEventName,
      this.userEventNotes, this.userDateOfEvent});
}