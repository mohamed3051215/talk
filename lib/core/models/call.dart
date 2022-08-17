import 'package:chat_app/core/enums/call_state.dart';
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/core/service/message_storing_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  static Call fromJson(Map<String, dynamic> data) {
    CallState callState = data["call_state"].toString().contains("answered")
        ? CallState.answered
        : CallState.missed;

    return Call(
        callState: callState,
        date: DateTime.parse(data['date']),
        from: data['from'],
        to: data["to"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "call_state": callState.toString(),
      "date": date.toIso8601String(),
      "from": from.id,
      "to": to.id
    };
  }
}
