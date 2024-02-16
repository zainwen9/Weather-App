import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/Services/weatherServices.dart';
import 'package:weather/models/weatherModels.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  //api key
  final _weatherservice=WeatherService('ee16ea002e8f6417b3a382a9f4216d9b');
  Weather ? _weather;

  //fetch weather
 _fetchWeather()async {
   //get city name
   String cityName = await _weatherservice.getCurrentCity();

   //get weather for city
   try {
     final weather = await _weatherservice.getWeather(cityName);
     setState(() {
       _weather = weather;
     });
   }
   catch(e){
     print(e);
   }
 }


  @override void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  //weather animation

  String getWeatherAnimation(String? mainCondition){
   if(mainCondition==null)return 'assets/thunder.json'; //default
    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
         return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/thunder.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.locationArrow,color: Colors.grey,size: 25,),),
        SizedBox(height: 20,),
            Text(_weather?.cityName??'loading city...',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25,color: Colors.grey),),
            SizedBox(height: 70,),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            SizedBox(height: 70,),
            Text('${_weather?.temprature.round()}°C',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25,color: Colors.grey),),
            SizedBox(height: 20,),
            Text(_weather?.mainCondition ?? "",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25,color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}
