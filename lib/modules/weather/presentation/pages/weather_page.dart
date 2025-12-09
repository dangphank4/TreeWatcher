import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/models/weather_model.dart';
import 'package:flutter_api/modules/weather/data/datasource/weather_api.dart';
import 'package:flutter_api/modules/weather/data/repositories/weather_repository.dart';
import 'package:flutter_api/modules/weather/presentation/components/weather_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final repository = WeatherRepository(api: WeatherApi());

  List<WeatherModel>? forecast;
  bool loading = true;
  bool error = false;
  WeatherModel? forecast_today;

  double latValue = 0;
  double lonValue = 0;
  Map<String, double>? result;

  String? cityName = "";
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    loadSavedPosition();
  }

  Future<void> loadPosition(String city) async {
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tên thành phố/tỉnh")),
      );
      return;
    }
    result = await repository.getLatLon(city: city);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy vị trí này")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latValue = result!["lat"]!;
      lonValue = result!["lon"]!;
      cityName = city;
    });
    await prefs.setDouble("lat", latValue);
    await prefs.setDouble("lon", lonValue);
    await prefs.setString("cityName", cityName!);
    await loadForecast();
  }

  Future<void> loadForecast() async {
    setState(() {
      loading = true;
      error = false;
    });
    try {
      final result = await repository.getDailyForecast(
        lat: latValue,
        lon: lonValue,
      );
      setState(() {
        forecast = result;
        forecast_today = forecast?.first;
        forecast?.removeAt(0);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  IconData getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 61:
      case 63:
      case 65:
        return Icons.umbrella;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> loadSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();

    final lat = prefs.getDouble("lat");
    final lon = prefs.getDouble("lon");
    final savedCity = prefs.getString("cityName");

    if (lat != null && lon != null && savedCity != null) {
      setState(() {
        latValue = lat;
        lonValue = lon;
        cityName = savedCity;
      });

      await loadForecast();
    } else {
      // Chưa có vị trí → mặc định load vị trí 0,0 (hoặc VN)
      loadForecast();
    }
  }

  Color? getBackgroundColor(double? temp) {
    if (temp == null) return null;
    if (temp <= 0) {
      return Colors.blueGrey; // lạnh đậm
    } else if (temp <= 10) {
      return Colors.lightBlueAccent.shade100; // lạnh nhẹ
    } else if (temp <= 20) {
      return Colors.blue.shade200; // mát
    } else if (temp <= 28) {
      return Colors.orangeAccent.shade100; // ấm nhẹ
    } else if (temp <= 35) {
      return Colors.orangeAccent.shade200; // nóng
    } else {
      return Colors.deepOrangeAccent.shade100; // cực nóng
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor:
          getBackgroundColor(forecast_today?.tempMax) ?? Colors.blueGrey,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
          child: Text(
            "Weather",
            style: Styles.h1.regular.copyWith(color: Colors.black),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error
          ? const Center(child: Text("Không thể tải dữ liệu thời tiết"))
          : Container(
              // 🎨 NỀN ĐẸP
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ?getBackgroundColor(
                      (forecast_today?.tempMax ?? 20),
                    )?.withValues(alpha: 0.9), // màu chính theo nhiệt độ
                    Colors.white, // fade về trắng
                    ?getBackgroundColor(
                      (forecast_today?.tempMax ?? 20),
                    )?.withValues(alpha: 0.4), // màu nhạt dần

                    Colors.white, // fade về trắng
                  ],
                  stops: [0, 0.3, 0.55, 0.8],
                ),
              ),

              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Ô tìm kiếm đẹp hơn
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                fillColor: Colors.white.withValues(alpha: 0.85),
                                filled: true,
                                labelText: "Nhập thành phố/tỉnh",
                                labelStyle: TextStyle(color: Colors.black54),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.8,
                              ),
                              foregroundColor: Colors.black87,
                              shape: CircleBorder(),
                              elevation: 4,
                            ),
                            onPressed: () {
                              final city = searchController.text.trim();
                              loadPosition(city);
                            },
                            child: Icon(Icons.search_rounded, size: 28),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    buildTodayWeather(),

                    const SizedBox(height: 16),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: forecast!.length,
                      itemBuilder: (context, index) {
                        final day = forecast![index];
                        return Card(
                          color: Colors.white..withValues(alpha: 0.9),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: WeatherParameter(
                            date: day.date,
                            weatherCode: day.weatherCode,
                            tempMax: day.tempMax,
                            tempMin: day.tempMin,
                            windSpeed: day.windSpeed,
                            windDirection: day.windDirection,
                            precipitation: day.precipitation,
                            uvIndex: day.uvIndex,
                          ),
                        );
                      },
                    ),

                    80.verticalSpace,
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTodayWeather() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade50,
            Colors.blueAccent.shade100,
          ],
          stops: [0, 0.7, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON WEATHER
          Icon(
            getWeatherIcon(forecast_today?.weatherCode ?? 0),
            size: 72,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 20),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CITY NAME
                Text(
                  cityName ?? "Địa điểm",
                  style: Styles.h1.smb.copyWith(color: Colors.black45),
                ),
                SizedBox(height: 6),

                // TEMPERATURE LARGE
                Text(
                  "${forecast_today?.tempMax.toStringAsFixed(0)}°",
                  style: TextStyle(
                    fontSize: 53,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(height: 4),

                // EXTRA INFO — like Google Weather
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.thermostat,
                          size: 18,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${forecast_today?.tempMin}° / ${forecast_today?.tempMax}°",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.water_drop, size: 18, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          "${forecast_today?.precipitation} mm",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.cloud,
                          size: 18,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${forecast_today?.windSpeed} km/h / ${forecast_today?.windDirection}°",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.light_mode,
                          size: 18,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${forecast_today?.uvIndex}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
