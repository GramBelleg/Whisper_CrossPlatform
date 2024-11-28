import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/file-message-cubit.dart';
import 'package:whisper/cubit/file-message-states.dart';
import 'package:whisper/modules/own-message/file-message-state-handler.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/modules/receive-message/received-message.dart';
import 'package:whisper/services/read-file.dart';

class ForwardedFileReceivedMessageCard extends ReceivedMessage {
  final String blobName;
  final String messageSenderName;

  ForwardedFileReceivedMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
    required this.messageSenderName,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return _ForwardedFileReceivedMessageCardStateful(
      blobName: blobName,
      originalSenderName: messageSenderName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _ForwardedFileReceivedMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String originalSenderName;

  const _ForwardedFileReceivedMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.originalSenderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_ForwardedFileReceivedMessageCardStateful> createState() =>
      _ForwardedFileReceivedMessageCardState();
}

class _ForwardedFileReceivedMessageCardState
    extends State<_ForwardedFileReceivedMessageCardStateful> {
  final Dio dio = Dio();
  bool isDownloading = false;
  bool fileExists = false;
  late FileMessageCubit fileMessageCubit = FileMessageCubit(dio: dio);
  FileMessageStateHandler fileMessageStateHandler = FileMessageStateHandler();

  @override
  void initState() {
    super.initState();
    fileMessageCubit.checkFileExistence(widget.blobName, fileExists);
  }

  void setIsDownloading(bool value) {
    setState(() {
      isDownloading = value;
    });
  }

  void setIsExisting(bool value) {
    setState(() {
      fileExists = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocProvider<FileMessageCubit>.value(
        value: fileMessageCubit,
        child: BlocConsumer<FileMessageCubit, FileMessageState>(
          listener: (context, state) =>
              fileMessageStateHandler.handleFileMessageState(
                  context, state, setIsDownloading, setIsExisting),
          builder: (BuildContext context, FileMessageState state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: widget.isSelected ? selectColor : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: const Color(0xff0A122F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Forwarded Sender Info
                            Text(
                              'Forwarded from:',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                            Text(
                              widget.originalSenderName,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.filePdf,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.blobName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'File',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  widget.status == MessageStatus.seen
                                      ? FontAwesomeIcons.checkDouble
                                      : widget.status == MessageStatus.received
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.clock,
                                  color: widget.status == MessageStatus.seen
                                      ? Colors.blue
                                      : Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (fileExists) {
                                  await fileMessageCubit
                                      .openFile(widget.blobName);
                                } else {
                                  String fileUrl = await generatePresignedUrl(
                                      widget.blobName);
                                  await fileMessageCubit.downloadFile(
                                      fileUrl, widget.blobName);
                                }
                              },
                              child: isDownloading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      fileExists
                                          ? "Open File"
                                          : "Download File",
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
