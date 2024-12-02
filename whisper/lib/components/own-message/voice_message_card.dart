import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/read_file.dart';
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
  File? file;
  Dio dio = Dio();
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<int> positionSubscription;

  final PlayerWaveStyle waveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.grey,
    liveWaveColor: Color(0xfffbfbfb),
    spacing: 6,
    waveThickness: 3,
    backgroundColor: Colors.grey,
  );

  int currentPosition = 0; // To track the current position of the player
  int totalDuration = 0; // To store the total duration of the audio

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
    _preparePlayer();
    playerStateSubscription =
        playerController.onPlayerStateChanged.listen((state) {
      setState(() {});
    });
    // Subscribe to position updates for real-time tracking
    positionSubscription =
        playerController.onCurrentDurationChanged.listen((position) {
      setState(() {
        currentPosition =
            position; // Update the current position as the audio plays
      });
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    positionSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  Future<void> _preparePlayer() async {
    try {
      Directory? baseDir = await getExternalStorageDirectory();
      if (baseDir == null) throw Exception("Failed to access storage");

      // Define file path
      String filePath = "${baseDir.path}/${widget.blobName}";
      // String filePath = "${baseDir.path}/test_audio.m4a";

      debugPrint("File path: $filePath");
      file = File(filePath);

      // I will only download the file if it doesn't exist
      if (!file!.existsSync()) {
        // Generate presigned URL
        String fileUrl = await generatePresignedUrl(widget.blobName);

        // Download the file
        await dio.download(fileUrl, filePath);

        if (File(filePath).existsSync()) {
          debugPrint("File downloaded successfully at $filePath");
        }
      }
      // playerController.setFinishMode(finishMode: FinishMode.pause);
      await playerController.preparePlayer(
        path: filePath,
        shouldExtractWaveform: true,
      );

      await playerController.extractWaveformData(
        path: filePath,
        noOfSamples: waveStyle.getSamplesForWidth(300),
      );

      totalDuration = await playerController
          .getDuration(DurationType.max); // Get total duration

      setState(() {}); // Refresh UI after preparation
    } catch (e) {
      debugPrint("Error preparing player: $e");
    }
  }

  String _formatDuration(int milliseconds) {
    int seconds = (milliseconds / 1000).round();
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: file == null
          ? CircularProgressIndicator.adaptive()
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.isSelected ? selectColor : Color(0xff8d6aee),
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 11,
              margin: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (playerController.playerState.isPlaying) {
                        await playerController.pausePlayer();
                      } else {
                        await playerController.startPlayer(forceRefresh: true);
                        await playerController.setFinishMode(
                            finishMode: FinishMode.pause);
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      playerController.playerState.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 2.5,
                        MediaQuery.of(context).size.height / 20),
                    playerController: playerController,
                    waveformType: WaveformType.long,
                    playerWaveStyle: waveStyle,
                  ),
                  const SizedBox(height: 8),
                  totalDuration == 0
                      ? CircularProgressIndicator.adaptive()
                      : currentPosition == 0
                          ? Text(
                              _formatDuration(totalDuration).toString(),
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(
                              _formatDuration(currentPosition).toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                ],
              ),
            ),
    );
  }
}
