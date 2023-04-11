import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teman_jalan/cloud_function.dart';
import 'package:teman_jalan/main.dart';
import 'package:teman_jalan/station.dart';
import 'crowdedness.dart';

class StopsInfo extends StatefulWidget {
  //final String id;
  const StopsInfo({super.key});

  @override
  State<StopsInfo> createState() => _StopsInfoState();
}

class _StopsInfoState extends State<StopsInfo> {
  @override
  void initState() {
    //updateStatus(widget.id);
    super.initState();
  }

  List<String> _stopsList = [
    'Bundaran HI',
    'Wisma Nusantara',
    'Plaza Indonesia',
    'Tanah Abang'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onChanged: (value) {
            // Perform search operation
            print(value);
          },
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: GoogleMap(
              // add your map options here
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 10,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nearby Stops',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stopsList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(Icons.train),
                  title: Text(_stopsList[index]),
                  subtitle: const Text('1, 3, 6A, 6B, 9D, M6'),
                  trailing: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(10, 10)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                          visualDensity: VisualDensity.compact),
                      child: const Icon(
                        Icons.groups_2,
                        size: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
