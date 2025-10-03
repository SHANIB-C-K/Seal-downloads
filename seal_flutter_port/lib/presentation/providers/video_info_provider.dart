import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/entities/download.dart';
import '../../domain/usecases/download_usecases.dart';
import 'providers.dart';

enum VideoInfoState {
  initial,
  loading,
  loaded,
  error,
}

class VideoInfoNotifier extends StateNotifier<AsyncValue<VideoInfo?>> {
  VideoInfoNotifier(this._getVideoInfoUseCase) : super(const AsyncValue.data(null));

  final GetVideoInfoUseCase _getVideoInfoUseCase;
  final Uuid _uuid = const Uuid();

  Future<void> getVideoInfo(String url) async {
    state = const AsyncValue.loading();
    
    try {
      final videoInfo = await _getVideoInfoUseCase(url);
      state = AsyncValue.data(videoInfo);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }

  Download createDownload(VideoInfo videoInfo, DownloadFormat format) {
    return Download(
      id: _uuid.v4(),
      url: videoInfo.url,
      title: videoInfo.title,
      thumbnail: videoInfo.thumbnail,
      description: videoInfo.description,
      uploader: videoInfo.uploader,
      duration: videoInfo.duration,
      format: format,
      status: DownloadStatus.queued,
      createdAt: DateTime.now(),
    );
  }
}

final videoInfoProvider = StateNotifierProvider<VideoInfoNotifier, AsyncValue<VideoInfo?>>((ref) {
  final getVideoInfoUseCase = GetVideoInfoUseCase(
    ref.watch(downloadRepositoryAsyncProvider).value!
  );
  return VideoInfoNotifier(getVideoInfoUseCase);
});

// Provider for URL validation
final urlValidationProvider = Provider.family<bool, String>((ref, url) {
  if (url.isEmpty) return false;
  
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
    'facebook.com',
    'reddit.com',
  ];
  
  return supportedDomains.any((domain) => 
    uri.host.contains(domain) || uri.host == domain);
});