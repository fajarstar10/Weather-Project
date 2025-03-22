import 'dart:async';

import 'package:cuaca_project/models/weather_model.dart';
import 'package:dio/dio.dart';

class WeatherService {
  final Dio dio;

  WeatherService(this.dio);

  Future<WeatherResponse> fetchWeathers(String city) async {
    try {
      final response = await dio.get(
        '/forecast',
        queryParameters: {
          'q': city,
          'cnt': 10,
          'lang': 'id'
        },
      );

      if (response.statusCode == 200) {
        // Parse the response.data into a WeatherResponse object
        return WeatherResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error fetching weather data: $error");
    }
  }

  Future<List<String>> fetchProvinces({String? query}) async {
    final List<String> provinces = [
      "Jakarta",
      "West Java",
      "Central Java",
      "East Java",
      "Yogyakarta",
    ];

    if (query != null && query.isNotEmpty) {
      return provinces.where((province) => province.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return provinces;
  }

  Future<List<String>> fetchCities(String provinceId) async {
    final Map<String, List<String>> citiesByProvince = {
      "Jakarta": ["Jakarta Pusat", "Jakarta Barat", "Jakarta Timur", "Jakarta Utara"],
      "West Java": ["Bandung", "Bekasi", "Bogor", "Cimahi"],
      "Central Java": ["Semarang", "Solo", "Magelang", "Purwokerto"],
      "East Java": ["Surabaya", "Malang", "Kediri", "Jember"],
      "Yogyakarta": ["Yogyakarta City", "Sleman", "Bantul", "Gunungkidul"],
    };

    final cities = citiesByProvince[provinceId];
    if (cities != null) {
      return cities;
    } else {
      throw Exception("No cities found for the province: $provinceId");
    }
  }

  String _handleDioError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Koneksi ke server timeout.";
        case DioExceptionType.receiveTimeout:
          return "Waktu untuk menerima data habis.";
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 404) {
            return "Data tidak ditemukan.";
          } else if (statusCode == 401) {
            return "API Key tidak valid.";
          }
          return "Kesalahan server dengan kode $statusCode.";
        case DioExceptionType.badCertificate:
          return "Sertifikat server tidak valid.";
        case DioExceptionType.cancel:
          return "Permintaan dibatalkan.";
        case DioExceptionType.unknown:
        case DioExceptionType.connectionError:
          return "Gagal terhubung ke server. Periksa koneksi internet Anda.";
        default:
          return "Terjadi kesalahan yang tidak diketahui.";
      }
    }
    return "Terjadi kesalahan yang tidak diketahui.";
  }
}
