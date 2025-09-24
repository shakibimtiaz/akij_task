import 'package:akij_task/feature/notes/controller/notes_controller.dart'
    show NotesController;
import 'package:akij_task/feature/notes/view/add_edit_note_view.dart'
    show AddEditNoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotesView extends StatelessWidget {
  NotesView({super.key});

  final NotesController controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: NotesSearch(controller));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => DropdownButton<String>(
              value: controller.selectedCategory.value,
              items: ['All', 'Work', 'Personal', 'Others']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.selectedCategory.value = value;
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredNotes.isEmpty) {
                return const Center(child: Text('No notes found'));
              }
              return ListView.builder(
                itemCount: controller.filteredNotes.length,
                itemBuilder: (context, index) {
                  var note = controller.filteredNotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(note['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['content'].length > 50
                                ? "${note['content'].substring(0, 50)}..."
                                : note['content'],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note['createdAt'] != null
                                ? DateFormat('MMMM dd, yyyy hh:mm a').format(
                                    (note['createdAt'] as Timestamp).toDate(),
                                  )
                                : '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteNote(note['id']),
                      ),
                      onTap: () {
                        Get.to(() => AddEditNoteView(note: note));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => AddEditNoteView()),
      ),
    );
  }
}

class NotesSearch extends SearchDelegate {
  final NotesController controller;
  NotesSearch(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        controller.searchText.value = '';
        showSuggestions(context);
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.notesList.where((note) {
      return note['title'].toLowerCase().contains(query.toLowerCase()) ||
          note['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var note = results[index];
        return ListTile(
          title: Text(note['title']),
          subtitle: Text(note['content']),
          onTap: () => Get.to(() => AddEditNoteView(note: note)),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = controller.notesList.where((note) {
      return note['title'].toLowerCase().contains(query.toLowerCase()) ||
          note['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var note = suggestions[index];
        return ListTile(
          title: Text(note['title']),
          subtitle: Text(note['content']),
          onTap: () => Get.to(() => AddEditNoteView(note: note)),
        );
      },
    );
  }
}
