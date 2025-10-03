import 'package:equatable/equatable.dart';

enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  paused,
  canceled,
}

enum DownloadFormat {
  mp4_720p('mp4', '720p', 'video'),
  mp4_1080p('mp4', '1080p', 'video'),
  mp4_best('mp4', 'best', 'video'),
  mp3_128k('mp3', '128k', 'audio'),
  mp3_320k('mp3', '320k', 'audio'),
  m4a_best('m4a', 'best', 'audio');

  const DownloadFormat(this.container, this.quality, this.type);
  final String container;
  final String quality;
  final String type;

  String get displayName {
    switch (this) {
      case mp4_720p:
        return 'MP4 720p';
      case mp4_1080p:
        return 'MP4 1080p';
      case mp4_best:
        return 'MP4 Best Quality';
      case mp3_128k:
        return 'MP3 128kbps';
      case mp3_320k:
        return 'MP3 320kbps';
      case m4a_best:
        return 'M4A Best Quality';
    }
  }

  bool get isAudio => type == 'audio';
  bool get isVideo => type == 'video';
}

class Download extends Equatable {
  final String id;
  final String url;
  final String title;
  final String? thumbnail;
  final String? description;
  final String? uploader;
  final Duration? duration;
  final DownloadFormat format;
  final DownloadStatus status;
  final double progress;
  final String? errorMessage;
  final String? outputPath;
  final int? fileSize;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const Download({
    required this.id,
    required this.url,
    required this.title,
    this.thumbnail,
    this.description,
    this.uploader,
    this.duration,
    required this.format,
    required this.status,
    this.progress = 0.0,
    this.errorMessage,
    this.outputPath,
    this.fileSize,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  Download copyWith({
    String? id,
    String? url,
    String? title,
    String? thumbnail,
    String? description,
    String? uploader,
    Duration? duration,
    DownloadFormat? format,
    DownloadStatus? status,
    double? progress,
    String? errorMessage,
    String? outputPath,
    int? fileSize,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Download(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      uploader: uploader ?? this.uploader,
      duration: duration ?? this.duration,
      format: format ?? this.format,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      outputPath: outputPath ?? this.outputPath,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        title,
        thumbnail,
        description,
        uploader,
        duration,
        format,
        status,
        progress,
        errorMessage,
        outputPath,
        fileSize,
        createdAt,
        startedAt,
        completedAt,
      ];
}