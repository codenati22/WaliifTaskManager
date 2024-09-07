import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager_app/manager/settingsProvider.dart';
import 'package:task_manager_app/manager/taskProvider.dart';
import 'package:task_manager_app/pages/form/taskForm.dart';
import 'package:task_manager_app/pages/form/updateForm.dart';
import 'package:task_manager_app/pages/mainScaffold.dart';
import '../service/DailyQuotes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String> dailyQuote;

  @override
  void initState() {
    super.initState();
    dailyQuote = DailyQuotes().fetchQuote();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    void _showSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return MainScaffold(
      appBarTitle: 'home',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: dailyQuote,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerPlaceholder(screenWidth);
                } else if (snapshot.hasError) {
                  return const Text('Error fetching quote');
                } else {
                  return _buildQuoteCard(
                      screenWidth, snapshot.data ?? 'Stay positive!');
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text('Completed', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Text('Incomplete', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  final tasks = taskProvider.tasks;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Task'),
                                content: Text(
                                    'Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await taskProvider.deleteTask(task.id!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Task deleted')),
                                      );
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return false;
                        },
                        child: Card(
                          color: task.status == 'Completed'
                              ? Colors.green[100]
                              : Colors.red[100],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(
                                '${task.description}\nDue: ${task.dueDate}'),
                            trailing: Text(task.status),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => TaskFormDialog(
                                  task: task,
                                  onUpdate: (updatedTask) async {
                                    await taskProvider.updateTask(updatedTask);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Task updated')),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskFormDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildShimmerPlaceholder(double screenWidth) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: screenWidth * 0.5,
                height: 24,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: screenWidth * 0.8,
                height: 16,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: screenWidth * 0.6,
                height: 16,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(double screenWidth, String quote) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Inspiration',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: SettingsProvider().isDarkMode
                    ? Color.fromARGB(255, 11, 28, 41)
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quote,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontStyle: FontStyle.italic,
                color: SettingsProvider().isDarkMode
                    ? Color.fromARGB(255, 11, 28, 41)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TaskForm(),
        );
      },
    );
  }
}
