import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/file_message_cubit.dart';
import 'package:whisper/cubit/file_message_state.dart';
import 'package:whisper/components/own-message/file-message-state-handler.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/services/read_file.dart';

class RepliedFileMessageCard extends OwnMessage {
  final String blobName;
  final String repliedContent;
  final String repliedSenderName;

  RepliedFileMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required this.repliedContent,
    required this.repliedSenderName,
    required MessageStatus status,
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
    return _RepliedFileMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
      repliedContent: repliedContent,
      repliedSenderName: repliedSenderName,
    );
  }
}

class _RepliedFileMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;
  final String repliedContent;
  final String repliedSenderName;

  const _RepliedFileMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    required this.repliedContent,
    required this.repliedSenderName,
    Key? key,
  }) : super(key: key);

  @override
  State<_RepliedFileMessageCardStateful> createState() =>
      _RepliedFileMessageCardState();
}

class _RepliedFileMessageCardState
    extends State<_RepliedFileMessageCardStateful> {
  final Dio dio = Dio();
  bool isDownloading = false;
  bool fileExists = false;
  late FileMessageCubit fileMessageCubit = FileMessageCubit(dio: Dio());
  FileMessageStateHandler fileMessageStateHandler = FileMessageStateHandler();

  @override
  void initState() {
    super.initState();
    fileMessageCubit.checkFileExistence(widget.blobName, fileExists);
  }

  void setisdownloading(bool value) {
    setState(() {
      isDownloading = value;
    });
  }

  void setisexisting(bool value) {
    setState(() {
      fileExists = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: BlocProvider<FileMessageCubit>.value(
        value: fileMessageCubit,
        child: BlocConsumer<FileMessageCubit, FileMessageState>(
            listener: (context, state) =>
                fileMessageStateHandler.handleFileMessageState(
                    context, state, setisdownloading, setisexisting),
            builder: (BuildContext context, FileMessageState state) {
              return Container(
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
                        color: primaryColor,
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
                              // Display reply bubble
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xffb39ddb),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.repliedSenderName ?? "Unknown",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.repliedContent,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Display the file message
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.file,
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
                                        : widget.status ==
                                                MessageStatus.received
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
                                    : Text(fileExists
                                        ? "Open File"
                                        : "Download File"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
