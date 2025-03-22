import '../models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class ProvincesLoaded extends WeatherState {
  final List<String> provinces;

  ProvincesLoaded({required this.provinces});
}

class WeathersLoaded extends WeatherState {
  final WeatherResponse response;

  WeathersLoaded({required this.response});
}

class CitiesLoaded extends WeatherState {
  final List<String> cities;

  CitiesLoaded({required this.cities});
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});
}
