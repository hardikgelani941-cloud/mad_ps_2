class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final int quantity;
  final bool isIssued;
  final String? imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.quantity,
    this.isIssued = false,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'quantity': quantity,
      'isIssued': isIssued,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      quantity: json['quantity'],
      isIssued: json['isIssued'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  Book copyWith({
    String? title,
    String? author,
    String? isbn,
    int? quantity,
    bool? isIssued,
    String? imageUrl,
  }) {
    return Book(
      id: this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      quantity: quantity ?? this.quantity,
      isIssued: isIssued ?? this.isIssued,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
