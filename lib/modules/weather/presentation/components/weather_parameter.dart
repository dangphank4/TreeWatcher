import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherParameter extends StatelessWidget{

  final String date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final double windSpeed;
  final double windDirection;
  final double precipitation;
  final double uvIndex;

  const WeatherParameter({super.key, required this.date, required this.weatherCode, required this.tempMax, required this.tempMin, required this.windSpeed, required this.windDirection, required this.precipitation, required this.uvIndex,});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.2,1]
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16)),
              Icon(getWeatherIcon(weatherCode),
                  size: 40, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Max: ${tempMax}°C, Min: ${tempMin}°C",
            style: const TextStyle(
                color: Colors.white70, fontSize: 14),
          ),
          Text(
            "Wind: ${windSpeed} km/h, ${windDirection}°",
            style: const TextStyle(
                color: Colors.white70, fontSize: 14),
          ),
          Text(
            "Precipitation: ${precipitation} mm",
            style: const TextStyle(
                color: Colors.white70, fontSize: 14),
          ),
          Text(
            "UV Index: ${uvIndex}",
            style: const TextStyle(
                color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

}