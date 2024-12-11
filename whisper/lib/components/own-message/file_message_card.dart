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

class FileMessageCard extends OwnMessage {
  final String blobName;

  FileMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
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
    return _FileMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _FileMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;

  const _FileMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  State<_FileMessageCardStateful> createState() => _FileMessageCardState();
}

class _FileMessageCardState extends State<_FileMessageCardStateful> {
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: widget.isSelected ? selectColor : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Card(
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      String fileUrl =
                                          await generatePresignedUrl(
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
              }),
        ));
  }
}
