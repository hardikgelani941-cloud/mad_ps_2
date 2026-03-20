import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  void fetchBooks() {
    _isLoading = true;
    notifyListeners();

    _firestore.collection('books').snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // If empty, add defaults
        _addDefaultBooks();
      } else {
        _books = snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList();
        _isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint("Firestore Error: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _addDefaultBooks() async {
    final defaultBooks = [
      Book(
        id: const Uuid().v4(),
        title: 'Mahabhart',
        author: 'Vyasa',
        isbn: '978-01',
        quantity: 5,
        imageUrl: 'assets/image/mahabhart.jpg',
      ),
      Book(
        id: const Uuid().v4(),
        title: 'Ramayan',
        author: 'Valmiki',
        isbn: '978-02',
        quantity: 3,
        imageUrl: 'assets/image/ramayan.jpg',
      ),
    ];
    
    for (var book in defaultBooks) {
      await addBook(book);
    }
    // No need to notify here, the snapshots listener will catch the addition
  }

  Future<void> addBook(Book book) async {
    try {
      await _firestore.collection('books').doc(book.id).set(book.toJson());
    } catch (e) {
      debugPrint("Add Book Error: $e");
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    await _firestore.collection('books').doc(updatedBook.id).update(updatedBook.toJson());
  }

  Future<void> deleteBook(String id) async {
    await _firestore.collection('books').doc(id).delete();
  }

  Future<void> toggleIssueStatus(String id) async {
    final index = _books.indexWhere((book) => book.id == id);
    if (index != -1) {
      final updatedStatus = !_books[index].isIssued;
      await _firestore.collection('books').doc(id).update({'isIssued': updatedStatus});
    }
  }
}
