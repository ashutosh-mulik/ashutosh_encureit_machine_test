import 'package:ashutosh_encureit_machine_test/configs/api.dart';
import 'package:dio/dio.dart';

class LocationUpdateService {
  final Dio _dio = Dio();

  Future<String> updateLocation({required double latitude, required double longitude}) async {
    try {
      var data = FormData.fromMap({
        "longitude": longitude,
        "latitude": latitude,
      });
      var response = await _dio.post(API.location, data: data);
      return response.data['message'];
    } catch (e) {
      rethrow;
    }
  }
}
