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
      body: SafeArea(
        child: Container(
          color: Colors.red,
          height: 30,
          child: SizedBox(
            height: 30,
            child: Text('Weather'),
          ),
        ),
      ),
    );
  }

}