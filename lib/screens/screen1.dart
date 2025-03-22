import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../components/custom_button.dart';
import '../components/custom_dropdown.dart';
import '../components/custom_text.dart';
import 'screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedProvince;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchProvincesEvent(query: null));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Input Data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Nama Lengkap",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan nama lengkap",
              ),
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: "Pilih Provinsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildProvinceDropdown(),
            const SizedBox(height: 16),
            const CustomText(
              text: "Pilih Kota",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCityDropdown(),
            const SizedBox(height: 32),
            CustomButton(
              label: "Proses",
              onPressed: () {
                _processInput(context);
              },
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvinceDropdown() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) => current is ProvincesLoaded || current is WeatherError,
      builder: (context, state) {
        if (state is ProvincesLoaded) {
          // Hilangkan item duplikat dari daftar provinces
          final provinces = state.provinces.toSet().toList();
          return CustomDropdown(
            hint: "Pilih Provinsi",
            items: provinces,
            selectedValue: provinces.contains(selectedProvince) ? selectedProvince : null,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedProvince = value;
                  selectedCity = null; // Reset selectedCity saat provinsi berubah
                });
                context.read<WeatherBloc>().add(FetchCitiesEvent(value));
              }
            },
          );
        } else if (state is WeatherError) {
          return _buildErrorState(
            message: state.message,
            retryAction: () => context.read<WeatherBloc>().add(FetchProvincesEvent(query: null)),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCityDropdown() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) => current is CitiesLoaded || current is WeatherError,
      builder: (context, state) {
        if (state is CitiesLoaded) {
          // Hilangkan item duplikat dari daftar cities
          final cities = state.cities.toSet().toList();
          return CustomDropdown(
            hint: "Pilih Kota",
            items: cities,
            selectedValue: cities.contains(selectedCity) ? selectedCity : null,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCity = value;
                });
              }
            },
          );
        } else if (state is WeatherError) {
          return _buildErrorState(
            message: state.message,
            retryAction: () => context.read<WeatherBloc>().add(FetchCitiesEvent(selectedProvince!)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState({required String message, required VoidCallback retryAction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: message,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 8),
        CustomButton(
          label: "Coba Lagi",
          onPressed: retryAction,
        ),
      ],
    );
  }

  void _processInput(BuildContext context) {
    if (_nameController.text.isEmpty || selectedProvince == null || selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua field."),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen2(
          fullName: _nameController.text,
          selectedCity: selectedCity!,
        ),
      ),
    );
  }
}
