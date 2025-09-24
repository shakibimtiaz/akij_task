import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_notifications/easy_notifications.dart'
    show EasyNotifications;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/task_model.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<TaskModel> tasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    EasyNotifications.init();
  }

  /// Fetch tasks for the logged-in user
  void fetchTasks() {
    String uid = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .listen((snapshot) {
          tasks.value = snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data()))
              .toList();
          scheduleUpcomingTasks();
        });
  }

  /// Add new task
  Future<void> addTask(
    String title,
    String description,
    String category,
    DateTime dueDate,
  ) async {
    try {
      EasyLoading.show(status: "Adding...");
      String uid = _auth.currentUser!.uid;
      String taskId = const Uuid().v4();

      TaskModel task = TaskModel(
        id: taskId,
        title: title,
        description: description,
        category: category,
        dueDate: dueDate,
        status: "Pending",
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .set(task.toMap());

      EasyLoading.showSuccess("Task Added");
      scheduleTaskNotification(task);
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Update task
  Future<void> updateTask(TaskModel task) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());

      EasyLoading.showSuccess("Task Updated");
      scheduleTaskNotification(task);
    } catch (e) {
      EasyLoading.showError("Error: $e");
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .delete();

      EasyLoading.showSuccess("Task Deleted");
    } catch (e) {
      EasyLoading.showError("Error: $e");
    }
  }

  void scheduleTaskNotification(TaskModel task) {
    final now = DateTime.now();
    final difference = task.dueDate.difference(now);

    if (difference.inMinutes > 0 && difference.inMinutes <= 60) {
      EasyNotifications.scheduleMessage(
        title: 'Upcoming Task: ${task.title}',
        body:
            'Due at ${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}',
        scheduledDate: task.dueDate,
      );
    }
  }

  /// Schedule notifications for all upcoming tasks within next hour
  void scheduleUpcomingTasks() {
    final now = DateTime.now();
    for (var task in tasks) {
      final difference = task.dueDate.difference(now);
      if (difference.inMinutes > 0 && difference.inMinutes <= 60) {
        scheduleTaskNotification(task);
      }
    }
  }
}
