import '../api/weather_api.dart';
import '../models/forecast.dart';
import '../models/location.dart';

class ForecastService {
  final WeatherApi weatherApi;

  ForecastService(this.weatherApi);

  Future<Forecast> getWeather({String city, Location location}) async {
    location ??= await weatherApi.getLocation(city);

    return weatherApi.getWeather(location, city);
  }
}
