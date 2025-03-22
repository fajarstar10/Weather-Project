part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final String city;

  FetchWeatherEvent(this.city);
}

class FetchCitiesEvent extends WeatherEvent {
  final String province;

  FetchCitiesEvent(this.province);
}

class FetchProvincesEvent extends WeatherEvent {
  final String? query;

  FetchProvincesEvent({this.query});
}
