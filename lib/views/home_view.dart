import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../viewModels/city_entry_view_model.dart';
import '../viewModels/forecast_view_model.dart';
import 'city_entry_view.dart';
import 'daily_summary_view.dart';
import 'gradient_container.dart';
import 'last_update_view.dart';
import 'location_view.dart';
import 'weather_description_view.dart';
import 'weather_summary.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ForecastViewModel>(
      builder: (context, model, child) => Scaffold(
        body: _buildGradientContainer(
            model.condition, model.isDaytime, buildHomeView(context)),
      ),
    );
  }

  Widget buildHomeView(BuildContext context) {
    return Consumer<ForecastViewModel>(
      builder: (context, weatherViewModel, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            onRefresh: () => refreshWeather(weatherViewModel, context),
            child: ListView(
              children: <Widget>[
                CityEntryView(),
                _weatherVisual(weatherViewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBusyIndicator() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      SizedBox(height: 20),
      Text('Please Wait...',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ))
    ]);
  }

  Widget buildDailySummary(List<Weather> dailyForecast) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dailyForecast
            .map((item) => new DailySummaryView(
                  weather: item,
                ))
            .toList());
  }

  Widget _weatherVisual(ForecastViewModel weatherViewModel) {
    if (weatherViewModel.isRequestPending) {
      return buildBusyIndicator();
    }
    if (weatherViewModel.isRequestError) {
      return Center(
        child: Text(
          'Oops...something went wrong',
          style: TextStyle(fontSize: 21, color: Colors.white),
        ),
      );
    }

    if (weatherViewModel.isWeatherLoaded) {
      return Column(
        children: [
          LocationView(
            longitude: weatherViewModel.longitude,
            latitude: weatherViewModel.latitude,
            city: weatherViewModel.city,
          ),
          SizedBox(height: 50),
          WeatherSummary(
              condition: weatherViewModel.condition,
              temp: weatherViewModel.temp,
              feelsLike: weatherViewModel.feelsLike,
              isdayTime: weatherViewModel.isDaytime),
          SizedBox(height: 20),
          WeatherDescriptionView(
              weatherDescription: weatherViewModel.description),
          SizedBox(height: 140),
          buildDailySummary(weatherViewModel.daily),
          LastUpdatedView(lastUpdatedOn: weatherViewModel.lastUpdated),
        ],
      );
    }

    return Center(
      child: Text(
        'Enter a city to get started.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Future<void> refreshWeather(
      ForecastViewModel weatherVM, BuildContext context) {
    final city = Provider.of<CityEntryViewModel>(context, listen: false).city;
    return weatherVM.getLatestWeather(city);
  }

  GradientContainer _buildGradientContainer(
      WeatherCondition condition, bool isDayTime, Widget child) {
    GradientContainer container;

    // if night time then just default to a blue/grey
    if (isDayTime != null && !isDayTime)
      container = GradientContainer(color: Colors.blueGrey, child: child);
    else {
      switch (condition) {
        case WeatherCondition.clear:
        case WeatherCondition.lightCloud:
          container = GradientContainer(color: Colors.yellow, child: child);
          break;
        case WeatherCondition.fog:
        case WeatherCondition.atmosphere:
        case WeatherCondition.rain:
        case WeatherCondition.drizzle:
        case WeatherCondition.mist:
        case WeatherCondition.heavyCloud:
          container = GradientContainer(color: Colors.indigo, child: child);
          break;
        case WeatherCondition.snow:
          container = GradientContainer(color: Colors.lightBlue, child: child);
          break;
        case WeatherCondition.thunderstorm:
        case WeatherCondition.tornado:
          container = GradientContainer(color: Colors.deepPurple, child: child);
          break;
        default:
          container = GradientContainer(color: Colors.lightBlue, child: child);
      }
    }

    return container;
  }
}
