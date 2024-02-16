import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weatherModels.dart';

class WeatherService{
  static const Base_URL="http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather>getWeather(String cityName)async{
    final response=await http.get(Uri.parse('$Base_URL?q=$cityName&appid=$apiKey&units=metric'));
        if (response.statusCode==200){
          return Weather.fromJson(jsonDecode(response.body));
        }else{
          throw Exception('failed');
        }
  }

  //get permission from user
  Future<String>getCurrentCity()async{
    LocationPermission permission=await Geolocator.checkPermission();
    if (permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
    }

    //convert location into city name
    Position position =await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

    //convert city into place marks
    List<Placemark>placemarks=await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract city name from placemark
    String? city=placemarks[0].locality;
    return city??"";
  }
}