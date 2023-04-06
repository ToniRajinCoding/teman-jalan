import 'package:flutter/material.dart';

class CrowdedCard extends StatelessWidget {
  const CrowdedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Less crowded', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Little crowded', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Very crowded', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8)),
            ),
          ),
        ],
      ),
    );
  }
}
