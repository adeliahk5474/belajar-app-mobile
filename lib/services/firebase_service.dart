import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  static Future<String?> uploadImage(File file, {String? folder}) async {
    try {
      final ext = file.path.split('.').last;
      final name = const Uuid().v4();
      final ref = FirebaseStorage.instance
          .ref()
          .child(folder ?? 'images')
          .child('$name.$ext');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static Future<void> deleteImageByUrl(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print('Delete error: $e');
    }
  }
}
