import 'package:flutter_api/core/models/weather_model.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/weather/data/datasource/weather_api.dart';

class WeatherRepository {
  final WeatherApi api;

  WeatherRepository({required this.api});


  Future<List<WeatherModel>> getDailyForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final data = await api.fetchDailyForecast(lat: lat, lon: lon);
      Utils.debugLog('data: $data');
      final daily = data['daily'] as Map<String, dynamic>;
      List<WeatherModel> forecast = [];

      Utils.debugLog('daily: $daily');
      for (int i = 0; i < (daily['time']).length; i++) {
        forecast.add(WeatherModel.fromJson(daily, i));
      }
      Utils.debugLog("forecast: $forecast");
      return forecast;

    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, double>?> getLatLon({required String city}) async {
    try {
      final result = await api.getLatLon(city);

      if (result == null) return null;

      return {
        "lat": result["latitude"] as double,
        "lon": result["longitude"] as double,
      };
    } catch (e) {
      rethrow;
    }
  }

}
