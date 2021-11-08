import 'package:flutter/cupertino.dart';
import 'package:sprint/models/status_doc_model.dart';
import 'package:sprint/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider with ChangeNotifier {
  late List<Task> tasks;
  late DocumentReference<Map<String, dynamic>> userDocRef;

  void setUserReference(final String uid) {
    userDocRef = FirebaseFirestore.instance.collection("Users").doc(uid);
  }

  Future<void> addTask(final String name, final int points) async {
    await userDocRef
        .collection("Tasks")
        .add({
          "name": name,
          "points": points,
        })
        .then((ref) async => {
              await ref.get().then((doc) {
                tasks.add(Task(
                    id: doc.id,
                    name: doc.get("name"),
                    points: doc.get("points")));
              }).catchError((e) => print(e))
            })
        .catchError((error) => print(error));
  }

  Future<void> setTasks() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    tasks = [];
    return await userDocRef.collection("Tasks").get().then((value) {
      for (var doc in value.docs) {
        tasks.add(
            Task(id: doc.id, name: doc.get("name"), points: doc.get("points")));
      }
    }).catchError((e) => print("Error fetching in tasks" + e.toString()));
  }

  List<Task> getTasks() {
    return [...tasks];
  }

  Future<StatusDoc> markTaskComplete(
      String taskId, int points, String dateId) async {
    StatusDoc currentStatus;

    return await userDocRef.collection("Status").doc(dateId).get().then(
        (value) {
      if (value.exists) {
        List<String> completed = [];
        List<String> incomplete = [];

        for (var element in List.from(value.get("completed"))) {
          completed.add(element.toString());
        }
        for (var element in List.from(value.get("incomplete"))) {
          incomplete.add(element.toString());
        }

        int currentPoints = value.get("dailyScore");
        print("StatusDoc found");
        currentStatus = StatusDoc(
            completed: [...completed, taskId],
            incomplete: incomplete,
            dailyScore: currentPoints + points);
      } else {
        print("No statusDoc were found");
        currentStatus =
            StatusDoc(completed: [taskId], incomplete: [], dailyScore: points);
      }
      return currentStatus;
    }).then((value) async {
      await userDocRef.collection("Status").doc(dateId).set({
        "completed": value.completed,
        "incomplete": value.incomplete,
        "dailyScore": value.dailyScore
      });
      return value;
    }).catchError((e) =>
        print("Error occured while marking complete a task : " + e.toString()));
  }
}
