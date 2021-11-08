import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/providers/task_provider.dart';

class NewTaskWidget extends StatelessWidget {
  final Function() updateTask;
  TextEditingController controller = TextEditingController();

  NewTaskWidget({required this.updateTask});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    addTask() {
      taskProvider.addTask(controller.text, 10).then((_) {
        updateTask();
        Navigator.of(context).pop();
      });
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
            ElevatedButton(
              onPressed: addTask,
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
