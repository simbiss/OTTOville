import 'package:app_ets_projet_durable/serviceMeteo/airQuality.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '/serviceMeteo/meteoModel.dart';
import '/serviceMeteo/meteoService.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SearchPage.dart';
import 'pageMap.dart';

class PageMeteo extends StatefulWidget {
  const PageMeteo({Key? key}) : super(key: key);

  @override
  State<PageMeteo> createState() => _PageMeteoState();
}

class _PageMeteoState extends State<PageMeteo> {
  WeatherService weatherService = WeatherService();
  UpComingWeatherService upComingWeatherService = UpComingWeatherService();
  TextEditingController waetherLOcationController = TextEditingController();
  Weather weather = Weather();
  List<Weather> weeklyForecast = [];

  String cityName = "Montreal".toUpperCase();
  double temperatureC = 0;
  String condition = "";
  String iconUrl = "";
  AirQuality airQuality = AirQuality();
  DateTime currentTime = DateTime.now();
  bool isDangerous = false;

  @override
  void initState() {
    super.initState();
    getWeather();
    getWeeklyForecast();
  }

  void getWeather() async {
    weather = await weatherService.getWeatherData(cityName);
    airQuality = await AirQualityService().getAirQualityData(cityName);
    setState(() {
      condition = weather.condition;
      temperatureC = weather.temperatureC;
      iconUrl = weather.iconUrl;
    });
  }

  void getWeeklyForecast() async {
    List<Weather> forecasts = [];
    for (int i = 0; i < 7; i++) {
      DateTime forecastDate = DateTime.now().add(Duration(days: i));
      String formattedDate =
          "${forecastDate.year}-${forecastDate.month.toString().padLeft(2, '0')}-${forecastDate.day.toString().padLeft(2, '0')}";

      try {
        UpComingWeather forecast = await upComingWeatherService
            .getGivenDayWeatherDate(cityName, formattedDate);
        forecasts.add(Weather(
          temperatureC: forecast.upComingAvgtemperatureC,
          condition: forecast.upComingcondition,
          iconUrl: forecast.iconUrl,
        ));
      } catch (e) {
        print('Error fetching weather data for Day $i: $e');
      }
    }

    setState(() {
      weeklyForecast = forecasts;
      print('Weekly forecast updated: $weeklyForecast');
    });
  }

  String CheckDanger(String condition) {
    isDangerous = condition.contains("Rain".toLowerCase()) ||
        condition.contains("Snow".toLowerCase()) ||
        condition.contains("icy".toLowerCase());

    if (isDangerous) {
      return "Stay vigilant on the roads";
    } else {
      return "Road Conditions are good";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Weather2day",
            style: GoogleFonts.questrial(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isDangerous ? Colors.blueGrey : Colors.green,
          centerTitle: false,
        ),
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0), // Corrected padding here
          decoration: BoxDecoration(
            image: DecorationImage(
              image: isDangerous
                  ? NetworkImage(
                      'https://i.pinimg.com/originals/8c/d6/32/8cd632d1be81bb70020f2e54cacd02fd.gif')
                  : NetworkImage(
                      'https://i.pinimg.com/564x/ca/0f/56/ca0f5665840af0e3c8e1345a38d21034.jpg'),
              fit: BoxFit.cover,
            ),
          ),

          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: waetherLOcationController,
                      decoration: InputDecoration(
                        labelText: 'Votre position',
                        labelStyle: TextStyle(
                            color:
                                isDangerous ? Colors.blueGrey : Colors.green),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDangerous
                                  ? Colors.blueGrey
                                  : Colors
                                      .green), // Set the color of the border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDangerous
                                  ? Colors.blueGrey
                                  : Colors
                                      .green), // Set the color of the focused border
                        ),
                      ),
                      onEditingComplete: search,
                    ),
                    Text(
                      cityName,
                      style: GoogleFonts.questrial(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1),
                    Image.network(
                      iconUrl,
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                    SizedBox(height: 1),
                    Text(
                      "${temperatureC.toStringAsFixed(1)}°C",
                      style: GoogleFonts.questrial(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        percent: airQuality.airQualityPercentage / 100,
                        center: Text(
                          'AIR QUALITY',
                          style: GoogleFonts.questrial(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: airQuality.airQualityPercentage / 100 <
                                0.25
                            ? Colors.red
                            : (airQuality.airQualityPercentage / 100 <= 0.50
                                ? Colors.orange
                                : (airQuality.airQualityPercentage / 100 <= 0.75
                                    ? Colors.yellow
                                    : Colors.green)),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      condition,
                      style: GoogleFonts.questrial(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1),
                    SizedBox(
                      child: Card(
                        color: isDangerous ? Colors.red : Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Adjust the alignment as needed
                          children: [
                            IconButton(
                              icon: Icon(Icons.info_sharp),
                              onPressed: () {},
                            ),
                            Text(
                              CheckDanger(condition),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDangerous ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 160,
                      child: weeklyForecast.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: weeklyForecast.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 120,
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.network(
                                            weeklyForecast[index].iconUrl,
                                            width: 50,
                                            height: 50,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.error);
                                            },
                                          ),
                                          Text(
                                            formatDate(DateTime.now().add(
                                                Duration(days: index + 1))),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              '${weeklyForecast[index].temperatureC}°C'),
                                          Text(
                                            weeklyForecast[index].condition,
                                            style: GoogleFonts.questrial(
                                              color: isDangerous
                                                  ? Colors.blueGrey
                                                  : Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(child: Text('Loading forecast...')),
                    ),
                  ],
                ),
              ),
            ),
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
              tabs: [
                GButton(
                  icon: Icons.map_outlined,
                  text: 'Map',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CollapsingAppbarPage(
                          polylinePoints: [],
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
                  },
                ),
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
                )
              ],
            ),
          ),
        ));
  }

  void search() {
    cityName = waetherLOcationController.text.toUpperCase();
    getWeather();
    getWeeklyForecast();
    isDangerous = false;
  }

  String formatDate(DateTime date) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    String day = date.day.toString();
    String month = months[date.month - 1];
    return "$day $month";
  }
}
