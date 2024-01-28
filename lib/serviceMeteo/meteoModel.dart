class Weather {
  final double temperatureC;
  final double temperatureF;
  final String condition;

  Weather({
    this.temperatureC = 0,
    this.temperatureF = 0,
    this.condition = "Sunny",
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureC: json['current']['temp_c'],
      temperatureF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
    );
  }
}

class UpComingWeather {
  final double upComingAvgtemperatureC;
  final String upComingcondition;

  UpComingWeather({
    this.upComingAvgtemperatureC = 0,
    this.upComingcondition = "Sunny",
  });

  factory UpComingWeather.fromJson(Map<String, dynamic> json) {
    var dayData = json['forecast']['forecastday'][0]['day'];
    return UpComingWeather(
      upComingAvgtemperatureC: dayData['avgtemp_c'],
      upComingcondition: dayData['condition']['text'],
    );
  }
}
