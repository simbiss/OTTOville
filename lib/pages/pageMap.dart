import 'package:app_ets_projet_durable/pages/Trajet.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CollapsingAppbarPage extends StatefulWidget {
  const CollapsingAppbarPage({Key? key, required this.polylinePoints}) : super(key: key);
  final List<PointLatLng> polylinePoints;

  @override
  State<CollapsingAppbarPage> createState() => _CollapsingAppbarPageState();
}

class _CollapsingAppbarPageState extends State<CollapsingAppbarPage> {
  final Set<Polyline>_polyline={};

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;
    const LatLng center = LatLng(45.50952298488726, -73.61438069424453);

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                expandedHeight: 650.0,
                floating: false,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: const Text("Collapsing Appbar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: GoogleMap(
                    polylines: _createPolylines(),
                    onMapCreated: onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: center,
                      zoom: 11.0,
                    ),
                  ),
                )),
          ];
        },
        body: ListView.builder(
          itemCount: trajets.length,
          itemBuilder: (BuildContext context, int index) {
            final item = trajets[index];
            return Container(
              height: 136,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.Id,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item.PositionDepart} · ${item.PositionArrivee}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.bookmark_border_rounded),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(item.QteCo2NonEmis),
                      ),
                    ),
                  ),*/
                ],
              ),
            );
          },
        ),
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
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favoris',
              ),
              GButton(
                icon: Icons.add,
                text: 'Ajouter',
              ),
              GButton(icon: Icons.account_circle, text: 'Profil')
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
    PositionArrivee: "2345 Avenue du Mont-Royal, Montreal, QC",
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
