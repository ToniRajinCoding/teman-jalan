import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:teman_jalan/direction.dart';
import 'package:teman_jalan/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _controllerz;
  late LatLng _currentPosition = const LatLng(0, 0);
  List<Marker> _markers = [];
  final TextEditingController _textEditingController = TextEditingController();
  List<Prediction> _predictions = [];
  final _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyBynT6-1hcL8HPsWjpd1uJo3x_xAIWDcLQ');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Teja Prototype'),
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onSubmitted: (query) {},
                  onChanged: (value) {
                    _autoComplete(value);
                  },
                ),
              ),
            ),
          ),
          Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    Prediction prediction = _predictions[index];
                    return ListTile(
                      title: Text(prediction.description!),
                      onTap: () {
                        //_selectPrediction(prediction);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Direction(
                              prediction: prediction,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.map_outlined), label: 'Find'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.directions_bus_filled_outlined),
                        label: 'Stops'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.circle_grid_hex),
                        label: 'Lines'),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentPosition,
        zoom: 13.5,
      ),
    ));
    setState(() {
      _currentPosition = currentPosition;
    });
  }

  void _autoComplete(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    PlacesAutocompleteResponse response = await _places.autocomplete(
      input,
      language: 'en',
      components: [Component(Component.country, 'id')],
    );

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  // void _selectPrediction(Prediction prediction) async {
  //   PlacesDetailsResponse response =
  //       await _places.getDetailsByPlaceId(prediction.placeId!);

  //   if (response.isOkay) {
  //     double lat = response.result.geometry!.location.lat;
  //     double lng = response.result.geometry!.location.lng;
  //     String address = response.result.formattedAddress!;

  //     // Add a marker for the selected location on the map
  //     Marker marker = Marker(
  //       markerId: MarkerId('selected_location'),
  //       position: LatLng(lat, lng),
  //       infoWindow: InfoWindow(title: address),
  //     );
  //     setState(() {
  //       _markers.add(marker);
  //     });

  //     // Navigate to the selected location on the map
  //     _controllerz?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

  //     // Update the search bar text with the selected address
  //     setState(() {
  //       _textEditingController.text = address;
  //       _predictions = [];
  //     });
  //   }
  // }
}
