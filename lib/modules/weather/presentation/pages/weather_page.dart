import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_styles.dart';

class WeatherPage extends StatefulWidget{
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
        height: double.infinity,
        color: Colors.grey,
        child: Container(
          color: Colors.white,
          height: 30,
          width: 60,
          child: Text(
            'Weather',
            style: Styles.large.regular.copyWith(
              color: Colors.black26
            ),
          ),
        ),
      ),
    );
  }

}