import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> savePost(String userID, String text, String locationURL, String? profilePictureUrl, DateTime timestamp, String? imageUrl, int likes) async {
    await _db.collection('Post').add({
      'userID': userID,
      'text': text,
      'locationURL': locationURL,
      'profilePictureUrl': profilePictureUrl,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'likes': likes,
    });
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      String filePath = 'posts/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(filePath).putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Stream<List<DocumentSnapshot>> getPosts() {
    return _db.collection('Post').orderBy('timestamp', descending: true).snapshots().map((snapshot) => snapshot.docs);
  }

  Stream<List<DocumentSnapshot>> getUserPosts(String userID) {
    return _db.collection('Post').where('userID', isEqualTo: userID).orderBy('timestamp', descending: true).snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> deletePost(String postId) async {
    try {
      await _db.collection('Post').doc(postId).delete(); // Corrected collection name
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }
  Stream<List<DocumentSnapshot>> getComments(String postId) {
    return _db.collection('Comments')
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}

