import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final double windSpeed;
  final double windDirection;
  final double precipitation;
  //final double humidity;
  final double uvIndex;

  const WeatherModel({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.precipitation,
   // required this.humidity,
    required this.uvIndex,
  });

  /// Tạo WeatherModel từ JSON Map
  factory WeatherModel.fromJson(Map<String, dynamic> daily, int index) {
    return WeatherModel(
      date: daily['time'][index],
      tempMax: (daily['temperature_2m_max'][index] as num).toDouble(),
      tempMin: (daily['temperature_2m_min'][index] as num).toDouble(),
      weatherCode: (daily['weathercode'][index] as num).toInt(),
      windSpeed: (daily['windspeed_10m_max'][index] as num).toDouble(),
      windDirection: (daily['winddirection_10m_dominant'][index] as num).toDouble(),
      precipitation: (daily['precipitation_sum'][index] as num).toDouble(),
     // humidity: (daily['humidity_2m_max'][index] as num).toDouble(),
      uvIndex: (daily['uv_index_max'][index] as num).toDouble(),
    );
  }

  /// Chuyển WeatherModel sang JSON
  Map<String, dynamic> toJson() => {
    'date': date,
    'temperature_max': tempMax,
    'temperature_min': tempMin,
    'weatherCode': weatherCode,
    'windSpeed': windSpeed,
    'windDirection': windDirection,
    'precipitation': precipitation,
   // 'humidity': humidity,
    'uvIndex': uvIndex,
  };

  /// Copy với thay đổi các thuộc tính
  WeatherModel copyWith({
    String? date,
    double? tempMax,
    double? tempMin,
    int? weatherCode,
    double? windSpeed,
    double? windDirection,
    double? precipitation,
    //double? humidity,
    double? uvIndex,
  }) {
    return WeatherModel(
      date: date ?? this.date,
      tempMax: tempMax ?? this.tempMax,
      tempMin: tempMin ?? this.tempMin,
      weatherCode: weatherCode ?? this.weatherCode,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      precipitation: precipitation ?? this.precipitation,
      //humidity: humidity ?? this.humidity,
      uvIndex: uvIndex ?? this.uvIndex,
    );
  }

  @override
  List<Object?> get props => [
    date,
    tempMax,
    tempMin,
    weatherCode,
    windSpeed,
    windDirection,
    precipitation,
   // humidity,
    uvIndex,
  ];

  @override
  String toString() {
    return 'WeatherModel(date: $date, tempMax: $tempMax, tempMin: $tempMin, '
        'weatherCode: $weatherCode, windSpeed: $windSpeed, windDirection: $windDirection, '
        'precipitation: $precipitation, uvIndex: $uvIndex)';
  }
}
