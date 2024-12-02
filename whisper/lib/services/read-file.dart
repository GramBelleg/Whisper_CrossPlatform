import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

Future<String> generatePresignedUrl(String blobName) async {
  final String apiUrl = 'http://192.168.1.110:5000/api/media/read';
  String? token = await GetToken();

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
    print("retrieve url photo successfly${data}");
    return data[
        'presignedUrl']; // Ensure this matches the response from your backend
  } else {
    // Handle error
    print('Error: ${response.statusCode}, ${response.body}');
    return '';
  }
}
