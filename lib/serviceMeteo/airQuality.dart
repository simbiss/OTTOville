import 'dart:convert';

import 'package:http/http.dart' as http;

class AirQualityStandards {
  static const double maxCO = 10.0; // Exemple de valeurs maximales acceptables
  static const double maxNO2 = 200.0;
  static const double maxO3 = 180.0;
  static const double maxSO2 = 20.0;
  static const double maxPM25 = 25.0;
}

class AirQuality {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm25;

  AirQuality(
      {this.co = 0.0,
      this.no2 = 0.0,
      this.o3 = 0.0,
      this.so2 = 0.0,
      this.pm25 = 0.0});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    var airQualityJson = json['current']['air_quality'];
    return AirQuality(
      co: airQualityJson['co'],
      no2: airQualityJson['no2'],
      o3: airQualityJson['o3'],
      so2: airQualityJson['so2'],
      pm25: airQualityJson['pm2_5'],
    );
  }

  double _calculatePercentage(double value, double max) {
    double ratio = value / max;
    double percentage = (1 - ratio) * 100;
    print('Value: $value, Max: $max, Percentage: $percentage');
    return percentage.clamp(0, 100);
  }

  double get airQualityPercentage {
    double coPercent = _calculatePercentage(co, AirQualityStandards.maxCO);
    double no2Percent = _calculatePercentage(no2, AirQualityStandards.maxNO2);
    double o3Percent = _calculatePercentage(o3, AirQualityStandards.maxO3);
    double so2Percent = _calculatePercentage(so2, AirQualityStandards.maxSO2);
    double pm25Percent =
        _calculatePercentage(pm25, AirQualityStandards.maxPM25);

    return (coPercent + no2Percent + o3Percent + so2Percent + pm25Percent) / 5;
  }
}

class AirQualityService {
  Future<AirQuality> getAirQualityData(String place) async {
    try {
      final queryParameters = {
        'key': '1b144e732ab147a2ae311000242701',
        'q': place,
        'aqi': "yes",
      };
      final uri =
          Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      print('Response JSON: ${response.body}');
      if (response.statusCode == 200) {
        return AirQuality.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Can not get weather");
      }
    } catch (e) {
      rethrow;
    }
  }
}
