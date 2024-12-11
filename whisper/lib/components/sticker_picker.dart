import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/constants/ip_for_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/stickers_service.dart';
import 'package:whisper/services/upload_file.dart';

class StickerPicker extends StatefulWidget {
  final Function(String) onStickerSelected;

  const StickerPicker({super.key, required this.onStickerSelected});

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker> {
  // a list of blobNames of stickers
  List<String> stickers = [];
  bool isLoading = true;
  bool isError = false;
  StickersService stickersService = StickersService();

  void fetchStickers() async {
    setState(() {
      isLoading = true;
    });

    await stickersService.downloadAllDbSickers();

    Directory? baseDir = await getExternalStorageDirectory();
    String stickersDir = "${baseDir!.path}/stickers";

    if (await Directory(stickersDir).exists()) {
      List<String> stickerFiles = Directory(stickersDir)
          .listSync()
          .where((file) => file is File && file.path.endsWith('.webp'))
          .map((file) => file.path)
          .toList();
      setState(() {
        stickers = stickerFiles;
      });
    }

    setState(() {
      isLoading = false;
      isError = false;
    });
  }

  Future<void> addStickerFromPhone() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['webp'],
    );

    if (result != null) {
      print("RESULT = $result");
      // Navigator.of(context).pop();
      PlatformFile file = result.files.first;
      String? filePath = file.path;
      print("Sticker selected: ${file.name} at $filePath");
      if (filePath != null) {
        String blobName = await stickersService.uploadSticker(filePath);

        // // //TODO: recheck this
        // setState(() {
        //   stickers.add(blobName);
        // });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStickers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      color: firstNeutralColor,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : stickers.isEmpty
              ? Column(
                  children: [
                    Center(
                      child: Text(
                        'No stickers found',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: addStickerFromPhone,
                      icon: Icon(Icons.add),
                    )
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: stickers.length,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          String stickerPath = stickers[index];
                          return GestureDetector(
                            onTap: () {
                              widget.onStickerSelected(stickers[index]);
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.file(
                                File(stickerPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: addStickerFromPhone,
                      icon: Icon(Icons.add),
                    )
                  ],
                ),
    );
  }
}
