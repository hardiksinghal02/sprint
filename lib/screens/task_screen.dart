import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/providers/task_provider.dart';
import 'package:sprint/widgets/new_task_widget.dart';
import 'package:sprint/widgets/task_list_widget.dart';
import 'package:sprint/widgets/task_widget.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    tasks = taskProvider.getTasks();

    void addTask() {
      showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return NewTaskWidget(
              updateTask: () {
                setState(() {
                  tasks = taskProvider.getTasks();
                });
              },
            );
          });
    }

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        TaskListWidget(tasks: tasks),
        FloatingActionButton(
          onPressed: addTask,
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
