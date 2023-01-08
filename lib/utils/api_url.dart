import 'package:project_flutter/api/api_key.dart';

String apiURL(var lat, var lon) {
  String url;

  url =
      //"https://api.openweathermap.org/data/3.0/onecall?q=Daejeon&exclude=minutely&appid=$apiKey&units=metric&lang=kr";
      //"https://api.openweathermap.org/data/3.0/onecall?lat={127.417}&lon={36.333}&exclude=minutely&appid=$apiKey&units=metric&lang=kr";
      //"https://api.openweathermap.org/data/3.0/onecall?lat=127.417&lon=36.333&exclude=minutely&appid=$apiKey&units=metric&lang=kr";
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&units=metric&lang=kr";
  // "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&unit=metric";

  return url;
}
