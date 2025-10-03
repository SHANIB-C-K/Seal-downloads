import '../entities/download.dart';
import '../entities/video_info.dart';
import '../repositories/download_repository.dart';

class GetVideoInfoUseCase {
  final DownloadRepository repository;

  GetVideoInfoUseCase(this.repository);

  Future<VideoInfo> call(String url) async {
    if (!_isValidUrl(url)) {
      throw ArgumentError('Invalid URL format');
    }
    return await repository.getVideoInfo(url);
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;
    
    // Check for supported domains
    final supportedDomains = [
      'youtube.com',
      'youtu.be',
      'vimeo.com',
      'dailymotion.com',
      'twitch.tv',
      'soundcloud.com',
      'instagram.com',
      'twitter.com',
      'x.com',
      'tiktok.com',
    ];
    
    return supportedDomains.any((domain) => 
      uri.host.contains(domain) || uri.host == domain);
  }
}

class StartDownloadUseCase {
  final DownloadRepository repository;

  StartDownloadUseCase(this.repository);

  Future<void> call(Download download) async {
    await repository.startDownload(download);
  }
}

class PauseDownloadUseCase {
  final DownloadRepository repository;

  PauseDownloadUseCase(this.repository);

  Future<void> call(String downloadId) async {
    await repository.pauseDownload(downloadId);
  }
}

class ResumeDownloadUseCase {
  final DownloadRepository repository;

  ResumeDownloadUseCase(this.repository);

  Future<void> call(String downloadId) async {
    await repository.resumeDownload(downloadId);
  }
}

class CancelDownloadUseCase {
  final DownloadRepository repository;

  CancelDownloadUseCase(this.repository);

  Future<void> call(String downloadId) async {
    await repository.cancelDownload(downloadId);
  }
}

class RemoveDownloadUseCase {
  final DownloadRepository repository;

  RemoveDownloadUseCase(this.repository);

  Future<void> call(String downloadId) async {
    await repository.removeDownload(downloadId);
  }
}

class GetAllDownloadsUseCase {
  final DownloadRepository repository;

  GetAllDownloadsUseCase(this.repository);

  Stream<List<Download>> call() {
    return repository.getAllDownloads();
  }
}

class WatchDownloadProgressUseCase {
  final DownloadRepository repository;

  WatchDownloadProgressUseCase(this.repository);

  Stream<Download> call(String downloadId) {
    return repository.watchDownloadProgress(downloadId);
  }
}

class ClearCompletedDownloadsUseCase {
  final DownloadRepository repository;

  ClearCompletedDownloadsUseCase(this.repository);

  Future<void> call() async {
    await repository.clearCompletedDownloads();
  }
}

class RetryDownloadUseCase {
  final DownloadRepository repository;

  RetryDownloadUseCase(this.repository);

  Future<void> call(String downloadId) async {
    await repository.retryDownload(downloadId);
  }
}

class GetDownloadStatsUseCase {
  final DownloadRepository repository;

  GetDownloadStatsUseCase(this.repository);

  Future<Map<String, int>> call() async {
    return await repository.getDownloadStats();
  }
}