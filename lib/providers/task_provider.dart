import 'package:flutter/cupertino.dart';
import 'package:sprint/utils/consts.dart';
import 'package:sprint/models/status_doc_model.dart';
import 'package:sprint/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider with ChangeNotifier {
  late List<Task> tasks;
  late StatusDoc status;
  late DocumentReference<Map<String, dynamic>> userDocRef;

  void setUserReference(final String uid) {
    userDocRef = FirebaseFirestore.instance
        .collection(Constants.userCollection)
        .doc(uid);
  }

  Future<void> addTask(final String name, final int points) async {
    await userDocRef
        .collection(Constants.taskCollection)
        .add({
          Constants.taskName: name,
          Constants.taskPoints: points,
        })
        .then((ref) async => {
              await ref.get().then((doc) {
                tasks.add(Task(
                    id: doc.id,
                    name: doc.get(Constants.taskName),
                    points: doc.get(Constants.taskPoints)));
                status.incomplete.add(doc.id);
              }).catchError((e) =>
                  print("Error occured while adding task : " + e.toString()))
            })
        .catchError((error) => print(error));
  }

  Future<void> setTasks() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    tasks = [];
    return await userDocRef
        .collection(Constants.taskCollection)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        tasks.add(Task(
            id: doc.id,
            name: doc.get(Constants.taskName),
            points: doc.get(Constants.taskPoints)));
      }
    }).catchError((e) => print("Error fetching in tasks " + e.toString()));
  }

  List<Task> getTasks() {
    return [...tasks];
  }

  Future<void> markTaskComplete(
      String taskId, int points, String dateId) async {
    StatusDoc currentStatus;

    return await getStatus(dateId).then((value) async {
      if (value == null) {
        List<String> incomplete = [];

        for (Task t in tasks) {
          incomplete.add(t.id);
        }

        currentStatus = StatusDoc(
            completed: [taskId],
            incomplete: [...incomplete],
            dailyScore: points);
      } else {
        currentStatus = StatusDoc(
            completed: [...value.completed, taskId],
            incomplete: [...value.incomplete],
            dailyScore: (value.dailyScore + points));
      }
      currentStatus.incomplete.remove(taskId);
      await userDocRef.collection(Constants.statusCollection).doc(dateId).set({
        Constants.completed: currentStatus.completed,
        Constants.incomplete: currentStatus.incomplete,
        Constants.dailyScore: currentStatus.dailyScore
      }).then((value) {
        print("Status updated");
        status = currentStatus;
      });
    }).catchError((e) =>
        print("Error occured while marking complete a task : " + e.toString()));
  }

  Future<void> markTaskIncomplete(
      String taskId, int points, String dateId) async {
    return await getStatus(dateId).then((value) async {
      if (value == null) {
        print("I shouldn't have run");
      } else {
        StatusDoc currentStatus = StatusDoc(
            completed: [...value.completed],
            incomplete: [...value.incomplete, taskId],
            dailyScore: (value.dailyScore - points));

        currentStatus.completed.remove(taskId);
        await userDocRef
            .collection(Constants.statusCollection)
            .doc(dateId)
            .set({
          Constants.completed: currentStatus.completed,
          Constants.incomplete: currentStatus.incomplete,
          Constants.dailyScore: currentStatus.dailyScore
        });
        print("Status updated");
        status = currentStatus;
      }
    }).catchError((e) =>
        print("Error occured while marking complete a task : " + e.toString()));
  }

  Future<StatusDoc?> getStatus(String dateId) async {
    return await userDocRef
        .collection(Constants.statusCollection)
        .doc(dateId)
        .get()
        .then((value) {
      if (!value.exists) return null;
      List<String> completed = [];
      List<String> incomplete = [];
      int dailyScore = value.get(Constants.dailyScore);

      for (var element in List.from(value.get(Constants.completed))) {
        completed.add(element.toString());
      }
      for (var element in List.from(value.get(Constants.incomplete))) {
        incomplete.add(element.toString());
      }

      return StatusDoc(
          completed: completed, incomplete: incomplete, dailyScore: dailyScore);
    }).catchError((e) {
      print("Error getting statusDoc -> " + e.toString());
    });
  }

  Future<void> setStatus(String dateId) async {
    StatusDoc currentStatus;

    return await getStatus(dateId).then((value) {
      if (value == null) {
        List<String> incomplete = [];

        for (Task t in tasks) {
          incomplete.add(t.id);
        }

        currentStatus = StatusDoc(
            completed: [], incomplete: [...incomplete], dailyScore: 0);

        userDocRef.collection(Constants.statusCollection).doc(dateId).set({
          Constants.completed: currentStatus.completed,
          Constants.incomplete: currentStatus.incomplete,
          Constants.dailyScore: currentStatus.dailyScore,
        }).then((value) {
          status = currentStatus;
        }).catchError((e) => print(
            "Error occured while setting initital statusDoc : " +
                e.toString()));
      } else {
        status = value;
      }
    }).catchError(
        (e) => print("Error occured while setting status : " + e.toString()));
  }

  StatusDoc getCurrentStatusDoc() {
    return StatusDoc(
      completed: status.completed,
      incomplete: status.incomplete,
      dailyScore: status.dailyScore,
    );
  }
}
