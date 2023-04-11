import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void _showBottomSheet(BuildContext context) async {
  int _counter = 5; // Set the timer to 5 seconds
  Timer _timer;

  // Show the bottom sheet and start the timer
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_counter <= 0) {
          // If the timer runs out, close the bottom sheet and execute the default action
          Navigator.pop(context, 'Default action');
          timer.cancel();
        } else {
          _counter--;
        }
      });

      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Less Crowd'),
              onTap: () {
                // If the user selects "Less Crowd", close the bottom sheet and execute the corresponding action
                Navigator.pop(context, 'Less Crowd');
                _timer.cancel();
              },
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Crowded'),
              onTap: () {
                // If the user selects "Crowded", close the bottom sheet and execute the corresponding action
                Navigator.pop(context, 'Crowded');
                _timer.cancel();
              },
            ),
            ListTile(
              leading: Icon(Icons.dangerous),
              title: Text('Very Crowded'),
              onTap: () {
                // If the user selects "Very Crowded", close the bottom sheet and execute the corresponding action
                Navigator.pop(context, 'Very Crowded');
                _timer.cancel();
              },
            ),
            // Show a loading indicator while the bottom sheet is open
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    },
  ).then((value) {
    // If the bottom sheet is closed without any selection, execute the default action
    if (value == null) {
      // Execute the default action here
      print('Default action');
    } else {
      print('Selected: $value');
    }
  });
}
