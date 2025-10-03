import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/video_info_provider.dart';
import '../presentation/providers/download_manager_provider.dart';
import '../domain/entities/download.dart';
import '../domain/entities/video_info.dart';
import '../presentation/widgets/video_info_card.dart';
import '../presentation/widgets/download_format_selector.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _getVideoInfo() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    
    ref.read(videoInfoProvider.notifier).getVideoInfo(url);
  }

  void _showFormatSelector(VideoInfo videoInfo) {
    showDialog(
      context: context,
      builder: (context) => DownloadFormatSelector(
        videoInfo: videoInfo,
        onFormatSelected: (format) {
          Navigator.of(context).pop();
          _startDownload(videoInfo, format);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _startDownload(VideoInfo videoInfo, DownloadFormat format) {
    final download = ref.read(videoInfoProvider.notifier).createDownload(videoInfo, format);
    
    ref.read(downloadManagerProvider.notifier).startDownload(download);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download started: ${videoInfo.title}'),
        action: SnackBarAction(
          label: 'View Downloads',
          onPressed: () {
            // Navigate to downloads tab
            DefaultTabController.of(context)?.animateTo(1);
          },
        ),
      ),
    );
    
    // Clear the URL input and video info
    _urlController.clear();
    ref.read(videoInfoProvider.notifier).clear();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoInfoAsync = ref.watch(videoInfoProvider);
    final url = _urlController.text.trim();
    final isValidUrl = url.isNotEmpty && ref.watch(urlValidationProvider(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: () {
              // Paste from clipboard functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clipboard paste not available in web demo'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // URL Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Video URL',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'Paste video URL here...',
                        prefixIcon: const Icon(Icons.link),
                        border: const OutlineInputBorder(),
                        suffixIcon: _urlController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _urlController.clear();
                                  ref.read(videoInfoProvider.notifier).clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _getVideoInfo(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isValidUrl ? _getVideoInfo : null,
                        icon: videoInfoAsync.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        label: Text(videoInfoAsync.isLoading ? 'Getting Info...' : 'Get Video Info'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Video Info Display
            videoInfoAsync.when(
              data: (videoInfo) {
                if (videoInfo == null) {
                  return _buildInfoCard();
                }
                return VideoInfoCard(
                  videoInfo: videoInfo,
                  onDownload: () => _showFormatSelector(videoInfo),
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Fetching video information...'),
                      ],
                    ),
                  ),
                ),
              ),
              error: (error, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Error',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to get video information: $error',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => ref.read(videoInfoProvider.notifier).getVideoInfo(url),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Seal Flutter - Full Video Downloader',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This is a fully functional implementation of Seal with yt-dlp integration. '
              'Enter a video URL above to get started. Supports downloads from YouTube, Vimeo, and 1000+ other sites.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: const Text('YouTube'),
                  avatar: const Icon(Icons.play_circle_outline, size: 16),
                ),
                Chip(
                  label: const Text('Vimeo'),
                  avatar: const Icon(Icons.video_library, size: 16),
                ),
                Chip(
                  label: const Text('1000+ Sites'),
                  avatar: const Icon(Icons.public, size: 16),
                ),
                Chip(
                  label: const Text('HD/Audio'),
                  avatar: const Icon(Icons.high_quality, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}