import 'dart:io';
import '../../domain/entities/video_info.dart';

abstract class YtDlpService {
  /// Get video information without downloading
  Future<VideoInfo> getVideoInfo(String url);
  
  /// Download video with progress callback
  Future<String> downloadVideo({
    required String url,
    required String outputPath,
    String? format,
    Function(double progress)? onProgress,
    Function(String message)? onLog,
  });
  
  /// Check if yt-dlp is available
  Future<bool> isAvailable();
  
  /// Get yt-dlp version
  Future<String> getVersion();
  
  /// Update yt-dlp binary (if supported)
  Future<bool> updateBinary();
}

class YtDlpServiceFactory {
  static YtDlpService create() {
    if (Platform.isAndroid || Platform.isIOS) {
      return MobileYtDlpService();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DesktopYtDlpService();
    } else {
      return WebYtDlpService();
    }
  }
}

class MobileYtDlpService implements YtDlpService {
  @override
  Future<VideoInfo> getVideoInfo(String url) async {
    // Implementation for mobile using yt-dlp binary
    // This would use process execution or FFI to call yt-dlp
    throw UnimplementedError('Mobile yt-dlp implementation needed');
  }

  @override
  Future<String> downloadVideo({
    required String url,
    required String outputPath,
    String? format,
    Function(double progress)? onProgress,
    Function(String message)? onLog,
  }) async {
    throw UnimplementedError('Mobile download implementation needed');
  }

  @override
  Future<bool> isAvailable() async {
    // Check if yt-dlp binary is bundled with the app
    return true; // Assume available if bundled
  }

  @override
  Future<String> getVersion() async {
    return '2023.12.30'; // Would execute yt-dlp --version
  }

  @override
  Future<bool> updateBinary() async {
    // Mobile apps typically have bundled binaries that can't be updated
    return false;
  }
}

class DesktopYtDlpService implements YtDlpService {
  @override
  Future<VideoInfo> getVideoInfo(String url) async {
    // Implementation for desktop using system yt-dlp or bundled binary
    throw UnimplementedError('Desktop yt-dlp implementation needed');
  }

  @override
  Future<String> downloadVideo({
    required String url,
    required String outputPath,
    String? format,
    Function(double progress)? onProgress,
    Function(String message)? onLog,
  }) async {
    throw UnimplementedError('Desktop download implementation needed');
  }

  @override
  Future<bool> isAvailable() async {
    // Check if yt-dlp is installed on system or use bundled version
    return true;
  }

  @override
  Future<String> getVersion() async {
    return '2023.12.30';
  }

  @override
  Future<bool> updateBinary() async {
    // Desktop can potentially update yt-dlp binary
    return true;
  }
}

class WebYtDlpService implements YtDlpService {
  final String _apiBaseUrl = 'https://your-ytdlp-api.com'; // Would need a backend service

  @override
  Future<VideoInfo> getVideoInfo(String url) async {
    // Web implementation using a backend API service
    // This would make HTTP calls to a server running yt-dlp
    throw UnimplementedError('Web yt-dlp API implementation needed');
  }

  @override
  Future<String> downloadVideo({
    required String url,
    required String outputPath,
    String? format,
    Function(double progress)? onProgress,
    Function(String message)? onLog,
  }) async {
    // Web downloads would be handled differently
    // Potentially using a backend service that processes and serves the file
    throw UnimplementedError('Web download implementation needed');
  }

  @override
  Future<bool> isAvailable() async {
    // Check if the backend API is available
    try {
      // Would make a health check to the API
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getVersion() async {
    return 'API v1.0';
  }

  @override
  Future<bool> updateBinary() async {
    // Web version doesn't update binaries
    return false;
  }
}