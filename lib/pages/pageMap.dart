import 'package:app_ets_projet_durable/pages/Trajet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'SearchPage.dart';
import 'package:http/http.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'pageMeteo.dart';

class CollapsingAppbarPage extends StatefulWidget {
  const CollapsingAppbarPage(
      {Key? key, required this.polylinePoints, required this.co2Emissions})
      : super(key: key);
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
                Text(
                  'CO2 Emissions: ${widget.co2Emissions.toStringAsFixed(2)} g',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            gap: 12,
            padding: const EdgeInsets.all(20),
            tabs: [
              GButton(
                icon: Icons.search,
                text: 'Search',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SearchPage(), //remplacer par le nom de la  page
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end);
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );

                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.sunny,
                text: 'Meteo',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const PageMeteo(), //remplacer par le nom de la  page
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end);
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );

                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profil',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SearchPage(), //remplacer par le nom de la  page
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end);
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );

                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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

List<Trajet> trajets = [
  Trajet(
    Id: "1",
    PositionDepart: "123 Avenue Mont-Royal, Montreal, QC",
    PositionArrivee: "456 Avenue du Parc, Montreal, QC",
    QteCo2NonEmis: 10,
  ),
  Trajet(
    Id: "2",
    PositionDepart: "789 Avenue Laurier, Montreal, QC",
    PositionArrivee: "101 Avenue des Pins, Montreal, QC",
    QteCo2NonEmis: 15,
  ),
  Trajet(
    Id: "3",
    PositionDepart: "234 Avenue Papineau, Montreal, QC",
    PositionArrivee: "567 Avenue Greene, Montreal, QC",
    QteCo2NonEmis: 8,
  ),
  Trajet(
    Id: "4",
    PositionDepart: "789 Avenue des Pins, Montreal, QC",
    PositionArrivee: "2345 Av du Mont-Royal, Montreal, QC",
    QteCo2NonEmis: 12,
  ),
  Trajet(
    Id: "5",
    PositionDepart: "678 Avenue McGill, Montreal, QC",
    PositionArrivee: "901 Avenue Saint-Denis, Montreal, QC",
    QteCo2NonEmis: 18,
  ),
  Trajet(
    Id: "6",
    PositionDepart: "3456 Avenue Laurier, Montreal, QC",
    PositionArrivee: "789 Avenue Atwater, Montreal, QC",
    QteCo2NonEmis: 14,
  ),
];
