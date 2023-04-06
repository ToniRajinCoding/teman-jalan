import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teman_jalan/crowded_card.dart';
// import 'package:teja_app/bottom_card.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

void main() async {
  runApp(
    MaterialApp(
      home: MapSample(),
    ),
  );
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  late StreamSubscription<Position> _positionStream;
  late LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _marker.position.latitude,
          _marker.position.longitude,
        );

        print('Distance to marker: $distanceInMeters meters');

        if (distanceInMeters < 25) {
          buildCard();
          print("SAMPAII");
        }
      });
    });
  }

  void buildCard() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CrowdedCard(),
        );
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
      _markers.add(_marker);
      _currentPosition = currentPosition;
    });
  }

  Marker _marker = Marker(
    markerId: MarkerId('myMarker'),
    position: LatLng(-6.193021, 106.823),
    //position: LatLng(-6.182283, 106.839426),
    infoWindow: InfoWindow(title: 'My Marker'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocator and Maps Demo'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
