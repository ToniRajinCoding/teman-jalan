// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:google_maps_webservice/places.dart';

// class Direction extends StatefulWidget {
//   final Prediction prediction;
//   const Direction({super.key, required this.prediction});

//   @override
//   State<Direction> createState() => _DirectionState();
// }

// class _DirectionState extends State<Direction> {
//   GoogleMapsPlaces _places =
//       GoogleMapsPlaces(apiKey: 'AIzaSyBynT6-1hcL8HPsWjpd1uJo3x_xAIWDcLQ');
//   TextEditingController _originController = TextEditingController();
//   TextEditingController _destinationController = TextEditingController();
//   List<DirectionStep> _steps = [];

//   @override
//   void dispose() {
//     _places.dispose();
//     _originController.dispose();
//     _destinationController.dispose();
//     super.dispose();
//   }

//   void _getDirections() async {
//     // Make sure origin and destination are not empty
//     if (_originController.text.isEmpty || _destinationController.text.isEmpty) {
//       return;
//     }

//     // Autocomplete origin and destination using the Google Places API
//     PlacesAutocompleteResponse originResponse = await _places.autocomplete(
//         _originController.text,
//         types: ['(cities)'],
//         language: 'en');
//     PlacesAutocompleteResponse destinationResponse = await _places.autocomplete(
//         _destinationController.text,
//         types: ['(cities)'],
//         language: 'en');

//     // Make sure there is at least one suggestion for both origin and destination
//     if (originResponse.isNotFound || destinationResponse.isNotFound) {
//       return;
//     }

//     String originPlaceId = originResponse.predictions[0].placeId!;
//     String destinationPlaceId = destinationResponse.predictions[0].placeId!;

//     // Get the transit directions using the Google Directions API
//     DirectionsResponse directionsResponse = await _places.directions(
//         origin: 'place_id:$originPlaceId',
//         destination: 'place_id:$destinationPlaceId',
//         mode: 'transit',
//         language: 'en');

//     if (directionsResponse.isError) {
//       return;
//     }

//     // Parse the directions response and store the steps in a list
//     List<DirectionsStep> steps = [];
//     for (var route in directionsResponse.routes) {
//       for (var leg in route.legs) {
//         for (var step in leg.steps) {
//           if (step.travelMode == 'TRANSIT') {
//             steps.add(step);
//           }
//         }
//       }
//     }

//     setState(() {
//       _steps = steps;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Directional Layout'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _originController,
//                     decoration: InputDecoration(hintText: 'Origin'),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 8.0,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _destinationController,
//                     decoration: InputDecoration(hintText: 'Destination'),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 8.0,
//                 ),
//                 ElevatedButton(
//                   onPressed: _getDirections,
//                   child: Text('Get Directions'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _steps.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   leading: Icon(Icons.directions_transit),
//                   title: Text(_steps[index].htmlInstructions),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
