import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../services/location_service.dart';
import '../viewModels/forecast_view_model.dart';

class LocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(MdiIcons.mapMarker),
      onPressed: () async {
        final location = await LocationService.getCurrentLocation();
        if (location == null) return;

        final forecast = Provider.of<ForecastViewModel>(context, listen: false);
        forecast.getLatestWeatherFromLocation(location);
      },
    );
  }
}
