import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/providers/task_provider.dart';
import 'package:sprint/utils/date_util.dart';

class TaskWidget extends StatelessWidget {
  final Function onUpdate;
  final Task task;
  final bool isCompleted;

  TaskWidget(
      {required this.task, required this.isCompleted, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    void markTaskAsCompleted(DateTime date) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (isCompleted) {
        taskProvider
            .markTaskIncomplete(
                task.id, task.points, DateUtil.getDateId(DateTime.now()))
            .then((_) {
          final snackBar = SnackBar(
            content: const Text('Task marked as pending'),
            duration: Duration(milliseconds: 500),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          print("Calling onUpdate");
          onUpdate();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        taskProvider
            .markTaskComplete(
                task.id, task.points, DateUtil.getDateId(DateTime.now()))
            .then((_) {
          final snackBar = SnackBar(
            content: const Text('Task marked as completed'),
            duration: Duration(milliseconds: 500),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          print("Calling onUpdate");
          onUpdate();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        markTaskAsCompleted(DateTime.now());
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
