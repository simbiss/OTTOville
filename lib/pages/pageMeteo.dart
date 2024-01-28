import 'package:app_ets_projet_durable/serviceMeteo/airQuality.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '/serviceMeteo/meteoModel.dart';
import '/serviceMeteo/meteoService.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        title: Text("Weather2day"),
        backgroundColor: Colors.green,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: search,
                ),
                Text(
                  cityName,
                  style: TextStyle(
                    fontSize: 36,
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
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
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
                        '${airQuality.airQualityPercentage.toStringAsFixed(1)}%'),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: airQuality.airQualityPercentage / 100 < 0.25
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  CheckDanger(condition),
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: isDangerous ? Colors.red : Colors.green,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '7-Day Forecast',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
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
                                color: Colors.green,
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
                                        formatDate(DateTime.now()
                                            .add(Duration(days: index + 1))),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          '${weeklyForecast[index].temperatureC}°C'),
                                      Text(weeklyForecast[index].condition),
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

  void search() {
    cityName = waetherLOcationController.text.toUpperCase();
    getWeather();
    getWeeklyForecast();
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
