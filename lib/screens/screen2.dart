import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../components/custom_text.dart';

class Screen2 extends StatefulWidget {
  final String fullName;
  final String selectedCity;

  const Screen2({
    super.key,
    required this.fullName,
    required this.selectedCity,
  });

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  late String currentCity;

  @override
  void initState() {
    super.initState();
    currentCity = widget.selectedCity;
    context.read<WeatherBloc>().add(FetchWeatherEvent(currentCity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildCityCard(),
                  const SizedBox(height: 20),
                  _buildHorizontalWeatherListCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (state is WeathersLoaded) {
          final weatherData = state.response.list?.isNotEmpty == true ? state.response.list![0] : null;

          if (weatherData == null) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }

          final weatherCondition = weatherData.weather?.first.main?.toLowerCase() ?? "";

          String backgroundImage;
          if (weatherCondition.contains("rain")) {
            backgroundImage = 'assets/rainy.jpg';
          } else if (weatherCondition.contains("cloud")) {
            backgroundImage = 'assets/cloudy.jpg';
          } else {
            backgroundImage = 'assets/background.jpg';
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeathersLoaded) {
          final weatherData = state.response.list?.isNotEmpty == true ? state.response.list![0] : null;

          if (weatherData == null) {
            return const Center(
              child: CustomText(
                text: "No weather data available",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          final tempCelsius = (weatherData.main?.temp ?? 0) - 273.15;
          final description = weatherData.weather?.first.description ?? "N/A";
          final icon = weatherData.weather?.first.icon ?? "";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    CustomText(
                      text: currentCity,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.refresh, color: Colors.white, size: 24),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: _formatDate(weatherData.dtTxt ?? ""),
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomText(
                  text: "Selamat Sore, ${widget.fullName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: tempCelsius.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const CustomText(
                      text: "°C",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Image.network(
                          "https://openweathermap.org/img/wn/$icon@4x.png",
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red, size: 80);
                          },
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCityCard() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeathersLoaded) {
          final weatherData = state.response.list?.isNotEmpty == true ? state.response.list![0] : null;

          if (weatherData == null) {
            return const Center(
              child: CustomText(
                text: "No weather data available",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          final humidity = weatherData.main?.humidity ?? 0;
          final pressure = weatherData.main?.pressure ?? 0;
          final cloudiness = weatherData.clouds?.all ?? 0;
          final windSpeed = weatherData.wind?.speed ?? 0.0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfoIcon(Icons.water_drop, "$humidity%", "Humidity"),
                  _buildWeatherInfoIcon(Icons.speed, "$pressure hPa", "Pressure"),
                  _buildWeatherInfoIcon(Icons.cloud, "$cloudiness%", "Cloudiness"),
                  _buildWeatherInfoIcon(Icons.air, "${windSpeed.toStringAsFixed(2)} m/s", "Wind"),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWeatherInfoIcon(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomText(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHorizontalWeatherListCard() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeathersLoaded) {
          final weatherList = state.response.list ?? [];
          if (weatherList.isEmpty) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 220, // Increased height to fit additional data
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final weather = weatherList[index];
                    return _buildDetailedWeatherItem(weather);
                  },
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDetailedWeatherItem(dynamic weather) {
    final time = weather.dtTxt?.substring(11, 16) ?? "N/A";
    final tempCelsius = (weather.main?.temp ?? 0) - 273.15;
    final description = weather.weather?.first.description ?? "N/A";
    final icon = weather.weather?.first.icon ?? "";
    final humidity = weather.main?.humidity ?? 0;
    final pressure = weather.main?.pressure ?? 0;
    final windSpeed = weather.wind?.speed ?? 0.0;

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: time,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Image.network(
            "https://openweathermap.org/img/wn/$icon@2x.png",
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "${tempCelsius.toStringAsFixed(1)}°C",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          CustomText(
            text: description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              CustomText(
                text: "$humidity%",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.speed, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              CustomText(
                text: "$pressure hPa",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.air, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              CustomText(
                text: "${windSpeed.toStringAsFixed(1)} m/s",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    if (dateTime.isEmpty) return "N/A";
    final date = DateTime.tryParse(dateTime);
    if (date == null) return "N/A";
    return "${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}";
  }

  String _getDayName(int weekday) {
    const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}
