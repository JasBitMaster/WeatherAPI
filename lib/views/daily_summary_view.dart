import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/weather.dart';
import '../utils/temperature_convert.dart';

class DailySummaryView extends StatelessWidget {
  final Weather weather;

  DailySummaryView({Key key, @required this.weather})
      : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayOfWeek =
        toBeginningOfSentenceCase(DateFormat('EEE').format(this.weather.date));

    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(dayOfWeek ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
              Text(
                  "${TemperatureConvert.kelvinToFahrenheit(this.weather.temp).round().toString()}°",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ]),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Container(
                    alignment: Alignment.center,
                    child: _mapWeatherConditionToImage(this.weather.condition)))
          ],
        ));
  }

  Widget _mapWeatherConditionToImage(WeatherCondition condition) {
    IconData icon;
    switch (condition) {
      case WeatherCondition.thunderstorm:
        icon = MdiIcons.weatherLightning;
        break;
      case WeatherCondition.heavyCloud:
        icon = MdiIcons.weatherCloudy;
        break;
      case WeatherCondition.lightCloud:
        icon = MdiIcons.weatherPartlyCloudy;
        break;
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        icon = MdiIcons.weatherPartlyRainy;
        break;
      case WeatherCondition.clear:
        icon = MdiIcons.weatherSunny;
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
        size: 44,
        color: Colors.white,
      ),
    );
  }
}
