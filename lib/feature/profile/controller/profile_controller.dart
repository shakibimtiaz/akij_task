import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var email = ''.obs;
  var name = ''.obs;
  var userId = ''.obs;
  var token = ''.obs;

  /// Fetch the authenticated user's profile
  Future<void> fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "No authenticated user found");
        return;
      }

      String uid = user.uid;

      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        email.value = data['email'] ?? '';
        name.value = data['name'] ?? '';
        userId.value = data['userID'] ?? '';
        token.value = data['token'] ?? '';
      } else {
        Get.snackbar("Error", "User profile not found in Firestore");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile");
      print("Profile fetch error: $e");
    }
  }
}
