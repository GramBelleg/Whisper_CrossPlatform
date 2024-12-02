import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/models/story.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';

class UserStoriesService {
  // Define the base URL within the class as a constant
  static const String baseUrl = 'http://$ip:5000/api';

  /// Fetch users with stories
  Future<List<User>> fetchUsersWithStories() async {
    final url = '$baseUrl/user/story';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> usersJson = data['users'];

      return usersJson.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users from $url');
    }
  }

  Future<List<Story>> fetchUserStories(int userId) async {
    final url = '$baseUrl/user/story/$userId';
    String? token = await getToken();

    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> storiesJson = data['stories'];

      print("I'm received my stories: ${response.body}");

      // Iterate through the stories and fetch the media URLs
      List<Story> stories = [];
      for (var storyJson in storiesJson) {
        // Extract media URL and generate presigned URL before creating Story

        String mediaUrl = await generatePresignedUrl(storyJson['media']);

        // Update the media URL in the story JSON
        storyJson['media'] = mediaUrl;

        // Now create the story object with the updated media URL
        stories.add(Story.fromJson(storyJson));
      }

      return stories;
    } else {
      print("I'm not received my stories $url");
      throw Exception('Failed to load stories from $url');
    }
  }

  // Future<List<UserView>> fetchStoryViews(int storyId) async {
  //   final url = Uri.parse("$baseUrl/$storyId");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body)['users'];
  //     return data.map((json) => UserView.fromJson(json)).toList();
  //   } else if (response.statusCode == 400) {
  //     throw Exception("Invalid story ID specified.");
  //   } else {
  //     throw Exception("Failed to load story views.");
  //   }
  // }
}
