class Weather {
  final double temperatureC;
  final double temperatureF;
  final String condition;
  final String iconUrl;

  Weather({
    this.temperatureC = 0,
    this.temperatureF = 0,
    this.condition = "Sunny",
    this.iconUrl = "",
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureC: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      iconUrl:
          "https:${json['current']['condition']['icon']}", // Ajoutez l'URL de l'icône
    );
  }
}

class UpComingWeather {
  final double upComingAvgtemperatureC;
  final String upComingcondition;
  final String iconUrl;

  UpComingWeather({
    this.upComingAvgtemperatureC = 0,
    this.upComingcondition = "Sunny",
    this.iconUrl = "",
  });

  factory UpComingWeather.fromJson(Map<String, dynamic> json) {
    var dayData = json['forecast']['forecastday'][0]['day'];
    return UpComingWeather(
      upComingAvgtemperatureC: dayData['avgtemp_c'],
      upComingcondition: dayData['condition']['text'],
      iconUrl: "https:${dayData['condition']['icon']}",
    );
  }
}
