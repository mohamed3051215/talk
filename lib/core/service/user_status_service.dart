import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserStatuesService {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  Stream<DatabaseEvent> userStatues(String id) {
    final DatabaseReference _userRef = database.ref("users/$id");
    Stream<bool> _mainStream = Stream.castFrom(_userRef.onValue);
    return _userRef.onValue.asBroadcastStream();
  }

  setupMyUser() async {
    final String id = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference _userRef = database.ref("users/$id");
    await _userRef.set({"active": true});
    OnDisconnect onDisconnect = _userRef.onDisconnect();
    onDisconnect.set({"active": false});
  }

  addUser(String id) async {
    final DatabaseReference _userRef = database.ref("users/$id");
    await _userRef.set({"active": true});
  }
}
