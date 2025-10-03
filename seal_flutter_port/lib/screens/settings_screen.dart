import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // General Section
          _buildSectionHeader(context, 'General'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Download Directory'),
                  subtitle: const Text('/storage/emulated/0/Download'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Directory selection not available in web demo'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.video_settings),
                  title: const Text('Default Video Quality'),
                  subtitle: const Text('1080p'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showQualityDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.audiotrack),
                  title: const Text('Audio Format'),
                  subtitle: const Text('MP3'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAudioFormatDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  subtitle: const Text('System'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.contrast),
                  title: const Text('High Contrast'),
                  subtitle: const Text('Improve accessibility'),
                  value: false,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? 'High contrast enabled' : 'High contrast disabled'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Network Section
          _buildSectionHeader(context, 'Network'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.wifi_off),
                  title: const Text('Download on WiFi Only'),
                  subtitle: const Text('Save mobile data'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? 'WiFi only enabled' : 'WiFi only disabled'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.speed),
                  title: const Text('Concurrent Downloads'),
                  subtitle: const Text('3'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showConcurrentDownloadsDialog(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.cookie),
                  title: const Text('Use Cookies'),
                  subtitle: const Text('For authenticated content'),
                  value: false,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? 'Cookies enabled' : 'Cookies disabled'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About Seal'),
                  subtitle: const Text('Version 2.0.0-alpha.5'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Check for Updates'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You are using the latest version')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Report Bug'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening GitHub issues page...')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Section
          _buildSectionHeader(context, 'Data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.clear_all),
                  title: const Text('Clear Download History'),
                  onTap: () => _showClearHistoryDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export Settings'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings export not available in web demo')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Default Video Quality'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Best Available'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('1080p'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('720p'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('480p'),
          ),
        ],
      ),
    );
  }

  void _showAudioFormatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Audio Format'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('MP3'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('M4A'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('WAV'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('FLAC'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('System'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Light'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Dark'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Language'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Español'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Français'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Deutsch'),
          ),
        ],
      ),
    );
  }

  void _showConcurrentDownloadsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Concurrent Downloads'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('1'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('2'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('3'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('5'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Download History'),
        content: const Text('This will remove all download history but not the downloaded files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download history cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Seal Flutter',
      applicationVersion: '2.0.0-alpha.5',
      applicationLegalese: '© 2024 Seal Development Team',
      children: [
        const SizedBox(height: 16),
        const Text(
          'This is a Flutter demonstration of the Seal video downloader app. '
          'The original Android app uses yt-dlp for downloading videos from '
          'YouTube and 1000+ other platforms.',
        ),
      ],
    );
  }
}