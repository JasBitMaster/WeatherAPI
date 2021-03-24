class TemperatureConvert {
  // static double kelvinToCelsius(double kelvin) {
  //   return kelvin - 273;
  // }

  static double kelvinToFahrenheit(double kelvin) {
    return (kelvin - 273.15) * (9/5) + 32;
  }
}
