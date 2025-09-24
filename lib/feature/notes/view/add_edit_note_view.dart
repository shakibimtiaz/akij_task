import 'package:akij_task/core/utils/style/get_text_style.dart';
import 'package:akij_task/core/utils/widgets/custom_button.dart';
import 'package:akij_task/feature/notes/controller/notes_controller.dart'
    show NotesController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditNoteView extends StatelessWidget {
  final Map<String, dynamic>? note;
  AddEditNoteView({super.key, this.note});

  final NotesController controller = Get.find<NotesController>();
  final _formKey = GlobalKey<FormState>();
  final categories = ['Work', 'Personal', 'Others'];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (note != null) {
        controller.titleController.text = note!['title'];
        controller.contentController.text = note!['content'];
        controller.selectedCategory.value = note!['category'];
      } else {
        controller.titleController.clear();
        controller.contentController.clear();
        controller.selectedCategory.value = categories.first;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          note == null ? 'Add Note' : 'Edit Note',
          style: getTextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: controller.contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.selectedCategory.value,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedCategory.value = value;
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              //     child: const Text('Save'),
              //     onPressed: () {
              //       if (note != null) {
              //         controller.editNote(
              //           note!['id'],
              //           controller.titleController.text,
              //           controller.contentController.text,
              //           controller.selectedCategory.value,
              //         );
              //       } else {
              //         controller.addNote(
              //           controller.titleController.text,
              //           controller.contentController.text,
              //           controller.selectedCategory.value,
              //         );
              //       }
              //     },
              //   ),
              // ),
              CustomButton(
                text: "Save",
                onPressed: () {
                  if (note != null) {
                    controller.editNote(
                      note!['id'],
                      controller.titleController.text,
                      controller.contentController.text,
                      controller.selectedCategory.value,
                    );
                  } else {
                    controller.addNote(
                      controller.titleController.text,
                      controller.contentController.text,
                      controller.selectedCategory.value,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
