import 'package:cuaca_project/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/weather_service.dart';

part 'weather_event.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;

  WeatherBloc(this.weatherService) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<FetchCitiesEvent>(_onFetchCities);
    on<FetchProvincesEvent>(_onFetchProvinces);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final response = await weatherService.fetchWeathers(event.city);
      emit(WeathersLoaded(response: response));
    } catch (e) {
      emit(WeatherError(message: "Gagal memuat cuaca: ${e.toString()}"));
    }
  }

  Future<void> _onFetchCities(
    FetchCitiesEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final cities = await weatherService.fetchCities(event.province);
      if (cities.isEmpty) {
        emit(WeatherError(message: "Tidak ada kota yang tersedia."));
      } else {
        emit(CitiesLoaded(cities: cities));
      }
    } catch (e) {
      emit(WeatherError(message: "Gagal memuat kota: ${e.toString()}"));
    }
  }

  Future<void> _onFetchProvinces(
    FetchProvincesEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final provinces = await weatherService.fetchProvinces(query: event.query);
      if (provinces.isEmpty) {
        emit(WeatherError(message: "Tidak ada provinsi yang tersedia."));
      } else {
        emit(ProvincesLoaded(provinces: provinces));
      }
    } catch (e) {
      emit(WeatherError(message: "Gagal memuat provinsi: ${e.toString()}"));
    }
  }
}
