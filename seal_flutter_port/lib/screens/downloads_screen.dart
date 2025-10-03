import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/download_manager_provider.dart';
import '../domain/entities/download.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadsAsync = ref.watch(downloadManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _showClearDialog(context, ref),
          ),
        ],
      ),
      body: downloadsAsync.when(
        data: (downloads) {
          if (downloads.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No downloads yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your downloaded videos will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final download = downloads[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: _getStatusIcon(download.status),
                  title: Text(
                    download.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(download.format.displayName),
                      const SizedBox(height: 4),
                      if (download.status == DownloadStatus.downloading)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(value: download.progress),
                            const SizedBox(height: 4),
                            Text('${(download.progress * 100).toInt()}%'),
                          ],
                        )
                      else
                        Text(
                          _formatDate(download.createdAt),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      if (download.errorMessage != null) ..[
                        const SizedBox(height: 4),
                        Text(
                          download.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, download, ref, context),
                    itemBuilder: (context) => _buildMenuItems(download),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading downloads: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(downloadManagerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case DownloadStatus.downloading:
        return const Icon(Icons.downloading, color: Colors.blue);
      case DownloadStatus.failed:
        return const Icon(Icons.error, color: Colors.red);
      case DownloadStatus.paused:
        return const Icon(Icons.pause_circle, color: Colors.orange);
      case DownloadStatus.queued:
        return const Icon(Icons.queue, color: Colors.grey);
      case DownloadStatus.canceled:
        return const Icon(Icons.cancel, color: Colors.grey);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Downloads'),
        content: const Text('This will remove all completed downloads from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(downloadManagerProvider.notifier).clearCompletedDownloads();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completed downloads cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Download download, WidgetRef ref, BuildContext context) {
    final manager = ref.read(downloadManagerProvider.notifier);
    
    switch (action) {
      case 'retry':
        manager.retryDownload(download.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retrying download...')),
        );
        break;
      case 'pause':
        manager.pauseDownload(download.id);
        break;
      case 'resume':
        manager.resumeDownload(download.id);
        break;
      case 'cancel':
        manager.cancelDownload(download.id);
        break;
      case 'remove':
        manager.removeDownload(download.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download removed')),
        );
        break;
      case 'open':
        if (download.outputPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File: ${download.outputPath}')),
          );
        }
        break;
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems(Download download) {
    switch (download.status) {
      case DownloadStatus.downloading:
      case DownloadStatus.queued:
        return [
          const PopupMenuItem(
            value: 'pause',
            child: Row(
              children: [
                Icon(Icons.pause),
                SizedBox(width: 8),
                Text('Pause'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                Icon(Icons.stop),
                SizedBox(width: 8),
                Text('Cancel'),
              ],
            ),
          ),
        ];
      case DownloadStatus.paused:
        return [
          const PopupMenuItem(
            value: 'resume',
            child: Row(
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8),
                Text('Resume'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                Icon(Icons.stop),
                SizedBox(width: 8),
                Text('Cancel'),
              ],
            ),
          ),
        ];
      case DownloadStatus.completed:
        return [
          const PopupMenuItem(
            value: 'open',
            child: Row(
              children: [
                Icon(Icons.open_in_new),
                SizedBox(width: 8),
                Text('Open'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.delete_outline),
                SizedBox(width: 8),
                Text('Remove'),
              ],
            ),
          ),
        ];
      case DownloadStatus.failed:
        return [
          const PopupMenuItem(
            value: 'retry',
            child: Row(
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 8),
                Text('Retry'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.delete_outline),
                SizedBox(width: 8),
                Text('Remove'),
              ],
            ),
          ),
        ];
      case DownloadStatus.canceled:
        return [
          const PopupMenuItem(
            value: 'retry',
            child: Row(
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 8),
                Text('Retry'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.delete_outline),
                SizedBox(width: 8),
                Text('Remove'),
              ],
            ),
          ),
        ];
    }
  }
}