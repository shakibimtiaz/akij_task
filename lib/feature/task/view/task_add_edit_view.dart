import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';

class TaskAddEditView extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final categoryController = TextEditingController();

  final Rx<DateTime> selectedDateTime = DateTime.now().obs;

  TaskAddEditView({super.key});

  Future<void> _pickDateTime(BuildContext context) async {
    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick Time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
      );

      if (pickedTime != null) {
        final combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedDateTime.value = combined;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"), backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Category"),
            ),
            SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Due: ${selectedDateTime.value.toLocal().toString().substring(0, 16)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => _pickDateTime(context),
                    child: Text("Pick Date & Time"),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                controller.addTask(
                  titleController.text,
                  descController.text,
                  categoryController.text,
                  selectedDateTime.value,
                );
                Get.back();
              },
              child: const Text(
                "Save Task",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
