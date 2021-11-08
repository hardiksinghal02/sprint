import 'package:flutter/material.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/widgets/task_widget.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  const TaskListWidget({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, index) => TaskWidget(task: tasks[index]),
        itemCount: tasks.length,
      ),
    );
  }
}
