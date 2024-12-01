import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/cubit/file-message-cubit.dart';
import 'package:whisper/modules/own-message/file-message-state-handler.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/read-file.dart';

class VoiceMessageCard extends OwnMessage {
  final String blobName;

  VoiceMessageCard({
    required this.blobName,
    required super.message,
    required super.time,
    required super.isSelected,
    required super.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _StatefulVoiceMessage(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _StatefulVoiceMessage extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;

  const _StatefulVoiceMessage({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    super.key,
  });

  @override
  State<_StatefulVoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<_StatefulVoiceMessage> {
  final Dio dio = Dio();
  bool isPlaying = false;
  bool isDownloading = false;
  bool fileExists = false;

  late PlayerController _playerController;
  late FileMessageCubit fileMessageCubit = FileMessageCubit(dio: Dio());
  // FileMessageStateHandler fileMessageStateHandler = FileMessageStateHandler();

  // @override
  // void initState() {
  //   super.initState();
  //   fileMessageCubit.checkFileExistence(widget.blobName, fileExists);
  //   _playerController = PlayerController();
  //   _initData();

  //   _playerController.extractWaveformData(
  //     path: widget.blobName,
  //     noOfSamples: 100,
  //   );
  // }

  Future<void> _downloadAndInitialize() async {
    // Download the file
    Directory? baseDir = await getExternalStorageDirectory();
    String filePath = "${baseDir!.path}/${widget.blobName}";
    String fileUrl = await generatePresignedUrl(
        widget.blobName); // Assuming you have this function.
    await fileMessageCubit.downloadFile(fileUrl, filePath);
    if (kDebugMode) {
      print(
          "DOWNLOADED FILE SUCCESSFULLY at $filePath");
    }

    // Initialize player controller or other resources
    _playerController = PlayerController();
    await _playerController.extractWaveformData(
      path: filePath,
      noOfSamples: 100,
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadAndInitialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Failed to download the file"),
          );
        } else {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: widget.isSelected ? selectColor : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Card(
                      color: const Color(0xff8D6AEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the audio message
                            AudioFileWaveforms(
                              playerController: _playerController,
                              size: Size(50, 50), // Width and height
                              enableSeekGesture: true,
                              waveformType: WaveformType.long,
                              playerWaveStyle: const PlayerWaveStyle(
                                fixedWaveColor: Color(0xff8D6AEE),
                                backgroundColor: Color(0xff0a122f),
                                spacing: 6,
                              ),
                            ),

                            const SizedBox(height: 5),
                            // Display the time
                            Text(
                              widget.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
