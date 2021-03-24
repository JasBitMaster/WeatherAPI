import 'dart:core';

import 'package:flutter/widgets.dart';

import '../api/open_weather_map_weather_api.dart';
import '../models/forecast.dart';
import '../models/location.dart';
import '../models/weather.dart';
import '../services/forecast_service.dart';
import '../utils/strings.dart';
import '../utils/temperature_convert.dart';

class ForecastViewModel with ChangeNotifier {
  bool isRequestPending = false;
  bool isWeatherLoaded = false;
  bool isRequestError = false;

  WeatherCondition _condition;
  String _description;
  double _minTemp;
  double _maxTemp;
  double _temp;
  double _feelsLike;
  int _locationId;
  DateTime _lastUpdated;
  String _city;
  double _latitude;
  double _longitude;
  List<Weather> _daily;
  bool _isDayTime;

  WeatherCondition get condition => _condition;

  String get description => _description;

  double get minTemp => _minTemp;

  double get maxTemp => _maxTemp;

  double get temp => _temp;

  double get feelsLike => _feelsLike;

  int get locationId => _locationId;

  DateTime get lastUpdated => _lastUpdated;

  String get city => _city;

  double get longitude => _longitude;

  double get latitude => _latitude;

  bool get isDaytime => _isDayTime;

  List<Weather> get daily => _daily;

  ForecastService forecastService;

  ForecastViewModel() {
    forecastService = ForecastService(OpenWeatherMapWeatherApi());
  }

  Future<Forecast> getLatestWeatherFromLocation(Location location) async {
    setRequestPendingState(true);
    this.isRequestError = false;

    Forecast latest;
    try {
      await Future.delayed(Duration(seconds: 1), () => {});

      latest = await forecastService
          .getWeather(location: location, city: 'Your location')
          .catchError((onError) {
        return this.isRequestError = true;
      });
    } catch (e) {
      this.isRequestError = true;
    }

    this.isWeatherLoaded = true;
    updateModel(latest, '');
    setRequestPendingState(false);
    notifyListeners();
    return latest;
  }

  Future<Forecast> getLatestWeather(String city) async {
    setRequestPendingState(true);
    this.isRequestError = false;

    Forecast latest;
    try {
      await Future.delayed(Duration(seconds: 1), () => {});

      latest =
          await forecastService.getWeather(city: city).catchError((onError) {
        print('forecastService.getWeather error: $onError');
        return this.isRequestError = true;
      });
    } catch (e) {
      print('Forecast error: $e');
      this.isRequestError = true;
    }

    this.isWeatherLoaded = true;
    updateModel(latest, city);
    setRequestPendingState(false);
    notifyListeners();
    return latest;
  }

  void setRequestPendingState(bool isPending) {
    this.isRequestPending = isPending;
    notifyListeners();
  }

  void updateModel(Forecast forecast, String city) {
    if (isRequestError) return;

    _condition = forecast.current.condition;
    _city = Strings.toTitleCase(forecast.city);
    _description = Strings.toTitleCase(forecast.current.description);
    _lastUpdated = forecast.lastUpdated;
    _temp = TemperatureConvert.kelvinToFahrenheit(forecast.current.temp);
    _feelsLike =
        TemperatureConvert.kelvinToFahrenheit(forecast.current.feelLikeTemp);
    _longitude = forecast.longitude;
    _latitude = forecast.latitude;
    _daily = forecast.daily;
    _isDayTime = forecast.isDayTime;
  }
}
