/*import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Location Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LiveLocationMapPage(),
    );
  }
}

class LiveLocationMapPage extends StatefulWidget {
  @override
  _LiveLocationMapPageState createState() => _LiveLocationMapPageState();
}

class _LiveLocationMapPageState extends State<LiveLocationMapPage> {
  late GoogleMapController mapController;
  LatLng targetLocation = const LatLng(-1.277634, 36.821943); // Default to Nairobi, Kenya

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    final List<Placemark> placemarks = await Geocoder.local.findAddressesFromCoordinates(Coordinates(targetLocation.latitude, targetLocation.longitude));
    String formattedAddress = '';
    if (placemarks.isNotEmpty) {
      formattedAddress = placemarks.first.addressLine;
    }
    print('Formatted Address: $formattedAddress');

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: targetLocation, zoom: 14)));

    mapController.addMarker(MarkerOptions(
      position: targetLocation,
      infoWindowText: InfoWindowText('$formattedAddress'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Location Map')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: targetLocation, zoom: 11.0),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Enter a location'),
                    onChanged: (value) {
                      final query = TextEditingValue(text: value);
                      final geoCodingResponse = Geocoder.local.findAddressesFromQuery(query.text).then((result) {
                        final location = result.first;
                        setState(() {
                          targetLocation = LatLng(location.coordinates.latitude, location.coordinates.longitude);
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/