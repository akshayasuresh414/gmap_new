import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final LatLng _origin = LatLng(13.049864, 80.282742); // Marina Beach
  final LatLng _destination =
      LatLng(13.082680, 80.270718); // Chennai Central Railway Station

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('origin'),
      position: _origin,
      infoWindow: InfoWindow(title: 'Marina Beach'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('destination'),
      position: _destination,
      infoWindow: InfoWindow(title: 'Chennai Central Railway Station'),
    ));
    _createRoute();
  }

  void _createRoute() {
    List<LatLng> polylineCoordinates = [
      LatLng(13.049864, 80.282742), // Marina Beach
      LatLng(13.052622, 80.279099),
      LatLng(13.055265, 80.276158),
      LatLng(13.059489, 80.273277),
      LatLng(13.063272, 80.272060),
      LatLng(13.067061, 80.271227),
      LatLng(13.070722, 80.271031),
      LatLng(13.073885, 80.270813),
      LatLng(13.077040, 80.270769),
      LatLng(13.080194, 80.270774),
      LatLng(13.082680, 80.270718) // Chennai Central Railway Station
    ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Navigation App'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _origin,
          zoom: 13,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        polylines: _polylines,
        markers: _markers,
      ),
    );
  }
}


//AIzaSyDDs4HJWoXt4YCtycv2N_QkiDomQc9AnF8
//12.72408, 80.170680
//12.82070, 80.180450