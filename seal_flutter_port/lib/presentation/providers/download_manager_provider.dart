import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/download.dart';
import '../../domain/usecases/download_usecases.dart';
import 'providers.dart';

class DownloadManagerNotifier extends StateNotifier<AsyncValue<List<Download>>> {
  DownloadManagerNotifier(
    this._getAllDownloadsUseCase,
    this._startDownloadUseCase,
    this._pauseDownloadUseCase,
    this._resumeDownloadUseCase,
    this._cancelDownloadUseCase,
    this._removeDownloadUseCase,
    this._clearCompletedDownloadsUseCase,
    this._retryDownloadUseCase,
  ) : super(const AsyncValue.loading()) {
    _initialize();
  }

  final GetAllDownloadsUseCase _getAllDownloadsUseCase;
  final StartDownloadUseCase _startDownloadUseCase;
  final PauseDownloadUseCase _pauseDownloadUseCase;
  final ResumeDownloadUseCase _resumeDownloadUseCase;
  final CancelDownloadUseCase _cancelDownloadUseCase;
  final RemoveDownloadUseCase _removeDownloadUseCase;
  final ClearCompletedDownloadsUseCase _clearCompletedDownloadsUseCase;
  final RetryDownloadUseCase _retryDownloadUseCase;

  void _initialize() {
    // Listen to download updates
    _getAllDownloadsUseCase().listen(
      (downloads) {
        state = AsyncValue.data(downloads);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<void> startDownload(Download download) async {
    try {
      await _startDownloadUseCase(download);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> pauseDownload(String downloadId) async {
    try {
      await _pauseDownloadUseCase(downloadId);
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  Future<void> resumeDownload(String downloadId) async {
    try {
      await _resumeDownloadUseCase(downloadId);
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  Future<void> cancelDownload(String downloadId) async {
    try {
      await _cancelDownloadUseCase(downloadId);
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  Future<void> removeDownload(String downloadId) async {
    try {
      await _removeDownloadUseCase(downloadId);
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  Future<void> clearCompletedDownloads() async {
    try {
      await _clearCompletedDownloadsUseCase();
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  Future<void> retryDownload(String downloadId) async {
    try {
      await _retryDownloadUseCase(downloadId);
    } catch (e) {
      // Handle error but don't change the overall state
    }
  }

  List<Download> get activeDownloads {
    return state.value?.where((download) => 
      download.status == DownloadStatus.downloading ||
      download.status == DownloadStatus.queued ||
      download.status == DownloadStatus.paused
    ).toList() ?? [];
  }

  List<Download> get completedDownloads {
    return state.value?.where((download) => 
      download.status == DownloadStatus.completed
    ).toList() ?? [];
  }

  List<Download> get failedDownloads {
    return state.value?.where((download) => 
      download.status == DownloadStatus.failed
    ).toList() ?? [];
  }

  int get totalDownloads => state.value?.length ?? 0;
  int get activeDownloadsCount => activeDownloads.length;
  int get completedDownloadsCount => completedDownloads.length;
  int get failedDownloadsCount => failedDownloads.length;
}

final downloadManagerProvider = StateNotifierProvider<DownloadManagerNotifier, AsyncValue<List<Download>>>((ref) {
  // Wait for repository to be available
  final repository = ref.watch(downloadRepositoryAsyncProvider).value;
  if (repository == null) {
    return DownloadManagerNotifier(
      GetAllDownloadsUseCase(repository!),
      StartDownloadUseCase(repository),
      PauseDownloadUseCase(repository),
      ResumeDownloadUseCase(repository),
      CancelDownloadUseCase(repository),
      RemoveDownloadUseCase(repository),
      ClearCompletedDownloadsUseCase(repository),
      RetryDownloadUseCase(repository),
    );
  }

  return DownloadManagerNotifier(
    GetAllDownloadsUseCase(repository),
    StartDownloadUseCase(repository),
    PauseDownloadUseCase(repository),
    ResumeDownloadUseCase(repository),
    CancelDownloadUseCase(repository),
    RemoveDownloadUseCase(repository),
    ClearCompletedDownloadsUseCase(repository),
    RetryDownloadUseCase(repository),
  );
});

// Provider for download statistics
final downloadStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(downloadRepositoryAsyncProvider).value;
  if (repository == null) return <String, int>{};
  
  final useCase = GetDownloadStatsUseCase(repository);
  return await useCase();
});