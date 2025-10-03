import '../entities/download.dart';
import '../entities/video_info.dart';

abstract class DownloadRepository {
  /// Get video information from URL
  Future<VideoInfo> getVideoInfo(String url);
  
  /// Start a download
  Future<void> startDownload(Download download);
  
  /// Pause a download
  Future<void> pauseDownload(String downloadId);
  
  /// Resume a download
  Future<void> resumeDownload(String downloadId);
  
  /// Cancel a download
  Future<void> cancelDownload(String downloadId);
  
  /// Remove a download from history
  Future<void> removeDownload(String downloadId);
  
  /// Get all downloads
  Stream<List<Download>> getAllDownloads();
  
  /// Get download by id
  Future<Download?> getDownloadById(String downloadId);
  
  /// Listen to download progress updates
  Stream<Download> watchDownloadProgress(String downloadId);
  
  /// Clear all completed downloads
  Future<void> clearCompletedDownloads();
  
  /// Retry a failed download
  Future<void> retryDownload(String downloadId);
  
  /// Get download statistics
  Future<Map<String, int>> getDownloadStats();
}