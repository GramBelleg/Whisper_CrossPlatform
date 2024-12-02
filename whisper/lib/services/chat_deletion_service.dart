import 'package:http/http.dart' as http;
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';

class ChatDeletionService {
  Future<void> deleteMessages(int chatId, List<int> messageIds) async {
    // Build the URL with chatId in the path and message IDs as query parameters with square brackets
    final queryParameters = {
      'Ids':
          '[${messageIds.join(',')}]', // Convert list of IDs to a comma-separated string with square brackets
    };

    final url = Uri.http(
        '$ip:5000', '/api/messages/$chatId/deleteForMe', queryParameters);

    // Print the constructed URL to verify it's correct
    print('Constructed URL: ${url.toString()}');

    // Retrieve the authorization token
    String? token = await getToken();

    // Check if token is null
    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    print("Token retrieved, initiating delete request...");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Delete request sent, awaiting response...");

      if (response.statusCode == 200) {
        print("Messages deleted successfully.");
      } else {
        // Print the status code and the response body for debugging
        print('Failed to delete messages. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete messages: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and print any errors
      print('Error occurred during delete request: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
