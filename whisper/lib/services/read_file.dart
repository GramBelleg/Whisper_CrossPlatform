import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/shared_preferences.dart';

Future<String> generatePresignedUrl(String blobName) async {
  final String apiUrl = 'http://$ip:5000/api/media/read';
  String? token = await getToken();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'blobName': blobName}),
  );

  if (response.statusCode == 200) {
    // Parse the response to extract the presigned URL
    final data = jsonDecode(response.body);
    return data[
        'presignedUrl']; // Ensure this matches the response from your backend
  } else {
    // Handle error
    print('Errors: ${response.statusCode}, ${response.body}');
    return '';
  }
}
