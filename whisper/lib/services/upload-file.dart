import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:whisper/services/shared-preferences.dart';

Future<void> uploadFile(String filePath, String fileExtension) async {
  print("Uploading file: $filePath");

  final String apiUrl = 'http://localhost:5000/api/media/write';
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
          'x-ms-blob-type':
              'BlockBlob', // Added header for Azure Blob Storage compatibility
        },
        body: fileBytes,
      );

      if (uploadResponse.statusCode == 200) {
        print('File uploaded successfully. Blob name: $blobName');
      } else {
        print('File upload failed with status: ${uploadResponse.statusCode}');
        print('Response body: ${uploadResponse.body}');
        throw Exception(
            'File upload failed with status: ${uploadResponse.statusCode}');
      }
    } else {
      throw Exception(
          'Failed to get presigned URL. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
