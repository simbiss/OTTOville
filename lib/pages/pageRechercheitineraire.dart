import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  List<String> _searchResults = [];
  String currentPosition = "";
  String destination = "";

  void _search() async {
    var url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes?key=AIzaSyDIEkofkq5TZNoUKqXDA8rv8CfNC4aqS9w');
    var body = jsonEncode({
        "origin":{
    "location":{
      "latLng":{
        "latitude": 37.419734,
        "longitude": -122.0827784
      }
    }
  },
  "destination":{
    "location":{
      "latLng":{
        "latitude": 37.417670,
        "longitude": -122.079595
      }
    }
  },
  "travelMode": "DRIVE",
  "routingPreference": "TRAFFIC_AWARE_OPTIMAL",
  "departureTime": "2024-01-28T15:01:23.045123456Z",
  "computeAlternativeRoutes": false,
  "routeModifiers": {
    "avoidTolls": false,
    "avoidHighways": false,
    "avoidFerries": false,
    "vehicleInfo": {
      "emissionType": "GASOLINE"
    }
  },
  "languageCode": "en-US",
  "units": "IMPERIAL",
  "extraComputations": ["FUEL_CONSUMPTION"],
  "requestedReferenceRoutes": ["FUEL_EFFICIENT"]
    });
    var response = await http.post(url, headers: {"Content-Type": "application/json", "X-Goog-FieldMask": "routes.distanceMeters,routes.duration,routes.routeLabels,routes.routeToken,routes.travelAdvisory.fuelConsumptionMicroliters"}, body: body);

print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');

    setState(() {
      _searchResults = [
        'Résultat 1',
        'Résultat 2',
        'Résultat 3',
        // Ajoutez vos résultats de recherche ici
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche Itinéraire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _startController,
              onChanged: (position) {
                currentPosition = position;
                print("The current position is $currentPosition");
              }, 
              decoration: const InputDecoration(
                labelText: 'Votre position',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _destinationController,
              onChanged: (position) {
                destination = currentPosition;
                print("The destination is $destination");
              },
              decoration: const InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.location_pin),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: const Text('Recherche'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    leading: const Icon(Icons.place),
                    onTap: () {
                      // Implémentez ce qui se passe quand on appuie sur un résultat
                    },
                  );
                },
              ),
            ),
          ],
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
}
