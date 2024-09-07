import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/manager/taskProvider.dart';
import 'package:task_manager_app/pages/mainScaffold.dart';

class CompletedTask extends StatefulWidget {
  const CompletedTask({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    final completedTasks =
        tasks.where((task) => task.status == 'Completed').toList();
    final uncompletedTasks =
        tasks.where((task) => task.status == 'Incomplete').toList();

    final totalTasks = tasks.length;
    final completedPercentage = (completedTasks.length / totalTasks) * 100;
    final uncompletedPercentage = (uncompletedTasks.length / totalTasks) * 100;

    return MainScaffold(
      appBarTitle: 'Completed task',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completedPercentage,
                      color: Colors.green,
                      title: '${completedPercentage.toStringAsFixed(1)}%',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: uncompletedPercentage,
                      color: Colors.red,
                      title: '${uncompletedPercentage.toStringAsFixed(1)}%',
                      radius: 50,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            SizedBox(width: 6),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text('Completed Task', style: TextStyle(fontSize: 13)),
                SizedBox(width: 8),
                Icon(Icons.circle, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text('Incomplete Task', style: TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Completed Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  return Card(
                    color: Colors.green[100],
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                          '${task.description ?? ''}\nDue Date: ${task.dueDate.toLocal()}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
