import 'package:flutter/material.dart';
import 'package:whisper/cubit/file_message_state.dart';

class FileMessageStateHandler {
  void handleFileMessageState(BuildContext context, FileMessageState state,
      Function setIsDownloading, Function setIsExisting) {
    if (state is FileMessageDownloading) {
      print("loading");
      setIsDownloading(true);
    } else if (state is FileMessageChecked) {
      setIsExisting(state.fileExists);
    } else if (state is FileMessageDownloaded) {
      setIsDownloading(false);
      setIsExisting(true);
    }
  }
}
