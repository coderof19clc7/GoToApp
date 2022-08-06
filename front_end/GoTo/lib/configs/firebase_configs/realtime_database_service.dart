import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  RealtimeDatabaseService._init();

  static RealtimeDatabaseService get instance => RealtimeDatabaseService._init();
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
}