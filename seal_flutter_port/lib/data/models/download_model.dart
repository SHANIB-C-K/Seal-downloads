import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/download.dart';

part 'download_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class DownloadModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? thumbnail;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? uploader;

  @HiveField(6)
  final int? durationSeconds;

  @HiveField(7)
  final int formatIndex;

  @HiveField(8)
  final int statusIndex;

  @HiveField(9)
  final double progress;

  @HiveField(10)
  final String? errorMessage;

  @HiveField(11)
  final String? outputPath;

  @HiveField(12)
  final int? fileSize;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime? startedAt;

  @HiveField(15)
  final DateTime? completedAt;

  DownloadModel({
    required this.id,
    required this.url,
    required this.title,
    this.thumbnail,
    this.description,
    this.uploader,
    this.durationSeconds,
    required this.formatIndex,
    required this.statusIndex,
    this.progress = 0.0,
    this.errorMessage,
    this.outputPath,
    this.fileSize,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  factory DownloadModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadModelToJson(this);

  factory DownloadModel.fromEntity(Download download) {
    return DownloadModel(
      id: download.id,
      url: download.url,
      title: download.title,
      thumbnail: download.thumbnail,
      description: download.description,
      uploader: download.uploader,
      durationSeconds: download.duration?.inSeconds,
      formatIndex: download.format.index,
      statusIndex: download.status.index,
      progress: download.progress,
      errorMessage: download.errorMessage,
      outputPath: download.outputPath,
      fileSize: download.fileSize,
      createdAt: download.createdAt,
      startedAt: download.startedAt,
      completedAt: download.completedAt,
    );
  }

  Download toEntity() {
    return Download(
      id: id,
      url: url,
      title: title,
      thumbnail: thumbnail,
      description: description,
      uploader: uploader,
      duration: durationSeconds != null ? Duration(seconds: durationSeconds!) : null,
      format: DownloadFormat.values[formatIndex],
      status: DownloadStatus.values[statusIndex],
      progress: progress,
      errorMessage: errorMessage,
      outputPath: outputPath,
      fileSize: fileSize,
      createdAt: createdAt,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }

  DownloadModel copyWith({
    String? id,
    String? url,
    String? title,
    String? thumbnail,
    String? description,
    String? uploader,
    int? durationSeconds,
    int? formatIndex,
    int? statusIndex,
    double? progress,
    String? errorMessage,
    String? outputPath,
    int? fileSize,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return DownloadModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      uploader: uploader ?? this.uploader,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      formatIndex: formatIndex ?? this.formatIndex,
      statusIndex: statusIndex ?? this.statusIndex,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      outputPath: outputPath ?? this.outputPath,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}