import 'package:get_it/get_it.dart';

import '../bloc/weather_bloc.dart';
import '../services/dio_client.dart';
import '../services/weather_service.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Register DioClient as a singleton
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Register WeatherService as a singleton and inject Dio
  getIt.registerLazySingleton<WeatherService>(() => WeatherService(getIt<DioClient>().dio));

  // Register WeatherBloc and inject WeatherService
  getIt.registerFactory<WeatherBloc>(() => WeatherBloc(getIt<WeatherService>()));
}
