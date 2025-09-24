import 'package:akij_task/feature/task/model/task_model.dart' show TaskModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxInt totalTasks = 0.obs;
  RxInt completedTasks = 0.obs;
  RxInt pendingTasks = 0.obs;

  RxMap<String, int> categoryCounts = <String, int>{}.obs;
  RxMap<String, int> completedOverTime = <String, int>{}.obs; // date → count

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  void fetchAnalytics() {
    String uid = _auth.currentUser!.uid;

    _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
          final tasks = snapshot.docs
              .map((d) => TaskModel.fromMap(d.data()))
              .toList();

          totalTasks.value = tasks.length;
          completedTasks.value = tasks
              .where((t) => t.status == "Completed")
              .length;
          pendingTasks.value = tasks.where((t) => t.status == "Pending").length;

          // category counts
          final Map<String, int> catMap = {};
          for (var task in tasks) {
            catMap[task.category] = (catMap[task.category] ?? 0) + 1;
          }
          categoryCounts.value = catMap;

          // completed over time (by date only)
          final Map<String, int> timeMap = {};
          for (var task in tasks.where((t) => t.status == "Completed")) {
            final dateStr =
                "${task.dueDate.year}-${task.dueDate.month}-${task.dueDate.day}";
            timeMap[dateStr] = (timeMap[dateStr] ?? 0) + 1;
          }
          completedOverTime.value = timeMap;
        });
  }
}
