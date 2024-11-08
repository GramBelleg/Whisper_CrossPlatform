import 'package:dio/dio.dart';
import '../utils/visibility_utils.dart';
import '../constants/ip-for-services.dart';

class VisibilityService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getVisibilitySettings() async {
    final response = await _dio.get("http://$ip:5000/api/user/info");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to Load Visibility settings");
    }
  }

  Future<void> updateVisibilitySetting(String key, dynamic value) async {
    String endpoint = "";

    switch (key) {
      case 'profilePicture':
        endpoint = "http://$ip:5000/api/user/pfp/privacy";
        break;
      case 'lastSeen':
        endpoint = "http://$ip:5000/api/user/lastSeen/privacy";
        break;
      case 'stories':
        endpoint = "http://$ip:5000/api/user/story/privacy";
        break;
      case 'readReceipts':
        // Exists in the post request down below
        break;
      case 'addMeToGroups':
        // TODO: call nour to implement this endpoint
        break;

      default:
        throw Exception("This is not a valid visibility key");
    }

    if (key == "readReceipts") {
      final response = _dio.post("http://$ip:5000/api/user/readReceipts",
          data: {"readReceipts": value});

      // TODO: handle if there was an error in post request ?
    } else {
      final response = await _dio.put(
        endpoint,
        data: {'privacy': value},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update visibility setting of key $key');
      }
    }
  }
}
