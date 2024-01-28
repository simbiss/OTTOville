import 'package:app_ets_projet_durable/pages/pageMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteDetailsPage extends StatelessWidget {
  final Map<String, dynamic> routeDetails;

  const RouteDetailsPage({required this.routeDetails});

  @override
  Widget build(BuildContext context) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints
        .decodePolyline(routeDetails['polyline']['encodedPolyline']);
    for (var oneResult in result) {
      print(oneResult);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildInfoRow(
                      Icons.access_time,
                      "Duration",
                      routeDetails['localizedValues']['duration']['text'] ??
                          'N/A'),
                  buildInfoRow(
                      Icons.directions_car,
                      "Distance in Miles",
                      routeDetails['localizedValues']['distance']['text'] ??
                          'N/A'),
                  buildInfoRow(
                      Icons.trending_up,
                      "Distance in Meters",
                      routeDetails['localizedValues']['duration']['text']
                          .toString()),
                  buildInfoRow(Icons.warning, "Warnings",
                      routeDetails['warnings'].toString()),
                  buildInfoRow(
                    Icons.local_gas_station,
                    "Fuel Consumption",
                    routeDetails['travelAdvisory']
                            ['fuelConsumptionMicroliters'] ??
                        'N/A',
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollapsingAppbarPage(polylinePoints: result),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                    ),
                    child:
                        const Text("Navigate", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
