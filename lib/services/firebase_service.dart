import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication using Popup (Best for Web)
  Future<User?> signInWithGoogle() async {
    try {
      // Create a Google provider instance
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Trigger the sign-in popup
      final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore Book CRUD
  Stream<QuerySnapshot> getBooksStream() {
    return _firestore.collection('books').snapshots();
  }

  Future<void> addBook(Map<String, dynamic> bookData) async {
    await _firestore.collection('books').doc(bookData['id']).set(bookData);
  }

  Future<void> updateBook(Map<String, dynamic> bookData) async {
    await _firestore.collection('books').doc(bookData['id']).update(bookData);
  }

  Future<void> deleteBook(String id) async {
    await _firestore.collection('books').doc(id).delete();
  }
}
