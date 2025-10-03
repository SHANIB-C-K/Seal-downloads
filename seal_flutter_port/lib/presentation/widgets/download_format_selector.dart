import 'package:flutter/material.dart';
import '../../domain/entities/download.dart';
import '../../domain/entities/video_info.dart';

class DownloadFormatSelector extends StatefulWidget {
  final VideoInfo videoInfo;
  final Function(DownloadFormat) onFormatSelected;
  final VoidCallback? onCancel;

  const DownloadFormatSelector({
    super.key,
    required this.videoInfo,
    required this.onFormatSelected,
    this.onCancel,
  });

  @override
  State<DownloadFormatSelector> createState() => _DownloadFormatSelectorState();
}

class _DownloadFormatSelectorState extends State<DownloadFormatSelector> {
  DownloadFormat? selectedFormat;

  @override
  void initState() {
    super.initState();
    selectedFormat = DownloadFormat.mp4_1080p; // Default selection
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Download Format'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video info summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (widget.videoInfo.thumbnail != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        widget.videoInfo.thumbnail!,
                        width: 60,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.play_circle_outline, size: 16),
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
                          widget.videoInfo.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.videoInfo.uploader != null)
                          Text(
                            widget.videoInfo.uploader!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Video formats section
            Text(
              'Video Formats',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            ...DownloadFormat.values
                .where((format) => format.isVideo)
                .map((format) => _buildFormatTile(format)),
            
            const SizedBox(height: 16),
            
            // Audio formats section
            Text(
              'Audio Formats',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            ...DownloadFormat.values
                .where((format) => format.isAudio)
                .map((format) => _buildFormatTile(format)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: selectedFormat != null
              ? () => widget.onFormatSelected(selectedFormat!)
              : null,
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        ),
      ],
    );
  }

  Widget _buildFormatTile(DownloadFormat format) {
    final isSelected = selectedFormat == format;
    
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: RadioListTile<DownloadFormat>(
        value: format,
        groupValue: selectedFormat,
        onChanged: (value) {
          setState(() {
            selectedFormat = value;
          });
        },
        title: Text(
          format.displayName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(_getFormatDescription(format)),
        secondary: Icon(
          format.isVideo ? Icons.videocam : Icons.audiotrack,
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  String _getFormatDescription(DownloadFormat format) {
    switch (format) {
      case DownloadFormat.mp4_720p:
        return 'HD quality, good balance of size and quality';
      case DownloadFormat.mp4_1080p:
        return 'Full HD quality, larger file size';
      case DownloadFormat.mp4_best:
        return 'Highest available quality';
      case DownloadFormat.mp3_128k:
        return 'Standard audio quality, smaller size';
      case DownloadFormat.mp3_320k:
        return 'High audio quality, larger size';
      case DownloadFormat.m4a_best:
        return 'Best audio quality available';
    }
  }
}