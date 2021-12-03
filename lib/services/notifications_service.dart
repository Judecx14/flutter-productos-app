import 'package:flutter/material.dart';

class NotificacionsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
