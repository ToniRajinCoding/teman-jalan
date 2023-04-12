import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teman_jalan/home.dart';

import 'crowded_card.dart';

class StopsInfo extends StatefulWidget {
  //final String id;
  const StopsInfo({super.key});

  @override
  State<StopsInfo> createState() => _StopsInfoState();
}

class _StopsInfoState extends State<StopsInfo> {
  @override
  void initState() {
    _getMarkersFromFirestore();
    super.initState();
  }

  final List<Marker> _markers = [];
  final List<String> _stopsList = [
    'Bundaran HI',
  ];
  String stationStatus = "";
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Nearby Stops")),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transjakarta_station')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Stack(children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GoogleMap(
                        // add your map options here
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(-6.192779, 106.822617),
                          zoom: 16,
                        ),
                        markers: Set<Marker>.of(_markers),
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nearby Stops halte busway BRT',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          final docs = snapshot.data!.docs;
                          for (final doc in docs) {
                            final statStatus = doc['status'] as String;
                            return ListTile(
                              leading: const Icon(Icons.train),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_stopsList[index]),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 0),
                                    child: Text(
                                      stationStatus,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: const Text('1, 3, 6A, 6B, 9D, M6'),
                              trailing: SizedBox(
                                width: 56.0,
                                height: 30.0,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.group_add, size: 20),
                                  label: const Text(""),
                                  onPressed: () {
                                    _showModalSheet();
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 67.0,
                  right: 16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FloatingActionButton(
                      heroTag: "toStops",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                      child: const Icon(Icons.directions_bus_outlined),
                    ),
                  ),
                ),
              ]);
            }));
  }

  Future<void> _getMarkersFromFirestore() async {
    // fetch data from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('transjakarta_station')
        .get();

    // convert the data to a list of markers
    final markers = snapshot.docs.map((doc) {
      final data = doc.data();
      final markerId = MarkerId(doc.id);
      final position =
          LatLng(data['latlng'].latitude, data['latlng'].longitude);
      return Marker(markerId: markerId, position: position);
    }).toList();

    // set the state with the markers
    setState(() {
      _markers.addAll(markers);
    });
  }

  // Future<String?> getStationData(String id) async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('transjakarta_station')
  //         .doc(id)
  //         .get();

  //     if (snapshot.exists) {
  //       return snapshot['status'];
  //     } else {
  //       print('Document does not exist!');
  //     }
  //   } catch (e) {
  //     print('Error retrieving data: $e');
  //   }
  // }

  // function to handle radio button selection
  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
    });
  }

  void _showModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.groups_2, size: 50.0),
              const SizedBox(height: 10.0),
              const Text(
                'How Crowded is Bundaran HI?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  const Text('Not Crowded'),
                  const Icon(Icons.person, size: 24.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  const Text('Crowded'),
                  const Icon(Icons.group, size: 24.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  const Text('Max Capacity'),
                  const Icon(Icons.warning, size: 24.0),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // code to submit the selected radio value
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
