import 'package:weather/weather.dart';

// openweather KEY
final apiKey = 'c981cc5362ed9be6a6ac958a129aed21';

class WeatherModel {
  // insert api_key
  WeatherFactory wf = new WeatherFactory(apiKey);

  // current weather
  Future<dynamic> getCurrentWeatherWithCity(cityName) async {
    Weather w = await wf.currentWeatherByCityName(cityName);
    return w;
  }

  // five day forecast
  Future<dynamic> getFiveDayForecastWithCity(cityName) async {
    List<Weather> forecast = await wf.fiveDayForecastByCityName(cityName);
    return forecast;
  }
}
