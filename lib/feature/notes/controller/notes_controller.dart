import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NotesController extends GetxController {
  var notesList = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;
  var selectedCategory = 'All'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  String get userId => _auth.currentUser!.uid;

  void fetchNotes() {
    _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          notesList.value = snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  void addNote(String title, String content, String category) async {
    if (title.isEmpty || content.isEmpty) {
      EasyLoading.showError("Please fill all fields");
      return;
    }
    try {
      await _firestore.collection('notes').add({
        'title': title,
        'content': content,
        'category': category,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      EasyLoading.showSuccess("Note added successfully");
      Get.back();
    } catch (e) {
      EasyLoading.showError("Failed to add note");
    }
  }

  void editNote(
    String id,
    String title,
    String content,
    String category,
  ) async {
    if (title.isEmpty || content.isEmpty) {
      EasyLoading.showError("Please fill all fields");
      return;
    }
    try {
      await _firestore.collection('notes').doc(id).update({
        'title': title,
        'content': content,
        'category': category,
      });
      EasyLoading.showSuccess("Note updated successfully");
      Get.back();
    } catch (e) {
      EasyLoading.showError("Failed to update note");
    }
  }

  void deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      EasyLoading.showSuccess("Note deleted successfully");
    } catch (e) {
      EasyLoading.showError("Failed to delete note");
    }
  }

  List<Map<String, dynamic>> get filteredNotes {
    var list = notesList;
    if (selectedCategory.value != 'All') {
      list = list
          .where((note) => note['category'] == selectedCategory.value)
          .toList()
          .obs;
    }
    if (searchText.value.isNotEmpty) {
      list = list
          .where(
            (note) =>
                note['title'].toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ) ||
                note['content'].toLowerCase().contains(
                  searchText.value.toLowerCase(),
                ),
          )
          .toList()
          .obs;
    }
    return list;
  }
}
