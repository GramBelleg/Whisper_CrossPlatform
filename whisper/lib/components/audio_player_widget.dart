import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/read_file.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String blobName;
  final bool isSent;
  final WaveformType waveformType;
  // final PlayerController playerController;
  // final Function(String) onPlay;

  const AudioPlayerWidget({
    required this.blobName,
    required this.isSent,
    required this.waveformType,
    // required this.playerController,
    // required this.onPlay,
    super.key,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
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

  bool _isError = false;
  bool _isloading = true;
  int currentPosition = 0; // To track the current position of the player
  int totalDuration = 0; // To store the total duration of the audio

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
    _preparePlayer();
    playerStateSubscription =
        playerController.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });

    positionSubscription =
        playerController.onCurrentDurationChanged.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
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

      if (kDebugMode) print("File path: $filePath");
      file = File(filePath);

      // I will only download the file if it doesn't exist
      if (!file!.existsSync()) {
        if (kDebugMode) print("File does not exist. Downloading...");
        // Generate presigned URL
        String fileUrl = await generatePresignedUrl(widget.blobName);

        // Download the file
        await dio.download(fileUrl, filePath);

        if (File(filePath).existsSync()) {
          if (kDebugMode) print("File downloaded successfully at $filePath");
        }
      }
      // playerController.setFinishMode(finishMode: FinishMode.pause);
      await playerController.preparePlayer(
        path: filePath,
        shouldExtractWaveform: true,
        noOfSamples: 40,
      );

      totalDuration = await playerController
          .getDuration(DurationType.max); // Get total duration
      if (mounted) {
        setState(() {
          _isloading = false;
        });
      } // Refresh UI after preparation
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }

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
    if (_isError) {
      return const Icon(
        Icons.error,
        color: Colors.red,
      );
    }

    if (_isloading) {
      return Row(children: [
        CircularProgressIndicator.adaptive(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        Text(
          " Processing Audio ...",
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ]);
    }

    return Column(
      children: [
        Row(
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
            totalDuration == 0
                ? CircularProgressIndicator.adaptive()
                : AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 1.8,
                        MediaQuery.of(context).size.height / 30),
                    playerController: playerController,
                    waveformType: widget.waveformType,
                    enableSeekGesture: true,
                    playerWaveStyle: waveStyle,
                  ),
            const SizedBox(height: 8),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            totalDuration == 0
                ? Text("Processing...",
                    style: const TextStyle(color: Colors.white70, fontSize: 12))
                : Text(
                    "${_formatDuration(currentPosition).toString()} / ${_formatDuration(totalDuration).toString()}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
          ],
        ),
      ],
    );
  }
}
