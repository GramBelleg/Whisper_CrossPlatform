import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/story.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/models/user_view.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/socket.dart';

// Define the base URL within the class as a constant
const String baseUrl = '$ip';
final socket = SocketService.instance.socket;
Future<Tuple2<List<User>, User?>> fetchUsersWithStories() async {
  final url = Uri.parse('$baseUrl/user/story');
  String? token = await getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Log the raw response body to inspect the structure
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Log the decoded data to inspect its structure
      print("print response fetchUsersWithStories ${response.body}");
      if (data is Map && data.containsKey('users') && data['users'] is List) {
        final List<dynamic> usersJson = data['users'];
        print('Decoded Data: $data');

        List<User> users = [];
        int? myId = await getId();
        print("id in print fetchUsersWithStories $myId");
        User? myUser;
        for (var userJson in usersJson) {
          // Fetch the profilePic presigned URL or use a default if null
          String? mediaUrl = userJson['profilePic'] != null
              ? await generatePresignedUrl(userJson['profilePic'])
              : 'https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(userJson['userName'])}';

          // Update profilePic with the presigned URL or default avatar
          userJson['profilePic'] = mediaUrl;

          // Create User object
          User user = User.fromJson(userJson);
          print("user.id ${user.id}");
          // Fetch stories for this user
          List<Story> stories = await fetchUserStories(user.id);

          // Set the stories to the user
          user = user.copyWith(stories: stories);

          if (user.id == myId) {
            print("here i'm saved");
            myUser = user;
          } else {
            // Add the user to the list
            print("another stories");
            users.add(user);
          }
        }
        print("Before fetchUserById, myUser: $myUser");
        myUser ??= await fetchUserById(myId!);
        print("After fetchUserById, myUser: $myUser");
        print("myUser toJson: ${myUser?.toJson()}");
        print("other stories ${users.map((user) => user.toJson()).toList()}");

        return Tuple2(users, myUser);
      } else {
        throw Exception('The "users" key is not a List or is missing.');
      }
    } else if (response.statusCode == 400) {
      // Handle the case for 400 Bad Request
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['message'] ?? 'Invalid request';
      throw Exception('Bad Request: $errorMessage');
    } else {
      // Handle other status codes
      throw Exception('Failed to load users from $url');
    }
  } catch (e) {
    // Handle exceptions
    if (e is SocketException) {
      print('No Internet connection: ${e.message}');
    } else if (e is TimeoutException) {
      print('Request timeout: ${e.message}');
    } else {
      print('Error occurred: ${e.toString()}');
    }
    rethrow; // Rethrow exception
  }
}

// Function to retrieve user info by ID
Future<User?> fetchUserById(int userId) async {
  const String baseUrl = '$ip';
  final String endpoint = '/user/$userId/info';
  final Uri url = Uri.parse('$baseUrl$endpoint');
  String? token = await getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      data['id'] = userId;
      print("date fetchUserById  $data");

      return User.fromJson(data);
    } else if (response.statusCode == 400) {
      // Handle 400 errors
      final Map<String, dynamic> errorData = json.decode(response.body);
      print('Error: ${errorData["message"]}');
    } else {
      // Handle other errors
      print('Error: Unexpected status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return null; // Return null if the request fails
}

Future<List<Story>> fetchUserStories(int userId) async {
  final url = '$baseUrl/user/story/$userId';
  String? token = await getToken();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> storiesJson = data['stories'];

    print("I'm received my stories: with id $userId ${response.body}");

    List<Story> stories = [];
    for (var storyJson in storiesJson) {
      // Extract media URL and generate presigned URL before creating Story
      String mediaUrl = await generatePresignedUrl(storyJson['media']);

      // Update the media URL in the story JSON
      storyJson['media'] = mediaUrl;

      // Now create the story object with the updated media URL
      Story story = Story.fromJson(storyJson);

      // Fetch the users who viewed this story
      List<UserView> storyViews = await fetchStoryViews(story.id);

      // Optionally, you can add the views data to the Story object (if needed)
      // Example: Add `viewers` property in Story model
      story = story.copyWith(storyViews: storyViews);

      // Add the story to the list
      stories.add(story);
    }

    return stories;
  } else {
    print("I'm not received my stories $url");
    throw Exception('Failed to load stories from $url');
  }
}

// Fetches the list of users who viewed a specific story by storyId
Future<List<UserView>> fetchStoryViews(int storyId) async {
  final url = '$baseUrl/user/story/getViews/$storyId';
  String? token = await getToken();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> usersJson = data['users'];

    // Parse users and create a list of UserView objects
    List<UserView> userViews = usersJson.map((userJson) {
      return UserView.fromJson(userJson);
    }).toList();

    return userViews;
  } else {
    throw Exception('Failed to load views for storyId $storyId');
  }
}
