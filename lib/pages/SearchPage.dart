import 'dart:convert';
import 'dart:ffi';
import 'package:app_ets_projet_durable/pages/network_utility.dart';
import 'package:app_ets_projet_durable/pages/pageProfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'RouteDetailsPage.dart';
import 'pageMap.dart';
import 'pageMeteo.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

enum ActiveTextField { start, destination, none }

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<dynamic> _predictionResults = [];
  String currentPosition = "";
  String destination = "";
  Map<String, dynamic>? _fastestRoute;
  Map<String, dynamic>? _ecologicalRoute;
  ActiveTextField _activeTextField = ActiveTextField.none;

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": "AIzaSyDIEkofkq5TZNoUKqXDA8rv8CfNC4aqS9w"});

    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      Map<String, dynamic> responseBody = jsonDecode(response);

      List<dynamic> predictions = [];
      for (var i = 0; i < responseBody['predictions'].length; i++) {
        predictions.add(responseBody['predictions'][i]['description']);
      }

      if (predictions.isNotEmpty) {
        print("First *********************: ${predictions.first}");

        setState(() {
          _predictionResults = predictions;
        });
      }
    }
  }

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
        "departureTime": "2025-02-28T15:01:23.045123456Z",
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
        "departureTime": "2025-02-28T15:01:23.045123456Z",
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

      if (response.statusCode == 200 && responseEcologique.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        Map<String, dynamic> responseBodyEcologique =
            jsonDecode(responseEcologique.body);

        List<dynamic> routes = responseBody['routes'];
        List<dynamic> routesEcologique = responseBodyEcologique['routes'];

        if (routes.isNotEmpty && routesEcologique.isNotEmpty) {
          _fastestRoute = routes.first;
          _ecologicalRoute = routesEcologique.first;

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
            'details': _fastestRoute as Map<String, dynamic>,
            'onTap': () => _handleRouteSelection('Fastest Route'),
          },
          {
            'title': 'Ecological Route',
            'details': _ecologicalRoute as Map<String, dynamic>,
            'onTap': () => _handleRouteSelection('Ecological Route'),
          },
        ];
      });
    }
  }

  void _handleRouteSelection(String type) {
    _saveRoute(type);
  }

  void _saveRoute(String type) {
    MyAppState appState = context.read<MyAppState>();

    if (type == 'Fastest Route') {
      appState.routeCounter.saveRoute('Fastest Route');
      appState.notifyListeners();
      print(
          "voici le route conter voici  ${appState.routeCounter.countRapide}");
    } else if (type == 'Ecological Route') {
      appState.routeCounter.saveRoute('Ecological Route');
      appState.notifyListeners();
      print(
          "voici le route conter ecologique ${appState.routeCounter.countEcologique}");
    }
  }

  double calculateCO2Emissions(double distanceInMEters) {
    double distanceInKm = distanceInMEters / 1000.0;
    const double emissionFactor = 120;
    double co2Emissions = distanceInKm * emissionFactor;
    return co2Emissions;
  }

  void _showRouteDetails(Map<String, dynamic> routeDetails, String type) {
    PolylinePoints polylinePoints = PolylinePoints();
    String dmeters = routeDetails['distanceMeters'].toString();
    double distanceInMeters = double.parse(dmeters);
    double distanceInKm = distanceInMeters / 1000.0;

    List<PointLatLng> result = polylinePoints
        .decodePolyline(routeDetails['polyline']['encodedPolyline']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoRow(
                        Icons.access_time,
                        "Duration",
                        routeDetails['localizedValues']['duration']['text'] ??
                            'N/A',
                      ),
                      _buildInfoRow(
                        Icons.directions_car,
                        "Distance in Miles",
                        routeDetails['localizedValues']['distance']['text'] ??
                            'N/A',
                      ),
                      _buildInfoRow(
                        Icons.trending_up,
                        "Distance in Meters",
                        routeDetails['distanceMeters'].toString(),
                      ),
                      _buildInfoRow(
                        Icons.warning,
                        "Warnings",
                        routeDetails['warnings'].toString(),
                      ),
                      _buildInfoRow(
                        Icons.local_gas_station,
                        "Fuel Consumption",
                        routeDetails['travelAdvisory']
                                ['fuelConsumptionMicroliters'] ??
                            'N/A',
                      ),
                      _buildInfoRow(
                        Icons.eco,
                        "CO2 Emissions",
                        "120 g/km",
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _saveRoute(type);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CollapsingAppbarPage(
                                        polylinePoints: result,
                                        co2Emissions: calculateCO2Emissions(
                                            distanceInMeters),
                                      ))); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: Text("Navigate",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
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
              RichText(
                text: TextSpan(
                  text: value,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
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
                onTap: () {
                  setState(() {
                    _activeTextField = ActiveTextField.start;
                  });
                },
                onChanged: (position) {
                  currentPosition = position;
                  print("The current position is $currentPosition");
                  placeAutocomplete(position);
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
                onTap: () {
                  setState(() {
                    _activeTextField = ActiveTextField.destination;
                  });
                },
                onChanged: (position) {
                  destination = position;
                  print("The destination is $destination");
                  placeAutocomplete(position);
                },
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.location_pin),
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown list for predictions
              _predictionResults.isNotEmpty
                  ? Container(
                      height: 150, // Set the height according to your needs
                      child: Card(
                        elevation: 4,
                        child: ListView.builder(
                          itemCount: _predictionResults.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              title: Text(_predictionResults[index]),
                              leading: const Icon(Icons.pin_drop),
                              onTap: () {
                                setState(() {
                                  // Update the selected text field based on the active text field
                                  if (_activeTextField ==
                                      ActiveTextField.start) {
                                    currentPosition = _predictionResults[index];
                                    _startController.text = currentPosition;
                                  } else if (_activeTextField ==
                                      ActiveTextField.destination) {
                                    destination = _predictionResults[index];
                                    _destinationController.text = destination;
                                  }
                                  _predictionResults.clear();
                                });
                              },
                            );
                          }),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Search'),
              ),
              const SizedBox(height: 16),
              // Result list
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchResults[index]['title']),
                      leading: const Icon(Icons.place),
                      onTap: () {
                        _showRouteDetails(_searchResults[index]['details'],
                            _searchResults[index]['title']);
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
              selectedIndex: 0,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                  if (selectedIndex == 0) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CollapsingAppbarPage(
                          polylinePoints: [],
                          co2Emissions: 0.0,
                        ), //remplacer par le nom de la  page
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
                  }
                  if (selectedIndex == 1){
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
                  }
                  if (selectedIndex == 2) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            pageProfil(), //remplacer par le nom de la  page
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
                  }
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.map_outlined,
                  text: 'Map',
                ),
                GButton(
                  icon: Icons.sunny,
                  text: 'Weather',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                )
              ],
            ),
          ),
        ));
  }
}
