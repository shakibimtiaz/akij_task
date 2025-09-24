import 'package:akij_task/feature/analytics/view/analytics_view.dart'
    show AnalyticsView;
import 'package:akij_task/feature/notes/view/notes_view.dart' show NotesView;
import 'package:akij_task/feature/profile/view/profile_view.dart'
    show ProfileView;
import 'package:akij_task/feature/task/view/task_view.dart' show TasksView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var selectedIndex = 0.obs;

  // Update selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> screens = [
    NotesView(),
    TasksView(),
    AnalyticsView(),
    ProfileView(),
  ];
}
