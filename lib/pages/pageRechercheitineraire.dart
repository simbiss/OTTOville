import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'RouteDetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String currentPosition = "";
  String destination = "";
  Map<String, dynamic>? _fastestRoute;
  Map<String, dynamic>? _ecologicalRoute;

  void _search() async {
    print("Origin: $currentPosition, Destination: $destination");
    List<Location> originLocations = await locationFromAddress(currentPosition);
    List<Location> destinationLocations =
        await locationFromAddress(destination);
    print(originLocations[0].toString());
    print(destinationLocations[0].toString());
    RegExp regExp = RegExp(r'Latitude: ([\d.-]+),\s*Longitude: ([\d.-]+),');
    var matchesOrigin = regExp.firstMatch(originLocations[0].toString());
    var matchesDestinations =
        regExp.firstMatch(destinationLocations[0].toString());
    if (matchesOrigin != null && matchesDestinations != null) {
      String latitudeOrigin = matchesOrigin.group(1) ?? "";
      String longitudeOrigin = matchesOrigin.group(2) ?? "";
      print('Latitude: $latitudeOrigin');
      print('Longitude: $longitudeOrigin');
      String latitudeDestination = matchesDestinations.group(1) ?? "";
      String longitudeDestination = matchesDestinations.group(2) ?? "";
      print('Latitude: $latitudeDestination');
      print('Longitude: $longitudeDestination');

      var url = Uri.parse(
          'https://routes.googleapis.com/directions/v2:computeRoutes?key=AIzaSyDIEkofkq5TZNoUKqXDA8rv8CfNC4aqS9w');
      var body = jsonEncode({
        "origin": {
          "location": {
            "latLng": {"latitude": latitudeOrigin, "longitude": longitudeOrigin}
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": latitudeDestination,
              "longitude": longitudeDestination
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
          "vehicleInfo": {"emissionType": "GASOLINE"}
        },
        "languageCode": "en-US",
        "units": "IMPERIAL",
        "extraComputations": ["FUEL_CONSUMPTION"],
        "requestedReferenceRoutes": ["FUEL_EFFICIENT"]
      });

      var bodyEcologique = jsonEncode({
        "origin": {
          "location": {
            "latLng": {"latitude": latitudeOrigin, "longitude": longitudeOrigin}
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": latitudeDestination,
              "longitude": longitudeDestination
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
          "vehicleInfo": {"emissionType": "GASOLINE"}
        },
        "languageCode": "en-US",
        "units": "IMPERIAL",
        "extraComputations": ["FUEL_CONSUMPTION"],
      });

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Goog-FieldMask":
              "routes.distanceMeters,routes.duration,routes.staticDuration,routes.description,routes.warnings,routes.viewport,routes.travelAdvisory,routes.localizedValues,routes.routeToken,routes.routeLabels,routes.polyline"
        },
        body: body,
      );

      var responseEcologique = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Goog-FieldMask":
              "routes.distanceMeters,routes.duration,routes.staticDuration,routes.description,routes.warnings,routes.viewport,routes.travelAdvisory,routes.localizedValues,routes.routeToken,routes.routeLabels,routes.polyline"
        },
        body: bodyEcologique,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response body: ${responseEcologique.body}');

      if (response.statusCode == 200 && responseEcologique.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        Map<String, dynamic> responseBodyEcologique =
            jsonDecode(responseEcologique.body);

        List<dynamic> routes = responseBody['routes'];
        List<dynamic> routesEcologique = responseBodyEcologique['routes'];

        if (routes.isNotEmpty && routesEcologique.isNotEmpty) {
          _fastestRoute = routes.first;
          _ecologicalRoute = routesEcologique.first;

          print("Fast *********************: ${_fastestRoute}");

          setState(() {
            _searchResults = [
              {
                'title': 'Fastest Route',
                'details': _fastestRoute as Map<String, dynamic>
              },
              {
                'title': 'Most Ecological Route',
                'details': _ecologicalRoute as Map<String, dynamic>
              },
            ];
          });
        } else {
          print('No matches found');
          setState(() {
            _searchResults = [];
          });
        }
      } else {
        print('Error: Response status ${response.statusCode}');
        setState(() {
          _searchResults = [];
        });
      }

      setState(() {
        _searchResults = [
          {
            'title': 'Fastest Route',
            'details': _fastestRoute as Map<String, dynamic>
          },
          {
            'title': 'Most Ecological Route',
            'details': _ecologicalRoute as Map<String, dynamic>
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Search'),
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
                labelText: 'Your Position',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _destinationController,
              onChanged: (position) {
                destination = position;
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
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]['title']),
                    leading: const Icon(Icons.place),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailsPage(
                            routeDetails: _searchResults[index]['details'],
                          ),
                        ),
                      );
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
                icon: Icons.history,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.add,
                text: 'Add',
              ),
              GButton(icon: Icons.account_circle, text: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}
