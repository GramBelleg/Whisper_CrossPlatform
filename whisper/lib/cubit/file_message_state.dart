abstract class FileMessageState {}

class FileMessageChecked extends FileMessageState {
  final bool fileExists;
  FileMessageChecked({required this.fileExists});
}

class FileMessageDownloaded extends FileMessageState {
  final String filePath;
  FileMessageDownloaded({required this.filePath});
}

class FileMessageError extends FileMessageState {
  final String message;
  FileMessageError({required this.message});
}

class FileMessageOpened extends FileMessageState {}

class FileMessageDownloading extends FileMessageState {}

class FileMessageInitial extends FileMessageState {}

class FileMessageLoading extends FileMessageState {}
