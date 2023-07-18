import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const apiKey = "0192ef22b2b102579d4cbc21a898ef3e";

class WeatherDisplayData{
  Icon weatherIcon;
  double? currentTemperature;
  String? currentDescription;

  WeatherDisplayData({required this.weatherIcon, required this.currentTemperature,required this.currentDescription});
}


class WeatherData{
  WeatherData({required this.locationData});

  LocationHelper locationData;
  double? currentTemperature;
  int currentCondition = 0 ;
  String? currentDescription;
  String? city;


  Future<void> getCurrentTemperature() async{
    Response response = await get(Uri.parse("http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric&lang=tr"));

    if(response.statusCode == 200){
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try{
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        city = currentWeather['name'];
        currentDescription = currentWeather['weather'][0]['description'];
      }catch(e){
        print(e);
      }

    }
    else{
      print("API den değer gelmiyor!");
    }

  }

  WeatherDisplayData getWeatherDisplayData(){
    if(currentCondition < 600){
      //hava bulutlu
      return WeatherDisplayData(
        weatherIcon: Icon(
            FontAwesomeIcons.cloud,
            size: 30.0,
            color:Colors.black
        ),currentTemperature: currentTemperature,
        currentDescription :currentDescription,
      );
    }
    else{
      //hava iyi
      //gece gündüz kontrolü
      var now = new DateTime.now();
      if(now.hour >=19){
        return WeatherDisplayData(
            weatherIcon: Icon(
                FontAwesomeIcons.moon,
                size: 30.0,
                color:Colors.black
            ),currentTemperature: currentTemperature,currentDescription: currentDescription);
      }else{
        return WeatherDisplayData(
            weatherIcon: Icon(
                FontAwesomeIcons.sun,
                size: 30.0,
                color:Colors.black
            ),currentTemperature: currentTemperature,currentDescription: currentDescription);

      }
    }
  }


}

