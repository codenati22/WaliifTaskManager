import 'package:flutter/material.dart';
import 'package:task_manager_app/model/task.dart';

import '../../manager/notificationManager.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onUpdate;

  const TaskFormDialog({Key? key, this.task, required this.onUpdate})
      : super(key: key);

  @override
  _TaskFormDialogState createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _status = 'Incomplete';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _status = widget.task!.status;
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenHeight = mediaQuery.size.height;
    var screenWidth = mediaQuery.size.width;

    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              Row(
                children: [
                  Text(
                      'Due Date: ${_dueDate?.toLocal().toString().split(' ')[0] ?? 'Not set'}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDueDate,
                  ),
                ],
              ),
              DropdownButton<String>(
                value: _status,
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: <String>['Incomplete', 'Completed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final updatedTask = Task(
              id: widget.task?.id,
              title: _titleController.text,
              description: _descriptionController.text,
              dueDate: _dueDate ?? DateTime.now(),
              status: _status,
            );

            try {
              widget.onUpdate(updatedTask);
              await NotificationManager.scheduleNotification(
                updatedTask.dueDate,
                updatedTask.id?.toString() ?? '0', // Handle null ID safely
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task Updated!'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating task: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update task. Please try again.'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Text(widget.task == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
