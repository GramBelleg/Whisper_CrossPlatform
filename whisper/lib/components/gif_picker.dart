import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/colors.dart';
// import 'package:image/image.dart';

class GifPicker extends StatefulWidget {
  final Function(String) onGifSelected;

  const GifPicker({super.key, required this.onGifSelected});

  @override
  State<GifPicker> createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  final String tenorApiKey = 'AIzaSyC1YIwmS4xpe2Gk9ZgdFtvyjEZMOi5gJzk';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> gifs = [];
  bool isLoading = false;
  bool isError = false;

  void searchGifs(String query) async {
    setState(() {
      isLoading = true;
    });

    String defaultQuery = 'trending';
    String searchQuery = query.isEmpty ? defaultQuery : query;

    final response = await http.get(
      Uri.parse(
          "https://tenor.googleapis.com/v2/search?q=$searchQuery&key=$tenorApiKey&client_key=my_test_app&limit=9"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      gifs = data['results'];
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print(
          'Failed to load gifs: ${_searchController.text} ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      color: firstNeutralColor,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: secondNeutralColor),
              decoration: InputDecoration(
                labelText: 'Search GIFs',
                labelStyle: TextStyle(color: secondNeutralColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: secondNeutralColor,
                  ),
                  onPressed: () => searchGifs(_searchController.text),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? Center(
                        child: Text('❗ Failed to load gifs',
                            style: TextStyle(color: Colors.red)))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: gifs.length,
                        itemBuilder: (context, index) {
                          final previewGifUrl =
                              gifs[index]['media_formats']['nanogif']['url'];
                          final sendGifUrl =
                              gifs[index]['media_formats']['tinygif']['url'];
                          return GestureDetector(
                            onTap: () => widget.onGifSelected(sendGifUrl),
                            child:
                                Image.network(previewGifUrl, fit: BoxFit.cover),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
