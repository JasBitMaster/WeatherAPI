import '../utils/strings.dart';

import 'weather.dart';

class Forecast {
  final DateTime lastUpdated;
  final double longitude;
  final double latitude;
  final List<Weather> daily;
  final Weather current;
  final bool isDayTime;
  String city;

  Forecast({
    this.lastUpdated,
    this.longitude,
    this.latitude,
    this.daily: const [],
    this.current,
    this.city,
    this.isDayTime,
  });

  static Forecast fromJson(Map<String, dynamic> json, {String city = ''}) {
    final weather = json['current']['weather'][0];
    final date = DateTime.fromMillisecondsSinceEpoch(
        json['current']['dt'] * 1000,
        isUtc: true);

    final sunrise = DateTime.fromMillisecondsSinceEpoch(
        json['current']['sunrise'] * 1000,
        isUtc: true);

    final sunset = DateTime.fromMillisecondsSinceEpoch(
        json['current']['sunset'] * 1000,
        isUtc: true);

    final isDay = date.isAfter(sunrise) && date.isBefore(sunset);

    // get the forecast for the next 3 days, excluding the current day
    final hasDaily = json['daily'] != null;
    final List<Weather> tempDaily = [];
    if (hasDaily) {
      tempDaily.addAll(json['daily']
          .map<Weather>((item) => Weather.fromDailyJson(item))
          .toList()
          .skip(1)
          .take(3));
    }

    final currentForecast = Weather(
      condition: Weather.mapStringToWeatherCondition(
          weather['main'], int.parse(json['current']['clouds'].toString())),
      // TODO add cloudiness, date, description, feelLikeTemp, temp
      cloudiness: json['current']['clouds'],
      date: DateTime.fromMillisecondsSinceEpoch(json['current']['dt'] * 1000,
          isUtc: true),
      description: weather['description'],
      feelLikeTemp: json['current']['feels_like'].toDouble(),
      temp: json['current']['temp'].toDouble(),
    );

    return Forecast(
      lastUpdated: DateTime.now(),
      current: currentForecast,
      city: Strings.toTitleCase(city),
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
      daily: tempDaily,
      isDayTime: isDay,
    );
  }
}
