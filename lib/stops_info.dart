import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  final List<String> _stopsList = [
    'Bundaran HI',
    'Wisma Nusantara',
    'Plaza Indonesia',
    'Tanah Abang'
  ];

  int _radioValue = 0;

  // function to handle radio button selection
  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
    });
  }

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
          },
          style: const TextStyle(color: Colors.white),
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
                    width: 56.0,
                    height: 30.0,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.group_add, size: 20),
                      label: const Text(""),
                      onPressed: () {
                        _showModalSheet();
                      },
                      // child: const Icon(
                      //   Icons.groups_2,
                      //   size: 16,
                      // ),
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
