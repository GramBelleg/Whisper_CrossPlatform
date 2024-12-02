import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:path/path.dart' as p;

Future<String> uploadFile(String filePath) async {
  print("Uploading file: $filePath");
  String fileExtension = p.extension(filePath);
  print("File extension: $fileExtension");
  final String apiUrl = 'http://$ip:5000/api/media/write';
  String? token = await GetToken();

  if (token == null) {
    throw Exception('Authorization token is missing');
  }

  try {
    // Step 1: Request presigned URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'fileExtension': fileExtension}),
    );

    if (response.statusCode == 200) {
      print("Response for presigned URL request: ${response.statusCode}");
      final data = jsonDecode(response.body);
      final String presignedUrl = data['presignedUrl'];
      final String blobName = data['blobName'];
      print("Presigned URL: $presignedUrl");

      // Step 2: Upload the file to the presigned URL
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();

      final uploadResponse = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          'Content-Type': 'application/octet-stream',
          'x-ms-blob-type': 'BlockBlob',
        },
        body: fileBytes,
      );

      // Check for a successful upload response
      if (uploadResponse.statusCode == 201 ||
          uploadResponse.statusCode == 200) {
        print("Upload successful!");
        return blobName;
      } else {
        print("Upload failed: ${uploadResponse.statusCode}");
        return 'Failed';
      }
    } else {
      print("Failed to get presigned URL: ${response.statusCode}");
      return 'Failed';
    }
  } catch (e) {
    print("Error uploading file: $e");
    return 'Failed';
  }
}
