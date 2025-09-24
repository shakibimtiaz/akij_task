import 'package:akij_task/feature/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarView extends StatelessWidget {
  BottomNavbarView({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.note_outlined),
      activeIcon: Icon(Icons.note, color: Colors.blue),
      label: 'Notes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check_box_outlined),
      activeIcon: Icon(Icons.check_box, color: Colors.blue),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.analytics_outlined),
      activeIcon: Icon(Icons.analytics, color: Colors.blue),
      label: 'Analytics',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person, color: Colors.blue),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: bottomItems,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
