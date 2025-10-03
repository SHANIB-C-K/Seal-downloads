import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/download_repository.dart';
import '../../domain/usecases/download_usecases.dart';
import '../../data/repositories/download_repository_impl.dart';

// Repository Providers
final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  throw UnimplementedError('Download repository must be initialized asynchronously');
});

final downloadRepositoryAsyncProvider = FutureProvider<DownloadRepository>((ref) async {
  return await DownloadRepositoryImpl.create();
});

// UseCase Providers
final getVideoInfoUseCaseProvider = Provider<GetVideoInfoUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return GetVideoInfoUseCase(repository);
});

final startDownloadUseCaseProvider = Provider<StartDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return StartDownloadUseCase(repository);
});

final pauseDownloadUseCaseProvider = Provider<PauseDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return PauseDownloadUseCase(repository);
});

final resumeDownloadUseCaseProvider = Provider<ResumeDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return ResumeDownloadUseCase(repository);
});

final cancelDownloadUseCaseProvider = Provider<CancelDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return CancelDownloadUseCase(repository);
});

final removeDownloadUseCaseProvider = Provider<RemoveDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return RemoveDownloadUseCase(repository);
});

final getAllDownloadsUseCaseProvider = Provider<GetAllDownloadsUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return GetAllDownloadsUseCase(repository);
});

final watchDownloadProgressUseCaseProvider = Provider<WatchDownloadProgressUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return WatchDownloadProgressUseCase(repository);
});

final clearCompletedDownloadsUseCaseProvider = Provider<ClearCompletedDownloadsUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return ClearCompletedDownloadsUseCase(repository);
});

final retryDownloadUseCaseProvider = Provider<RetryDownloadUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return RetryDownloadUseCase(repository);
});

final getDownloadStatsUseCaseProvider = Provider<GetDownloadStatsUseCase>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return GetDownloadStatsUseCase(repository);
});