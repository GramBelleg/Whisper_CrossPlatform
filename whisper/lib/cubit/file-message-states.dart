abstract class FileMessageState {}

class FileMessageInitial extends FileMessageState {}

class FileMessageLoading extends FileMessageState {}

class FileMessageChecked extends FileMessageState {
  final bool fileExists;

  FileMessageChecked({required this.fileExists});
}

class FileMessageDownloading extends FileMessageState {}

class FileMessageDownloaded extends FileMessageState {
  final String filePath;

  FileMessageDownloaded({required this.filePath});
}

class FileMessageOpened extends FileMessageState {}

class FileMessageError extends FileMessageState {
  final String message;

  FileMessageError({required this.message});
}
