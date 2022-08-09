part of 'notification_cubit.dart';

@immutable
class NotificationState{
  final String? title, body, data, tokenFirebase;
  final bool? tapped;
  final RemoteMessage? message;

  List<Object?> get props => [title,body,data,tokenFirebase];

//<editor-fold desc="Data Methods">

  const NotificationState({
    this.title,
    this.body,
    this.data,
    this.tokenFirebase,
    this.tapped,
    this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is NotificationState &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              body == other.body &&
              data == other.data &&
              tokenFirebase == other.tokenFirebase &&
              tapped == other.tapped &&
              message == other.message
          );

  @override
  int get hashCode =>
      title.hashCode ^ body.hashCode ^ data.hashCode
      ^ tokenFirebase.hashCode ^ tapped.hashCode ^ message.hashCode;

  @override
  String toString() {
    return 'NotificationState{'
        ' title: $title,'
        ' body: $body,'
        ' data: $data,'
        ' tokenFirebase: $tokenFirebase,'
        ' tapped: $tapped,'
        ' message: $message,'
        '}';
  }

  NotificationState copyWith({
    String? title, String? body, String? data, String? tokenFirebase, bool? tapped, RemoteMessage? message
  }) {
    return NotificationState(
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      tokenFirebase: tokenFirebase ?? this.tokenFirebase,
      tapped: tapped ?? this.tapped,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'data': data,
      'tokenFirebase': tokenFirebase,
      'tapped': tapped,
      'message': message,
    };
  }

  factory NotificationState.fromMap(Map<String, dynamic> map) {
    return NotificationState(
      title: map['title'] as String,
      body: map['body'] as String,
      data: map['data'] as String,
      tokenFirebase: map['tokenFirebase'] as String,
      tapped: map['tapped'] as bool,
      message: map['message'] as RemoteMessage,
    );
  }
}
