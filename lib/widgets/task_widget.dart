import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/providers/task_provider.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  TaskWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    void markTaskAsCompleted(DateTime date) {
      String dateId = DateFormat('yyyyMMdd').format(date);
      // print(dateId);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.markTaskComplete(task.id, task.points, dateId).then((value) {
        final snackBar = SnackBar(
          content: const Text('Task marked as completed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          print("Completed");
          markTaskAsCompleted(DateTime.now());
        } else if (direction == DismissDirection.endToStart)
          print("Can't Complete");
      },
      background: Container(color: Colors.green),
      secondaryBackground: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Text(task.name),
      ),
    );
  }
}
