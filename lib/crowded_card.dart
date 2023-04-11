import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'crowdedness.dart';

class CrowdedCard extends StatelessWidget {
  final String stationId;

  const CrowdedCard({Key? key, required this.stationId}) : super(key: key);

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
              onPressed: () {
                createUser("Less Crowded", stationId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8)),
              child: const Text('Less crowded', style: TextStyle(fontSize: 14)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                createUser("Little Crowded", stationId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8)),
              child:
                  const Text('Little crowded', style: TextStyle(fontSize: 14)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                createUser("Very Crowded", stationId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8)),
              child: const Text('Very crowded', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Future createUser(String cStatus, String sId) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DateTime tsDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String docId = tsDate.toString();

    final docUser =
        FirebaseFirestore.instance.collection('crowdedness').doc(docId);

    final crowdness = Crowdedness(
        stationId: sId,
        status: cStatus,
        timestamp: tsDate,
        statusValidity: "valid");
    final json = crowdness.toJson();

    await docUser.set(json);
  }
}
