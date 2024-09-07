import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final String appBarTitle;

  const MainScaffold({
    super.key,
    required this.child,
    this.floatingActionButton,
    this.appBarTitle = 'Task Manager',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Task Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/Home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Completed Tasks'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/CompletedTask');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
