import 'package:flutter/material.dart';
import '../../domain/entities/video_info.dart';

class VideoInfoCard extends StatelessWidget {
  final VideoInfo videoInfo;
  final VoidCallback? onDownload;

  const VideoInfoCard({
    super.key,
    required this.videoInfo,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (videoInfo.thumbnail != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      videoInfo.thumbnail!,
                      width: 120,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.play_circle_outline, size: 32),
                        );
                      },
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoInfo.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (videoInfo.uploader != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          videoInfo.uploader!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (videoInfo.duration != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatDuration(videoInfo.duration!),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Metadata
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (videoInfo.viewCount != null)
                  _buildChip(
                    context,
                    Icons.visibility,
                    '${_formatCount(videoInfo.viewCount!)} views',
                  ),
                if (videoInfo.likeCount != null)
                  _buildChip(
                    context,
                    Icons.thumb_up,
                    _formatCount(videoInfo.likeCount!),
                  ),
                if (videoInfo.uploadDate != null)
                  _buildChip(
                    context,
                    Icons.calendar_today,
                    _formatDate(videoInfo.uploadDate!),
                  ),
                _buildChip(
                  context,
                  Icons.video_library,
                  '${videoInfo.formats.length} formats',
                ),
              ],
            ),
            
            if (videoInfo.description != null && videoInfo.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                videoInfo.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download),
                label: const Text('Choose Format & Download'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years} year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Today';
    }
  }
}