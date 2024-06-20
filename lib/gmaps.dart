import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  LatLng? _origin;
  LatLng? _destination;

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setLocations();
  }

  Future<void> _createRoute() async {
    if (_origin == null || _destination == null) {
      print('Origin or destination is not set');
      return;
    }

    try {
      String encodedPolyline = await getPolylinePoints();
      _drawRoute(encodedPolyline);
    } catch (error) {
      print('Error fetching polyline points: $error');
    }
  }

  Future<String> getPolylinePoints() async {
    String apiKey =
        'AIzaSyDDs4HJWoXt4YCtycv2N_QkiDomQc9AnF8'; // Replace with your API key
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_origin!.latitude},${_origin!.longitude}&destination=${_destination!.latitude},${_destination!.longitude}&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['routes'].isNotEmpty) {
        return data['routes'][0]['overview_polyline']['points'];
      } else {
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  void _drawRoute(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(encodedPolyline);
    List<LatLng> polylineCoordinates = [];

    for (var point in points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: polylineCoordinates,
    );

    setState(() {
      _polylines.add(polyline);
    });

    // Debug: Print the polyline points
    print('Polyline Points: $polylineCoordinates');
  }

  void _setMarkers() {
    if (_origin != null) {
      _markers.add(Marker(
        markerId: MarkerId('origin'),
        position: _origin!,
        infoWindow: InfoWindow(title: 'Injambakkam'),
      ));
    }

    if (_destination != null) {
      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: _destination!,
        infoWindow: InfoWindow(title: 'Thiruvanmiyur'),
      ));
    }
  }

  void _setLocations() {
    setState(() {
      _origin = LatLng(12.9257, 80.2461); // Injambakkam
      _destination = LatLng(12.9805, 80.2596); // Thiruvanmiyur
    });
    _setMarkers();
    _createRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Navigation App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _originController,
              decoration: InputDecoration(
                labelText: 'Origin',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Update the origin coordinates here if needed
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Update the destination coordinates here if needed
              },
            ),
          ),
          ElevatedButton(
            onPressed: _setLocations,
            child: Text('Set Route'),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(12.9257, 80.2461), // Injambakkam as default
                zoom: 13,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              polylines: _polylines,
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
