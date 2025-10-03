// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadModelAdapter extends TypeAdapter<DownloadModel> {
  @override
  final int typeId = 0;

  @override
  DownloadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadModel(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      thumbnail: fields[3] as String?,
      description: fields[4] as String?,
      uploader: fields[5] as String?,
      durationSeconds: fields[6] as int?,
      formatIndex: fields[7] as int,
      statusIndex: fields[8] as int,
      progress: fields[9] as double,
      errorMessage: fields[10] as String?,
      outputPath: fields[11] as String?,
      fileSize: fields[12] as int?,
      createdAt: fields[13] as DateTime,
      startedAt: fields[14] as DateTime?,
      completedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.uploader)
      ..writeByte(6)
      ..write(obj.durationSeconds)
      ..writeByte(7)
      ..write(obj.formatIndex)
      ..writeByte(8)
      ..write(obj.statusIndex)
      ..writeByte(9)
      ..write(obj.progress)
      ..writeByte(10)
      ..write(obj.errorMessage)
      ..writeByte(11)
      ..write(obj.outputPath)
      ..writeByte(12)
      ..write(obj.fileSize)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.startedAt)
      ..writeByte(15)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadModel _$DownloadModelFromJson(Map<String, dynamic> json) =>
    DownloadModel(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String?,
      description: json['description'] as String?,
      uploader: json['uploader'] as String?,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      formatIndex: (json['formatIndex'] as num).toInt(),
      statusIndex: (json['statusIndex'] as num).toInt(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      errorMessage: json['errorMessage'] as String?,
      outputPath: json['outputPath'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$DownloadModelToJson(DownloadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'description': instance.description,
      'uploader': instance.uploader,
      'durationSeconds': instance.durationSeconds,
      'formatIndex': instance.formatIndex,
      'statusIndex': instance.statusIndex,
      'progress': instance.progress,
      'errorMessage': instance.errorMessage,
      'outputPath': instance.outputPath,
      'fileSize': instance.fileSize,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
