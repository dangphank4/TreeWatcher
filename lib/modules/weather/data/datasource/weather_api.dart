import 'dart:convert';

import 'package:flutter_api/core/utils/utils.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  final dioClient = Utils.dioClient;


  Future<Map<String, dynamic>> fetchDailyForecast({
    required double lat,
    required double lon,
  }) async {
    final url = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weathercode,windspeed_10m_max,winddirection_10m_dominant,precipitation_sum,uv_index_max&timezone=Asia/Ho_Chi_Minh";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to load forecast: ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getLatLon(String city) async {
    final url =
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);

      if (data["results"] == null || data["results"].isEmpty) {
        return null;
      }

      return data["results"][0];  // Trả về đúng object kết quả
    } catch (e) {
      rethrow;
    }
  }

}

