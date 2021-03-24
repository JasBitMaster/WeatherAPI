import '../models/location.dart';
import '../models/forecast.dart';

abstract class WeatherApi {
  Future<Forecast> getWeather(Location location, String city);

  Future<Location> getLocation(String city);
}
