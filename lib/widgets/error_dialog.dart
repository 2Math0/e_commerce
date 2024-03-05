import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> showErrorDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
