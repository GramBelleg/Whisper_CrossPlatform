import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/constants/colors.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/services/read_file.dart';

class AudioMessageCard extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String forwardedFrom;
  final bool isSent;

  const AudioMessageCard({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.isSent,
    this.forwardedFrom = "",
    super.key,
  });

  @override
  State<AudioMessageCard> createState() => _AudioMessageCardState();
}

class _AudioMessageCardState extends State<AudioMessageCard> {
  File? file;
  Dio dio = Dio();
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<int> positionSubscription;

  final PlayerWaveStyle waveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.grey,
    liveWaveColor: secondNeutralColor,
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
    positionSubscription =
        playerController.onCurrentDurationChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    playerController.dispose();
    playerStateSubscription.cancel();
    positionSubscription.cancel();
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
    return const Placeholder();
  }
}
