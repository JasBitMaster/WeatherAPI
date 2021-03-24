import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/weather.dart';

class WeatherSummary extends StatelessWidget {
  final WeatherCondition condition;
  final double temp;
  final double feelsLike;
  final bool isdayTime;

  WeatherSummary(
      {Key key,
      @required this.condition,
      @required this.temp,
      @required this.feelsLike,
      @required this.isdayTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(
          children: [
            Text(
              '${_formatTemperature(this.temp)}°ᶠ',
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Feels like ${_formatTemperature(this.feelsLike)}°ᶠ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        _mapWeatherConditionToImage(this.condition, this.isdayTime),
      ]),
    );
  }

  String _formatTemperature(double t) {
    var temp = (t == null ? '' : t.round().toString());
    return temp;
  }

  Widget _mapWeatherConditionToImage(
      WeatherCondition condition, bool isDayTime) {
    IconData icon;
    switch (condition) {
      case WeatherCondition.thunderstorm:
        icon = MdiIcons.weatherLightning;
        break;
      case WeatherCondition.heavyCloud:
        icon = MdiIcons.weatherCloudy;
        break;
      case WeatherCondition.lightCloud:
        icon = isDayTime
            ? MdiIcons.weatherPartlyCloudy
            : MdiIcons.weatherNightPartlyCloudy;
        break;
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        icon = MdiIcons.weatherPartlyRainy;
        break;
      case WeatherCondition.clear:
        icon = isDayTime ? MdiIcons.weatherSunny : MdiIcons.weatherNight;
        break;
      case WeatherCondition.fog:
        icon = MdiIcons.weatherFog;
        break;
      case WeatherCondition.snow:
        icon = MdiIcons.weatherSnowy;
        break;
      case WeatherCondition.rain:
        icon = MdiIcons.weatherRainy;
        break;
      case WeatherCondition.atmosphere:
        icon = MdiIcons.weatherCloudyAlert;
        break;
      case WeatherCondition.tornado:
        icon = MdiIcons.weatherTornado;
        break;
      default:
        icon = MdiIcons.weatherPartlyCloudy;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Icon(
        icon,
        color: Colors.white,
        size: 80,
      ),
    );
  }
}
