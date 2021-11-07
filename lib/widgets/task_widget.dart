import 'package:flutter/material.dart';
import 'package:sprint/models/task_model.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  TaskWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      onDismissed: (direction) => {
        if (direction == DismissDirection.startToEnd)
          print("Completed")
        else if (direction == DismissDirection.endToStart)
          print("Can't Complete")
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text(task.name),
      ),
    );
  }
}
