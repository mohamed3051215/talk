import 'package:chat_app/core/enums/call_state.dart';
import 'package:chat_app/core/models/user.dart';

class Call {
  final UserModel from;
  final UserModel to;
  final DateTime date;
  final CallState callState;

  Call(
      {required this.from,
      required this.to,
      required this.date,
      required this.callState});
}
