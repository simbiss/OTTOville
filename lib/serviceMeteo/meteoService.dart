import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meteoModel.dart';

class WeatherService {
  Future<Weather> getWeatherData(String place) async {
    try {
      final queryParameters = {
        'key': '1b144e732ab147a2ae311000242701',
        'q': place,
      };
      final uri =
          Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Can not get weather");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class UpComingWeatherService {
  Future<UpComingWeather> getGivenDayWeatherDate(
      String place, String date) async {
    try {
      final queryParameters = {
        'key': '1b144e732ab147a2ae311000242701',
        'q': place,
        'dt': date,
      };
      final uri =
          Uri.http('api.weatherapi.com', '/v1/forecast.json', queryParameters);
      final response = await http.get(uri);
      print('Response JSON: ${response.body}');
      if (response.statusCode == 200) {
        return UpComingWeather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Can not get weather ... ${uri}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
