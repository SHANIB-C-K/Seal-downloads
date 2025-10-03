import 'package:equatable/equatable.dart';

class VideoFormat extends Equatable {
  final String formatId;
  final String? formatNote;
  final String? ext;
  final int? width;
  final int? height;
  final int? fps;
  final String? vcodec;
  final String? acodec;
  final int? filesize;
  final int? tbr;
  final String? protocol;

  const VideoFormat({
    required this.formatId,
    this.formatNote,
    this.ext,
    this.width,
    this.height,
    this.fps,
    this.vcodec,
    this.acodec,
    this.filesize,
    this.tbr,
    this.protocol,
  });

  bool get isVideoOnly => acodec == 'none' && vcodec != 'none';
  bool get isAudioOnly => vcodec == 'none' && acodec != 'none';
  bool get hasVideo => vcodec != null && vcodec != 'none';
  bool get hasAudio => acodec != null && acodec != 'none';

  @override
  List<Object?> get props => [
        formatId,
        formatNote,
        ext,
        width,
        height,
        fps,
        vcodec,
        acodec,
        filesize,
        tbr,
        protocol,
      ];
}

class VideoInfo extends Equatable {
  final String id;
  final String url;
  final String title;
  final String? description;
  final String? uploader;
  final String? uploaderUrl;
  final String? thumbnail;
  final Duration? duration;
  final int? viewCount;
  final int? likeCount;
  final DateTime? uploadDate;
  final List<VideoFormat> formats;
  final String? extractor;
  final String? webpage_url;

  const VideoInfo({
    required this.id,
    required this.url,
    required this.title,
    this.description,
    this.uploader,
    this.uploaderUrl,
    this.thumbnail,
    this.duration,
    this.viewCount,
    this.likeCount,
    this.uploadDate,
    required this.formats,
    this.extractor,
    this.webpage_url,
  });

  List<VideoFormat> get videoFormats => formats.where((f) => f.hasVideo).toList();
  List<VideoFormat> get audioFormats => formats.where((f) => f.isAudioOnly).toList();
  
  VideoFormat? get bestVideoFormat {
    final videoFmts = videoFormats;
    if (videoFmts.isEmpty) return null;
    
    // Sort by resolution (height) and quality
    videoFmts.sort((a, b) {
      final heightA = a.height ?? 0;
      final heightB = b.height ?? 0;
      return heightB.compareTo(heightA);
    });
    
    return videoFmts.first;
  }
  
  VideoFormat? get bestAudioFormat {
    final audioFmts = audioFormats;
    if (audioFmts.isEmpty) return null;
    
    // Sort by bitrate
    audioFmts.sort((a, b) {
      final brA = a.tbr ?? 0;
      final brB = b.tbr ?? 0;
      return brB.compareTo(brA);
    });
    
    return audioFmts.first;
  }

  @override
  List<Object?> get props => [
        id,
        url,
        title,
        description,
        uploader,
        uploaderUrl,
        thumbnail,
        duration,
        viewCount,
        likeCount,
        uploadDate,
        formats,
        extractor,
        webpage_url,
      ];
}