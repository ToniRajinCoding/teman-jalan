import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void updateTimeStatus() async {
  final firestoreInstance = FirebaseFirestore.instance;

//ambil data-data waktu dulu
  final now = DateTime.now();
  final currentMinutes = now.minute;
  // mau liat dia itungnya ke :30 atau :00
  final validMinutes = currentMinutes - currentMinutes % 30;
  //jadiin valid minute sebuah DateTime
  final validTime =
      DateTime(now.year, now.month, now.day, now.hour, validMinutes);

  final snapshot = await firestoreInstance.collection('crowdedness').get();

  // Loop semua data-data
  for (var doc in snapshot.docs) {
    //ambil created time buat diitung
    final createTimeObj = (doc.get('timestamp') as Timestamp).toDate();

    //ini kalau misalnya ada yang udah dibawah 16:30 atau 17:00 dijadiin invalid
    //Contoh Created 16:53 before 17:34 jadi < 17:30 = invalid
    //Contoh Created 16:34 before 16:47 jadi > 16:30 = valid
    if (createTimeObj.isBefore(validTime)) {
      firestoreInstance
          .collection('crowdedness')
          .doc(doc.id)
          .update({'statusValidity': 'invalid'});
    }
  }
}

void updateStatus(String cStationId) {
  print("FUNTION BERHASIL DIJALANKAN");

  final DocumentReference stationRef = FirebaseFirestore.instance
      .collection('transjakarta_station')
      .doc("H00022P");

  FirebaseFirestore.instance
      .collection('crowdedness')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              final statusCounts = <String, int>{};
              final status = doc['status'] as String?;
              if (status != null) {
                statusCounts[status] = (statusCounts[status] ?? 0) + 1;
              }
              final mostCommonStatus = statusCounts.entries
                  .reduce((a, b) => a.value > b.value ? a : b)
                  .key;

              stationRef.update({'status': mostCommonStatus});
            })
          });
}
  // final DocumentReference stationRef = FirebaseFirestore.instance
  //     .collection('transjakarta_station')
  //     .doc("H00022P");

  // print("ini sebelom builder");

//   StreamBuilder<QuerySnapshot>(
//       stream: crowdnessRef
//           .where(
//             'statusValidity',
//             isEqualTo: 'valid',
//           )
//           .snapshots(),
//       builder: (context, snapshot) {
//         print("Disnii masih jalannn");
//         final docs = snapshot.data!.docs;

//         if (docs.isEmpty) {
//           print("NO DATA FOUND");
//           return const Center(
//             child: Text('No data found'),
//           );
//         }

//         final statusCounts = <String, int>{};
//         for (final doc in docs) {
//           final status = doc['status'] as String?;
//           if (status != null) {
//             statusCounts[status] = (statusCounts[status] ?? 0) + 1;
//           }
//         }
//         final mostCommonStatus = statusCounts.entries
//             .reduce((a, b) => a.value > b.value ? a : b)
//             .key;

//         print("TEST TEST TEST $mostCommonStatus");

//         stationRef.update({'status': mostCommonStatus});

//         print("UPDATE BERHASIL");

//         return Text(mostCommonStatus);
//       });
// }
