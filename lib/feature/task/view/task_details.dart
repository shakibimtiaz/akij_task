import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';
import '../model/task_model.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel task;
  final TaskController controller = Get.find<TaskController>();

  TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 8),
            Text("Category: ${task.category}"),
            const SizedBox(height: 8),
            Text("Due: ${task.dueDate.toLocal().toString().substring(0, 16)}"),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      TaskModel updated = TaskModel(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        category: task.category,
                        dueDate: task.dueDate,
                        status: task.status == "Pending"
                            ? "Completed"
                            : "Pending",
                      );
                      controller.updateTask(updated);
                      Get.back();
                    },
                    child: Text(
                      task.status == "Pending"
                          ? "Mark Completed"
                          : "Mark Pending",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      controller.deleteTask(task.id);
                      Get.back();
                    },
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
