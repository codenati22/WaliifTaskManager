import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/manager/settingsProvider.dart';
import 'package:task_manager_app/pages/mainScaffold.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _SettingsState();
}

class _SettingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    void _toggleDarkMode(bool? value) {
      settingsProvider.toggleDarkMode(value ?? false);
    }

    void _showAboutUsDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('About Us'),
          content: const Text('Flutter developer Natanael Girma. Hire me!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }

    return MainScaffold(
      appBarTitle: 'Settings',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: settingsProvider.isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('About Us'),
                trailing: const Icon(Icons.info_outline),
                onTap: _showAboutUsDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
