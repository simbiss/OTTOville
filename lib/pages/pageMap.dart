import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'SearchPage.dart';

class CollapsingAppbarPage extends StatefulWidget {
  const CollapsingAppbarPage({
    Key? key,
    required this.polylinePoints,
    required this.co2Emissions,
  }) : super(key: key);

  final List<PointLatLng> polylinePoints;
  final double co2Emissions;

  @override
  State<CollapsingAppbarPage> createState() => _CollapsingAppbarPageState();
}

class _CollapsingAppbarPageState extends State<CollapsingAppbarPage> {
  final Set<Polyline> _polyline = {};

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    const LatLng center = LatLng(45.50952298488726, -73.61438069424453);

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Route"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              trafficEnabled: true,
              myLocationEnabled: true,
              polylines: _createPolylines(),
              onMapCreated: onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: center,
                zoom: 11.0,
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.polylinePoints.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text("Finish"),
                  ),
                if (widget.polylinePoints.isEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text("Rechercher"),
                  ),
                Text(
                  'CO2 Emissions: ${widget.co2Emissions.toStringAsFixed(2)} g',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<Polyline> _createPolylines() {
    if (widget.polylinePoints.isEmpty) {
      return Set<Polyline>();
    }
    List<LatLng> latLngList = widget.polylinePoints.map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();

    Polyline polyline = Polyline(
      polylineId: const PolylineId('Google Map'),
      color: Colors.blue,
      width: 5,
      points: latLngList,
    );

    return {polyline};
  }
}
