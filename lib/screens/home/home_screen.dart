import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../add_edit_book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> cardColors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
    Colors.pink.shade50,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<BookProvider>(context, listen: false).fetchBooks();
      }
    });
  }

  void _showLinksQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => DefaultTabController(
        length: 2,
        child: AlertDialog(
          title: const Text('Project QR Codes', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TabBar(
                labelColor: Colors.indigo,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'GitHub Repo'),
                  Tab(text: 'Deployed Link'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                width: 300,
                child: TabBarView(
                  children: [
                    _buildQRCodeColumn(
                      'https://github.com/hardikgelani941-cloud/mad_ps_2', // Updated with your actual repo URL
                      'Scan to view source code on GitHub',
                    ),
                    _buildQRCodeColumn(
                      'https://y-daputbunc-hardikgelani941-clouds-projects.vercel.app/',
                      'Scan to view deployed project',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeColumn(String data, String description) {
    return Column(
      children: [
        QrImageView(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _showProjectInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                '📁 Project Folder Structure',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Card(
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'lib/\n├── models/ (Data structure)\n├── providers/ (Auth & Firestore Logic)\n├── routes/ (Navigation)\n├── screens/ (UI Layouts)\n├── utils/ (Helpers)\n└── main.dart (Entry point)',
                    style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                  ),
                ),
              ),
              const Divider(height: 30),
              const Text(
                '🔥 Firebase Features',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const ListTile(
                leading: Icon(Icons.login, color: Colors.orange),
                title: Text('Google Login'),
                subtitle: Text('Secure Auth using Google Sign-In'),
              ),
              const ListTile(
                leading: Icon(Icons.cloud_done, color: Colors.blue),
                title: Text('Firestore Data'),
                subtitle: Text('Real-time sync for Books & Library data'),
              ),
              const Divider(height: 30),
              const Text(
                '🚀 Deployment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const ListTile(
                leading: Icon(Icons.web, color: Colors.indigo),
                title: Text('Vercel Dashboard'),
                subtitle: Text('Live preview of the web application'),
              ),
              const ListTile(
                leading: Icon(Icons.link, color: Colors.blueGrey),
                title: Text('Live Link'),
                subtitle: Text('https://y-daputbunc-hardikgelani941-clouds-projects.vercel.app/'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Library Management', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Project Info',
            onPressed: () => _showProjectInfo(context),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_2),
            tooltip: 'Project QRs',
            onPressed: () => _showLinksQR(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookProvider.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.library_books_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your library is empty!', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3 / 2.8,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: bookProvider.books.length,
                itemBuilder: (ctx, i) {
                  final book = bookProvider.books[i];
                  final cardColor = cardColors[i % cardColors.length];
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          if (book.imageUrl != null)
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.35,
                                child: book.imageUrl!.startsWith('http')
                                  ? Image.network(book.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox())
                                  : Image.asset(book.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox()),
                              ),
                            ),
                          
                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (book.imageUrl != null)
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: book.imageUrl!.startsWith('http')
                                            ? Image.network(book.imageUrl!, height: 65, width: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                                            : Image.asset(book.imageUrl!, height: 65, width: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image)),
                                        ),
                                      )
                                    else
                                      const Icon(Icons.menu_book, size: 40, color: Colors.indigo),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('✍️ ${book.author}', style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 24),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
                                          onPressed: () => _confirmDelete(context, bookProvider, book.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(height: 24, thickness: 1.2),
                                Text('🆔 ISBN: ${book.isbn}', style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                                Text('📚 Qty: ${book.quantity}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo)),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: book.isIssued ? Colors.redAccent : Colors.greenAccent.shade700,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                                      ),
                                      child: Text(
                                        book.isIssued ? "ISSUED" : "AVAILABLE",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: book.isIssued,
                                      activeColor: Colors.redAccent,
                                      inactiveTrackColor: Colors.green.shade200,
                                      onChanged: (_) => bookProvider.toggleIssueStatus(book.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddEditBookScreen()),
        ),
        label: const Text('Add Book'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _confirmDelete(BuildContext context, BookProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to remove this book?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.deleteBook(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
