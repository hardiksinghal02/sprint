import 'package:flutter/material.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/widgets/task_widget.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TaskWidget(
                  task: Task(
                      id: "dfsg",
                      name: "Study",
                      isCompleted: false,
                      points: 10),
                ),
                TaskWidget(
                  task: Task(
                      id: "dfsg",
                      name: "Study",
                      isCompleted: false,
                      points: 10),
                ),
                TaskWidget(
                  task: Task(
                      id: "dfsg",
                      name: "Study",
                      isCompleted: false,
                      points: 10),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
