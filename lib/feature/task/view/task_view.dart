import 'package:akij_task/feature/task/view/task_add_edit_view.dart'
    show TaskAddEditView;
import 'package:akij_task/feature/task/view/task_details.dart'
    show TaskDetailView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';

class TasksView extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return const Center(child: Text("No tasks available"));
        }
        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "${task.description}\nDue: ${task.dueDate.toLocal().toString().substring(0, 16)}",
                ),
                isThreeLine: true,
                trailing: Icon(
                  task.status == "Completed"
                      ? Icons.check_circle
                      : Icons.pending_actions,
                  color: task.status == "Completed" ? Colors.green : Colors.red,
                ),
                onTap: () => Get.to(() => TaskDetailView(task: task)),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Get.to(TaskAddEditView()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
