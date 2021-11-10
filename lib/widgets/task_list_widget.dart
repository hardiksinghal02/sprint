import 'package:flutter/material.dart';
import 'package:sprint/models/status_doc_model.dart';
import 'package:sprint/models/task_model.dart';
import 'package:sprint/widgets/task_widget.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  final StatusDoc statusDoc;
  final Function onUpdate;

  TaskListWidget(
      {Key? key,
      required this.tasks,
      required this.statusDoc,
      required this.onUpdate})
      : super(key: key);

  int taskIndex = 0;

  Task getTaskWithId(String tid) {
    for (Task t in tasks) {
      if (t.id == tid) return t;
    }
    return tasks[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (statusDoc.incomplete.length != 0)
                    Text("Pending (" +
                        (statusDoc.incomplete.length.toString() + ")"))
                ],
              );
            } else if (index == (statusDoc.incomplete.length + 1)) {
              taskIndex = 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (statusDoc.completed.length != 0)
                    Text("Completed (" +
                        (statusDoc.completed.length.toString()) +
                        ")")
                ],
              );
            } else if (index <= statusDoc.incomplete.length) {
              return TaskWidget(
                task: getTaskWithId(
                  statusDoc.incomplete[taskIndex++],
                ),
                isCompleted: false,
                onUpdate: onUpdate,
              );
            } else if (index > (statusDoc.incomplete.length + 1)) {
              return TaskWidget(
                task: getTaskWithId(statusDoc.completed[taskIndex++]),
                isCompleted: true,
                onUpdate: onUpdate,
              );
            }

            return TaskWidget(
              task: tasks[index - 1],
              isCompleted: false,
              onUpdate: onUpdate,
            );
          },
          itemCount: tasks.length + 2,
        ),
      ),
    );
  }
}
