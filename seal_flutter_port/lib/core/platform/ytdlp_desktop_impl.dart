import 'dart:convert';
import 'dart:io';
import 'package:process_run/process_run.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/video_info.dart';
import 'ytdlp_service.dart';

class DesktopYtDlpServiceImpl implements YtDlpService {
  final Logger _logger = Logger();
  String? _ytdlpPath;

  @override
  Future<bool> isAvailable() async {
    try {
      _ytdlpPath = await _findYtDlp();
      return _ytdlpPath != null;
    } catch (e) {
      _logger.e('Error checking yt-dlp availability: $e');
      return false;
    }
  }

  Future<String?> _findYtDlp() async {
    // Try common locations for yt-dlp
    final possiblePaths = [
      'yt-dlp',
      '/usr/local/bin/yt-dlp',
      '/usr/bin/yt-dlp',
      if (Platform.isWindows) 'yt-dlp.exe',
      if (Platform.isWindows) r'C:\Program Files\yt-dlp\yt-dlp.exe',
    ];

    for (final path in possiblePaths) {
      try {
        final result = await Process.run(path, ['--version']);
        if (result.exitCode == 0) {
          _logger.i('Found yt-dlp at: $path');
          return path;
        }
      } catch (e) {
        // Continue to next path
      }
    }

    // Try to install via pip if not found
    _logger.w('yt-dlp not found, attempting to install...');
    try {
      final result = await Process.run('pip3', ['install', '--user', 'yt-dlp']);
      if (result.exitCode == 0) {
        return 'yt-dlp';
      }
    } catch (e) {
      _logger.e('Failed to install yt-dlp: $e');
    }

    return null;
  }

  @override
  Future<String> getVersion() async {
    if (_ytdlpPath == null && !await isAvailable()) {
      throw Exception('yt-dlp not available');
    }

    try {
      final result = await Process.run(_ytdlpPath!, ['--version']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      } else {
        throw Exception('Failed to get yt-dlp version');
      }
    } catch (e) {
      _logger.e('Error getting yt-dlp version: $e');
      rethrow;
    }
  }

  @override
  Future<VideoInfo> getVideoInfo(String url) async {
    if (_ytdlpPath == null && !await isAvailable()) {
      throw Exception('yt-dlp not available');
    }

    try {
      final args = [
        '--dump-json',
        '--no-warnings',
        '--no-download',
        url,
      ];

      _logger.i('Getting video info for: $url');
      final result = await Process.run(_ytdlpPath!, args);

      if (result.exitCode != 0) {
        final error = result.stderr.toString();
        _logger.e('yt-dlp error: $error');
        throw Exception('Failed to get video info: $error');
      }

      final jsonStr = result.stdout.toString().trim();
      final jsonData = jsonDecode(jsonStr) as Map<String, dynamic>;

      return _parseVideoInfo(jsonData);
    } catch (e) {
      _logger.e('Error getting video info: $e');
      rethrow;
    }
  }

  VideoInfo _parseVideoInfo(Map<String, dynamic> json) {
    final formats = <VideoFormat>[];
    
    if (json['formats'] != null) {
      for (final formatData in json['formats'] as List) {
        formats.add(VideoFormat(
          formatId: formatData['format_id']?.toString() ?? '',
          formatNote: formatData['format_note']?.toString(),
          ext: formatData['ext']?.toString(),
          width: formatData['width'] as int?,
          height: formatData['height'] as int?,
          fps: formatData['fps'] as int?,
          vcodec: formatData['vcodec']?.toString(),
          acodec: formatData['acodec']?.toString(),
          filesize: formatData['filesize'] as int?,
          tbr: formatData['tbr']?.toInt(),
          protocol: formatData['protocol']?.toString(),
        ));
      }
    }

    Duration? duration;
    if (json['duration'] != null) {
      duration = Duration(seconds: (json['duration'] as num).toInt());
    }

    DateTime? uploadDate;
    if (json['upload_date'] != null) {
      final dateStr = json['upload_date'].toString();
      if (dateStr.length == 8) {
        final year = int.parse(dateStr.substring(0, 4));
        final month = int.parse(dateStr.substring(4, 6));
        final day = int.parse(dateStr.substring(6, 8));
        uploadDate = DateTime(year, month, day);
      }
    }

    return VideoInfo(
      id: json['id']?.toString() ?? '',
      url: json['webpage_url']?.toString() ?? json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      description: json['description']?.toString(),
      uploader: json['uploader']?.toString(),
      uploaderUrl: json['uploader_url']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      duration: duration,
      viewCount: json['view_count'] as int?,
      likeCount: json['like_count'] as int?,
      uploadDate: uploadDate,
      formats: formats,
      extractor: json['extractor']?.toString(),
      webpage_url: json['webpage_url']?.toString(),
    );
  }

  @override
  Future<String> downloadVideo({
    required String url,
    required String outputPath,
    String? format,
    Function(double progress)? onProgress,
    Function(String message)? onLog,
  }) async {
    if (_ytdlpPath == null && !await isAvailable()) {
      throw Exception('yt-dlp not available');
    }

    final args = <String>[
      '--no-warnings',
      '--output', '$outputPath/%(title)s.%(ext)s',
    ];

    if (format != null) {
      args.addAll(['--format', format]);
    }

    // Add progress reporting
    args.add('--newline');
    
    args.add(url);

    try {
      _logger.i('Starting download: $url');
      _logger.i('Command: $_ytdlpPath ${args.join(" ")}');

      final process = await Process.start(_ytdlpPath!, args);
      final outputFile = StringBuffer();

      // Handle stdout for progress updates
      process.stdout.transform(utf8.decoder).listen((data) {
        onLog?.call(data);
        _parseProgress(data, onProgress);
      });

      // Handle stderr for errors
      process.stderr.transform(utf8.decoder).listen((data) {
        _logger.w('yt-dlp stderr: $data');
        onLog?.call('ERROR: $data');
      });

      final exitCode = await process.exitCode;
      
      if (exitCode != 0) {
        throw Exception('Download failed with exit code: $exitCode');
      }

      // Return the path to the downloaded file
      // This is a simplification - in reality you'd need to parse the actual filename
      return outputPath;
    } catch (e) {
      _logger.e('Error downloading video: $e');
      rethrow;
    }
  }

  void _parseProgress(String output, Function(double progress)? onProgress) {
    if (onProgress == null) return;

    // Parse yt-dlp progress output
    final lines = output.split('\n');
    for (final line in lines) {
      if (line.contains('%') && line.contains('of')) {
        final regex = RegExp(r'(\d+\.?\d*)%');
        final match = regex.firstMatch(line);
        if (match != null) {
          final progressStr = match.group(1);
          if (progressStr != null) {
            final progress = double.tryParse(progressStr);
            if (progress != null) {
              onProgress(progress / 100.0);
            }
          }
        }
      }
    }
  }

  @override
  Future<bool> updateBinary() async {
    try {
      _logger.i('Updating yt-dlp...');
      final result = await Process.run('pip3', ['install', '--upgrade', 'yt-dlp']);
      return result.exitCode == 0;
    } catch (e) {
      _logger.e('Error updating yt-dlp: $e');
      return false;
    }
  }
}