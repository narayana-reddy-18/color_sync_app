import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Must come BEFORE any class

class StorageService {
  static const _keyColorList = 'color_list';

  static Future<void> saveColors(List<String> colorHexCodes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyColorList, colorHexCodes);
  }

  static Future<List<String>> loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyColorList) ?? [];
  }

  static Future<void> clearColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyColorList);
  }

  // 🔄 Sync local color list to Firebase
  static Future<void> syncColorsWithFirebase() async {
    final colors = await loadColors(); // THIS LINE WAS WRONG EARLIER
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('colors').doc('user1').set({
      'colorCodes': colors,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
