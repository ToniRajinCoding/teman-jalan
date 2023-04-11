import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teman_jalan/home.dart';
import 'package:teman_jalan/cloud_function.dart';
import 'package:teman_jalan/stops_info.dart';

import 'crowded_card.dart';

// import 'package:teja_app/bottom_card.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  updateTimeStatus();

  runApp(
    const MaterialApp(
      home: MapSample(),
    ),
  );
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  late final GoogleMapController markerController;

  List<Marker> _markers = [];

  late StreamSubscription<Position> _positionStream;
  late LatLng _currentPosition = const LatLng(0, 0);
  bool _cardShown = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double _minDistance = double.infinity;
  String _nearestMarkerId = '';
  int x = 0;

  @override
  void initState() {
    super.initState();
    _getMarkersFromFirestore();

    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      print(_markers);

      if (_markers.isNotEmpty) {
        _markers.forEach((marker) {
          double distanceInMeters = Geolocator.distanceBetween(
            _currentPosition.latitude,
            _currentPosition.longitude,
            marker.position.latitude,
            marker.position.longitude,
          );
          if (distanceInMeters <= 25 && distanceInMeters < _minDistance) {
            _minDistance = distanceInMeters;
            _nearestMarkerId = marker.markerId.value;
          }
        });

        if (_nearestMarkerId.isNotEmpty && !_cardShown) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: CrowdedCard(stationId: _nearestMarkerId),
              );
            },
          ).then((value) {
            setState(() {
              _cardShown = true;
            });
          });
        }
      }

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
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

  void buildCard(String sId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: CrowdedCard(stationId: sId));
      },
    );
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentPosition,
        zoom: 17.0,
      ),
    ));

    setState(() {
      _currentPosition = currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Geolocator and Maps Demo'),
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            markers: Set<Marker>.of(_markers),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FloatingActionButton(
                heroTag: "toStops",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StopsInfo()));
                },
                child: Icon(Icons.directions_bus_outlined),
              ),
            ),
          ),
        ]));
  }
}
