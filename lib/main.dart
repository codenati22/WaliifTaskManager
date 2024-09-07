import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/manager/notificationManager.dart';
import 'package:task_manager_app/manager/settingsProvider.dart';
import 'package:task_manager_app/manager/taskProvider.dart';
import 'package:task_manager_app/pages/completedTask.dart';
import 'package:task_manager_app/pages/home.dart';
import 'package:task_manager_app/pages/intro.dart';
import 'package:task_manager_app/pages/settings.dart';
import 'package:task_manager_app/theme/darkTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationManager.initialize();
  } catch (e) {
    print('Error initializing notifications: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            theme: settingsProvider.isDarkMode ? darkTheme : ThemeData.light(),
            home: const intro(),
            routes: {
              '/Home': (context) => const Home(),
              '/CompletedTask': (context) => const CompletedTask(),
              '/settings': (context) => const settings(),
            },
          );
        },
      ),
    );
  }
}
