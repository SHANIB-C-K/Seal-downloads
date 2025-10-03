import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/download.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/repositories/download_repository.dart';
import '../../core/platform/ytdlp_service.dart';
import '../../core/platform/ytdlp_desktop_impl.dart';
import '../models/download_model.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final YtDlpService _ytdlpService;
  final Logger _logger = Logger();
  late Box<DownloadModel> _downloadBox;
  final Map<String, StreamController<Download>> _progressStreams = {};
  final Uuid _uuid = const Uuid();

  DownloadRepositoryImpl(this._ytdlpService);

  static Future<DownloadRepositoryImpl> create() async {
    YtDlpService ytdlpService;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      ytdlpService = DesktopYtDlpServiceImpl();
    } else {
      ytdlpService = YtDlpServiceFactory.create();
    }
    
    final repo = DownloadRepositoryImpl(ytdlpService);
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      // We'll need to generate this with build_runner
      // Hive.registerAdapter(DownloadModelAdapter());
    }
    
    _downloadBox = await Hive.openBox<DownloadModel>('downloads');
    _logger.i('Download repository initialized');
  }

  @override
  Future<VideoInfo> getVideoInfo(String url) async {
    try {
      _logger.i('Getting video info for: $url');
      final videoInfo = await _ytdlpService.getVideoInfo(url);
      _logger.i('Successfully got video info: ${videoInfo.title}');
      return videoInfo;
    } catch (e) {
      _logger.e('Failed to get video info: $e');
      rethrow;
    }
  }

  @override
  Future<void> startDownload(Download download) async {
    try {
      _logger.i('Starting download: ${download.title}');
      
      // Save download to database
      final downloadModel = DownloadModel.fromEntity(download);
      await _downloadBox.put(download.id, downloadModel);

      // Get downloads directory
      final downloadsDir = await _getDownloadsDirectory();
      
      // Create progress stream
      final progressController = StreamController<Download>.broadcast();
      _progressStreams[download.id] = progressController;

      // Update download status to downloading
      await _updateDownloadStatus(download.id, DownloadStatus.downloading);

      // Start actual download
      _downloadInBackground(download, downloadsDir.path, progressController);
      
    } catch (e) {
      _logger.e('Failed to start download: $e');
      await _updateDownloadStatus(download.id, DownloadStatus.failed, errorMessage: e.toString());
      rethrow;
    }
  }

  void _downloadInBackground(Download download, String outputPath, StreamController<Download> progressController) async {
    try {
      await _updateDownloadStatus(download.id, DownloadStatus.downloading, startedAt: DateTime.now());
      
      String? formatString;
      if (download.format.isVideo) {
        // Video format
        switch (download.format) {
          case DownloadFormat.mp4_720p:
            formatString = 'best[height<=720]';
            break;
          case DownloadFormat.mp4_1080p:
            formatString = 'best[height<=1080]';
            break;
          case DownloadFormat.mp4_best:
            formatString = 'best';
            break;
          default:
            formatString = 'best';
        }
      } else {
        // Audio format
        switch (download.format) {
          case DownloadFormat.mp3_128k:
            formatString = 'bestaudio[abr<=128]/best[abr<=128]';
            break;
          case DownloadFormat.mp3_320k:
            formatString = 'bestaudio[abr<=320]/best[abr<=320]';
            break;
          case DownloadFormat.m4a_best:
            formatString = 'bestaudio';
            break;
          default:
            formatString = 'bestaudio';
        }
      }

      final filePath = await _ytdlpService.downloadVideo(
        url: download.url,
        outputPath: outputPath,
        format: formatString,
        onProgress: (progress) async {
          await _updateDownloadProgress(download.id, progress);
          final updatedDownload = await getDownloadById(download.id);
          if (updatedDownload != null) {
            progressController.add(updatedDownload);
          }
        },
        onLog: (message) {
          _logger.d('Download log [${download.id}]: $message');
        },
      );

      // Mark as completed
      await _updateDownloadStatus(
        download.id, 
        DownloadStatus.completed, 
        completedAt: DateTime.now(),
        outputPath: filePath,
        progress: 1.0,
      );

      final completedDownload = await getDownloadById(download.id);
      if (completedDownload != null) {
        progressController.add(completedDownload);
      }

      _logger.i('Download completed: ${download.title}');
      
    } catch (e) {
      _logger.e('Download failed: $e');
      await _updateDownloadStatus(
        download.id, 
        DownloadStatus.failed, 
        errorMessage: e.toString()
      );
      
      final failedDownload = await getDownloadById(download.id);
      if (failedDownload != null) {
        progressController.add(failedDownload);
      }
    }
  }

  Future<Directory> _getDownloadsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${appDir.path}/Downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir;
  }

  Future<void> _updateDownloadStatus(
    String downloadId, 
    DownloadStatus status, {
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
    String? outputPath,
    double? progress,
  }) async {
    final downloadModel = _downloadBox.get(downloadId);
    if (downloadModel != null) {
      final updatedModel = downloadModel.copyWith(
        statusIndex: status.index,
        errorMessage: errorMessage,
        startedAt: startedAt,
        completedAt: completedAt,
        outputPath: outputPath,
        progress: progress ?? downloadModel.progress,
      );
      await _downloadBox.put(downloadId, updatedModel);
    }
  }

  Future<void> _updateDownloadProgress(String downloadId, double progress) async {
    final downloadModel = _downloadBox.get(downloadId);
    if (downloadModel != null) {
      final updatedModel = downloadModel.copyWith(progress: progress);
      await _downloadBox.put(downloadId, updatedModel);
    }
  }

  @override
  Future<void> pauseDownload(String downloadId) async {
    // Implementation would need to track and control the download process
    await _updateDownloadStatus(downloadId, DownloadStatus.paused);
  }

  @override
  Future<void> resumeDownload(String downloadId) async {
    final download = await getDownloadById(downloadId);
    if (download != null) {
      await startDownload(download);
    }
  }

  @override
  Future<void> cancelDownload(String downloadId) async {
    _progressStreams[downloadId]?.close();
    _progressStreams.remove(downloadId);
    await _updateDownloadStatus(downloadId, DownloadStatus.canceled);
  }

  @override
  Future<void> removeDownload(String downloadId) async {
    _progressStreams[downloadId]?.close();
    _progressStreams.remove(downloadId);
    await _downloadBox.delete(downloadId);
  }

  @override
  Stream<List<Download>> getAllDownloads() {
    return Stream.periodic(const Duration(milliseconds: 500), (_) {
      return _downloadBox.values.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Download?> getDownloadById(String downloadId) async {
    final downloadModel = _downloadBox.get(downloadId);
    return downloadModel?.toEntity();
  }

  @override
  Stream<Download> watchDownloadProgress(String downloadId) {
    final controller = _progressStreams[downloadId];
    if (controller != null) {
      return controller.stream;
    }
    
    // Return a stream that emits the current download state
    return Stream.periodic(const Duration(milliseconds: 500), (_) async {
      return await getDownloadById(downloadId);
    }).asyncMap((future) => future).where((download) => download != null).cast<Download>();
  }

  @override
  Future<void> clearCompletedDownloads() async {
    final completedKeys = <String>[];
    for (final entry in _downloadBox.toMap().entries) {
      if (DownloadStatus.values[entry.value.statusIndex] == DownloadStatus.completed) {
        completedKeys.add(entry.key);
      }
    }
    
    for (final key in completedKeys) {
      await _downloadBox.delete(key);
    }
  }

  @override
  Future<void> retryDownload(String downloadId) async {
    final download = await getDownloadById(downloadId);
    if (download != null) {
      final retryDownload = download.copyWith(
        id: _uuid.v4(),
        status: DownloadStatus.queued,
        progress: 0.0,
        errorMessage: null,
        startedAt: null,
        completedAt: null,
        createdAt: DateTime.now(),
      );
      await startDownload(retryDownload);
    }
  }

  @override
  Future<Map<String, int>> getDownloadStats() async {
    final stats = <String, int>{
      'total': 0,
      'completed': 0,
      'downloading': 0,
      'failed': 0,
      'queued': 0,
      'paused': 0,
      'canceled': 0,
    };

    for (final downloadModel in _downloadBox.values) {
      stats['total'] = (stats['total'] ?? 0) + 1;
      final status = DownloadStatus.values[downloadModel.statusIndex];
      final statusKey = status.toString().split('.').last;
      stats[statusKey] = (stats[statusKey] ?? 0) + 1;
    }

    return stats;
  }
}