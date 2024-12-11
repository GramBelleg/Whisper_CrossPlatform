import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../constants/ip_for_services.dart';
import 'shared_preferences.dart';
import 'package:http/http.dart' as http;

class StickersService {
  String? _token;

  Future<List<String>> fetchExistingStickersBlobNames() async {
    _token = await getToken();

    try {
      final Uri url = Uri.parse("http://$ip:5000/api/stickers");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['stickers'];
        final List<String> blobNames = (data as List).map((sticker) {
          return sticker['blobName'].toString();
        }).toList();

        return blobNames;
      } else {
        throw Exception(
            "Failed to Load stickers ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to load stickers: $e");
    }
  }

  Future<List<String>> getPresignedURLforStickers() async {
    // 1. Get the presigned URL from /media/write
    final String apiUrl = 'http://$ip:5000/api/media/write';
    String? token = await getToken();

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fileExtension': 'sticker'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String presignedUrl = data['presignedUrl'];
        final String blobName = data['blobName'];

        return [presignedUrl, blobName];
      } else {
        throw Exception(
            "Failed to get presigned URL from /media/write: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get presigned URL from /media/write: $e");
    }
  }

  Future<String> uploadSticker(String filePath) async {
    final List<String> temp = await getPresignedURLforStickers();
    final String presignedUrl = temp[0];
    final String blobName = temp[1];
    print("TRYING TO UPLOAD STICKER: $presignedUrl");

    try {
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();
      print("TRYING TO UPLOAD STICKER: $filePath");
      print("TRYING TO UPLOAD STICKER BYTES: $fileBytes");

      final uploadResponse = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          'Content-Type': 'application/octet-stream',
          'x-ms-blob-type': 'BlockBlob',
        },
        body: fileBytes,
      );

      if (uploadResponse.statusCode == 201 ||
          uploadResponse.statusCode == 200) {
        print("upload sticker successful");
        return blobName;
      } else {
        throw Exception(
            "Failed to upload sticker: ${uploadResponse.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to upload sticker: $e");
    }
  }

  // TODO: Implement downloadSticker(String blobName)
  //to download the sticker from a given blobName
  Future<void> downloadSticker(String fileUrl, String blobName) async {
    // check if the file is already downloaded
    // if not, download the file
    try {
      Directory? baseDir = await getExternalStorageDirectory();
      String stickersDir = "${baseDir!.path}/stickers";
      // create stickersDir if it does not extist
      if (!await Directory(stickersDir).exists()) {
        await Directory(stickersDir).create(recursive: true);
      }

      final file = File("$stickersDir/$blobName");
      if (!file.existsSync()) {
        await http.get(Uri.parse(fileUrl)).then(
          (response) {
            if (response.statusCode == 200) {
              final file = File("$stickersDir/$blobName");
              file.writeAsBytes(response.bodyBytes);
            } else {
              throw Exception(
                  "Failed to download sticker: ${response.statusCode}");
            }
          },
        );
      }
    } catch (e) {
      throw Exception("Failed to download sticker: $e");
    }
  }
}
